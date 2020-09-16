-- ПРИМЕРИ С ГРУПИРАНЕ И АГРЕГАЦИЯ

--QUERY 1

-- Да се изведе за всяка от галериите броя на тези автори на скулптори, 
-- които имат повече от 1 скулптура, изложена в музея и скулптурите им се оценяват средно на поне 100000 евро.

SELECT s1.gallery, COUNT(DISTINCT artist) AS number_of_artists 
FROM sculptures s1
WHERE s1.artist IN (SELECT artist 
					          FROM sculptures
					          GROUP BY artist
					          HAVING COUNT(*) > 1 AND AVG([estimate(EURO)]) > 100000)
GROUP BY s1.gallery
ORDER BY number_of_artists DESC
GO

--QUERY 2

-- Да се изведат имената на галериите с най-ниска и най-висока средна цена на посетителска карта,
-- броя на картите за тях и средната цена на картите за тези галерии.

SELECT gallery, COUNT(*) AS cards, CAST(AVG(price) AS DECIMAL(4,2)) AS avg_price
FROM membership_cards m
GROUP BY gallery
HAVING AVG(m.price) <= ALL(SELECT AVG(price)
						               FROM membership_cards
						                GROUP BY gallery)
OR AVG(m.price) >= ALL(SELECT AVG(price)
						FROM membership_cards
						GROUP BY gallery)
GO

-- QUERY 3

-- За всички автори на скулптури, които творят към днешна дата, да се изведат име, брой техни скулптори, изложени в музея, 
-- стойността на най-скъпата им творба и средната стойност на всички техни скулптури.

SELECT artist, COUNT(*) AS number_of_sculptures, MAX([estimate(EURO)]) AS most_expensive_sculptures,
		AVG([estimate(EURO)]) AS avg_price
FROM sculptures 
WHERE artist in (SELECT name
				FROM artists
				WHERE died IS NULL)
GROUP BY artist
GO

--QUERY 4

-- Да се изведе преоценка на стойността на всички картини, скулптури и артефакти от галерия "Класицизъм" в US долари
-- Приемаме, че текущият курс на евро-долар е 1,09.
-- Резултатът да се закръгли до цяло число надолу.

SELECT FLOOR((SUM(ISNULL(p.[estimate(EURO)],0)) + 
SUM(ISNULL(s.[estimate(EURO)],0)) + SUM(ISNULL(a.[estimate(EURO)],0))) * 1.09) AS [estimate(USD)] 
FROM paintings p
FULL JOIN sculptures s ON p.catalog_number = s.catalog_number
FULL JOIN artefacts a ON p.catalog_number = a.catalog_number
WHERE p.gallery LIKE 'Classicism' OR s.gallery LIKE 'Classicism' OR a.gallery LIKE 'Classicism'
GO

--QUERY 5

-- Да се изведе общият брой експонати във всяка галерия. 
-- Резултатът да се сортира в низходящ ред спрямо броя на експонатите в галерията.

SELECT t.gallery_name, COUNT(*) AS exhibit_count
FROM (SELECT g.name AS gallery_name, p.name AS exhibit_name
	  FROM galleries g
	  JOIN paintings p ON p.gallery = g.name
	  UNION
	  SELECT g.name AS gallery_name, a.name AS exhibit_name
	  FROM galleries g
	  JOIN artefacts a ON a.gallery = g.name
	  UNION
	  SELECT g.name AS gallery_name, s.name AS exhibit_name
	  FROM galleries g
	  JOIN sculptures s ON s.gallery = g.name) t
GROUP BY t.gallery_name
ORDER BY exhibit_count DESC
GO

--QUERY 6

-- Да се изведе за всяка галерия авторът на най-много експонати в съответната галерия и техния брой.
-- Резултатът да се сортира възходящо по името на галерията.

SELECT gallery, artist, COUNT(*) AS number_exhibits
FROM ( SELECT g.name AS gallery, p.name AS exhibit_name, artist
	FROM galleries g
	JOIN paintings p ON p.gallery = g.name
	UNION ALL
	SELECT g.name AS gallery, s.name AS exhibit_name, artist
	FROM galleries g
	JOIN sculptures s ON s.gallery = g.name ) d
GROUP BY gallery, artist
HAVING COUNT(*) >= ALL(SELECT COUNT(*)
				   FROM ( SELECT g.name AS gallery, p.name AS exhibit_name, artist
						  FROM galleries g
						  JOIN paintings p ON p.gallery = g.name
						  UNION ALL
						  SELECT g.name AS gallery, s.name AS exhibit_name, artist
						  FROM galleries g
						  JOIN sculptures s ON s.gallery = g.name ) d2
					WHERE d.gallery = d2.gallery
					GROUP BY gallery, artist)
ORDER BY gallery
GO

--QUERY 7

-- За галериите с поне 2 зали, в които печалбата от посетителски карти е по-голяма от 1250 евро и броят
-- на закупените карти е поне 23, да се изведе име на галерията, брой закупени карти, приходи, най-известен експонат и
-- брой зали в галерията. Полученият резултат да се сортира низходящо по броя карти.

SELECT t.gallery, t.cards, t.profit, g.most_famous_exhibit, g.halls
FROM (SELECT gallery, SUM(price) AS profit, COUNT(*) AS cards
	FROM membership_cards 
	GROUP BY gallery
	HAVING SUM(price) > 1250 AND COUNT(*) >= 23 ) t
JOIN galleries g ON t.gallery = g.name
WHERE g.halls > 2
ORDER BY cards DESC
GO

--QUERY 8

-- Да се намери художникът с най-голяма разлика в годините на създаване на най-ранната и на най-късната му картина, които притежава музея.
-- Да се изведат освен името му, колко е разликата в годините и какъв е стилът, в който твори.

SELECT TOP 1 p1.artist, ((MAX(p1.year)) - (MIN(p1.year))) AS diff, (SELECT a.style FROM artists a 
																	WHERE a.name = p1.artist)	AS style												 
FROM paintings p1
GROUP BY p1.artist
ORDER BY diff DESC, artist
GO

--QUERY 9

-- Медианата е число, разделящо горната половина на набор от данни от долната половина.
-- Изведете стойността на този артефакт от Древна Гърция, чиято оценка се явява медиана като се
-- посочат неговите номер, име, материал и оценка в евро.

SELECT a1.catalog_number, a1.name, a1.material, a1.[estimate(EURO)]
FROM artefacts a1 
WHERE gallery LIKE 'Ancient Greece' AND 
	(SELECT COUNT(*) 
     FROM artefacts 
     WHERE gallery = a1.gallery AND [estimate(EURO)] <= a1.[estimate(EURO)]) = (SELECT COUNT(*) 
													  FROM artefacts
													  WHERE gallery = a1.gallery AND [estimate(EURO)] >= a1.[estimate(EURO)]);
GO

--QUERY 10

-- Да се изведе за всяка галерия броя на тези картини, на които площта е по-голяма или равна на площта 
-- на най-голямата картина на Josef Abel. Също така да се покаже за всяка галерия, каква е средната
-- стойност на тези картини и резултата да се сортира възходящо по средната стойност на картините.

SELECT p1.gallery,  COUNT(*) AS number_paintings, AVG(p1.[estimate(EURO)]) AS avg_price
FROM paintings p1
where (CAST(p1.[height(mm)] AS INT) * CAST(p1.[width(mm)] AS INT)) >=  
		(SELECT MAX(CAST(p2.[height(mm)] AS INT) * CAST(p2.[width(mm)] AS INT))
		FROM paintings p2
		WHERE p2.artist LIKE 'Josef Abel' )
GROUP BY p1.gallery
HAVING COUNT(*) > 2
ORDER BY avg_price
GO
