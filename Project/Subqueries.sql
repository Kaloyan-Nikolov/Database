-- ПРИМЕРИ С ПОДЗАЯВКИ

-- QUERY 1

-- Намерете онези аретафкти, които са по-скъпи от най-известните такива в галериите.

SELECT a.name AS artefact_name, a.gallery AS gallery_name, a.[estimate(EURO)] AS [price(EURO)]
FROM artefacts a
WHERE a.[estimate(EURO)] > ALL (SELECT a.[estimate(EURO)] 
				  FROM galleries g 
				  LEFT JOIN artefacts a ON a.name = g.most_famous_exhibit
				  WHERE a.name IS NOT NULL)
ORDER BY a.name;
GO

-- QUERY 2

-- Намерете всички хора, които имат възможността да присъстват на изложенията на най-опитните 
-- (най-много участия в изложби) куратори.

SELECT m.name AS curator_name
FROM membership_cards m
WHERE m.gallery IN (SELECT g.name
		      FROM galleries g
		      WHERE g.[curator(EGN)] IN (SELECT c.egn
						   FROM curators c
						   WHERE c.participation_in_exhibitions >= ALL (SELECT participation_in_exhibitions
												FROM curators)))
ORDER BY m.name;
GO

-- QUERY 3

-- За всеки човек, който се казва Scott Norton, намерете онези художници/скулптористи, 
-- чиито творби може да разгледа на намалена цена.

SELECT p.artist AS artist_name, p.gallery AS gallery_name, t1.name, t1.address, t1.city, t1.date_of_birth
FROM paintings p
JOIN (SELECT gallery, name, address, city, date_of_birth
	FROM membership_cards
	WHERE name LIKE 'Scott Norton') t1 ON t1.gallery = p.gallery
UNION
SELECT s.artist AS artist_name, s.gallery AS gallery_name, t2.name, t2.address, t2.city, t2.date_of_birth
FROM sculptures s
JOIN (SELECT gallery, name, address, city, date_of_birth
	FROM membership_cards
	WHERE name LIKE 'Scott Norton') t2 ON t2.gallery = s.gallery
ORDER BY gallery_name;
GO

-- QUERY 4

-- Изведете името и адреса на куратора, който поддържа галерията, в която се намира най-скъпия и известен експонат.

SELECT c.name AS curator_name, c.egn
FROM curators c
WHERE c.egn LIKE (SELECT TOP 1 g.[curator(EGN)]
		    FROM galleries g
		    JOIN (SELECT p.name, p.[estimate(EURO)] AS price
			    FROM paintings p
			    UNION
			    SELECT a.name, a.[estimate(EURO)] AS price
			    FROM artefacts a
			    UNION
			    SELECT s.name, s.[estimate(EURO)] AS price
			    FROM sculptures s) t ON t.name = g.most_famous_exhibit
		    ORDER BY t.price DESC);
GO

-- QUERY 5

-- Да се изведе името и цената на най-скъпия експонат, който се намира в тази галерия,
-- чиято посетителска карта е най-скъпа.

SELECT TOP 1 t2.name AS exhibit_name, t2.price, g.name AS gallery_name
FROM galleries g
JOIN (SELECT m.gallery AS gallery_name
	FROM membership_cards m
	WHERE m.price >= ALL (SELECT m1.price
				FROM membership_cards m1)) t1 ON g.name = t1.gallery_name
JOIN (SELECT p.gallery, p.name, p.[estimate(EURO)] AS price
	FROM paintings p
	UNION
	SELECT a.gallery, a.name, a.[estimate(EURO)] AS price
	FROM artefacts a
	UNION
	SELECT s.gallery, s.name, s.[estimate(EURO)] AS price
	FROM sculptures s) t2 ON t2.gallery = g.name
ORDER BY t2.price DESC;
GO
