-- ИЗГЛЕДИ

-- Изгледите се пишат или в началото (на първия ред) в терминала за заявки, т.е. да няма нищо над него
-- или всички заявки над него да са с терминиращ GO след себе си.

-- View 1
-- Създаваме изглед doctors_of_philosophy , който извежда име и адрес на кураторите с титли Доктор по философия. 
-- Изгледът извежда и университета, които са завършили и също в колко изложби са взели участие.

CREATE VIEW doctors_of_philosophy AS
SELECT name, address, university, participation_in_exhibitions
FROM curators
WHERE curators.academic_title like 'Doctor of Philosophy'
GO


--Query 1: Изведете броя на кураторите които са доктори по философия и са завършили Станфордския университет.
SELECT COUNT(name) as Graduated_Stanford
FROM doctors_of_philosophy
WHERE doctors_of_philosophy.university = 'Stanfort University'
GO

--Query 2: Изведете имената на кураторите взели участие в повече от 3 изложби и завършили Yale University.
(SELECT name as curator
FROM doctors_of_philosophy
WHERE doctors_of_philosophy.participation_in_exhibitions >3)
INTERSECT
(SELECT name as curator
FROM doctors_of_philosophy
WHERE doctors_of_philosophy.university LIKE 'Yale University')
GO

-- View 2
-- Създаваме изгледа Cities_England, който извежда име, адрес и град на посетителите от градове в Англия. 
-- Изгледът извежда и галерията, за която имат карта, чиято цена е по-голяма от 30 евро.

CREATE VIEW Cities_England AS
SELECT name, address, city, gallery, price
FROM membership_cards
WHERE city IN ('Bristol','London', 'Liverpool', 'Cambridge', 'Coventry', 'Glastonbury', 'Lancaster', 'Manchester', 'Oxford') and price > 30
GO

-- Query 1: Изведете всички хора, които живеят в Лондон и имат достъп до галерия Древен Египет.
SELECT name as visitor
FROM Cities_England
WHERE gallery = 'Ancient Egypt' and city = 'London'
GO

--Query 2: Изведете градовете, от които има повече от един човек с карта. Изведете и броя на клиентите.
SELECT  city, COUNT(name) as Visitor_Number
FROM Cities_England
GROUP BY city
HAVING COUNT(name) > 1
GO

-- View 3
-- Създаваме изглед Sculptors, който извежда име на скулптурата, годината й на създаване, 
-- име на скулптора, годината му на раждане и на колко е оценета творбата му. 

CREATE VIEW Sculptors AS
SELECT sculptures.name AS sculpture, sculptures.year, sculptures.artist, artists.born AS Birthdate, sculptures.[estimate(EURO)] as price
FROM artists JOIN sculptures ON sculptures.artist = artists.name
GO


--Query 1: Изведете скулптурите, които са оценени на повече от 50 000.
SELECT sculpture
FROM Sculptors
WHERE price>50000
GO

--Query 2: Изведете скулптора с най-много скулптури и техният брой.
SELECT artist, COUNT(sculpture) as Number_of_sculptures
FROM Sculptors
GROUP BY artist
HAVING COUNT(sculpture) >= ALL(SELECT COUNT(sculpture) FROM sculptors GROUP BY artist)
GO

-- View 4
-- Създаваме изглед Painters, който извежда име на картината, име на художника, стилът мъ и на колко е оценена творбата му. 

CREATE VIEW Painters AS
SELECT paintings.name, paintings.artist, artists.style , paintings.[estimate(EURO)] AS price
FROM artists JOIN paintings ON artists.name = paintings.artist
GO

--Query 1: Изведете името и цената на картините, чиито имена започват с 'Т' са само от три думи.
(SELECT DISTINCT name as painting, price
FROM Painters
WHERE name LIKE 'T%' AND name LIKE '% % %')
EXCEPT
(SELECT DISTINCT name as painting, price
FROM Painters
WHERE name LIKE 'T%' AND name LIKE '% % % %')
GO

-- Query 2: Изведете името и средната цена на картината с най-висока средна цена.
SELECT name as painting, AVG(price) as Average_Price
FROM Painters
GROUP BY name
HAVING AVG(price) >= ALL(SELECT AVG(price) FROM painters GROUP BY name)
GO

--Query for sculptors and painters: Изведете Артистът, който има картини и скулптури. 
SELECT DISTINCT sculptors.artist as Artist
FROM Sculptors JOIN Painters ON Sculptors.artist = Painters.artist
GO

-- View 5
-- Създаваме изглед Asian_gallery, който извежда имента на картините и скулптурите от галерията "Азия". 
-- Изгледът извежда и съответните скулптори и художници. 

CREATE VIEW Asian_gallery 
(sculpture, painting, sculptor, painter) AS
SELECT sculptures.name , paintings.name , sculptures.artist, paintings.artist 
FROM sculptures JOIN paintings ON sculptures.gallery = paintings.gallery 
WHERE sculptures.gallery = 'Asian'
WITH CHECK OPTION
GO


--Query 1: Изведете всички художници от галерия "Азия" и броя на техните картини.
SELECT painter, COUNT(painting) as Number_of_paintings
FROM  Asian_gallery
GROUP BY painter
GO

--Query 2: Изведете скулпторите,чийто брой на скулптурите е по-голям от броя на картините на художникът с най-много творби.
SELECT sculptor
FROM  Asian_gallery
GROUP BY sculptor
HAVING COUNT(sculpture) > ALL(SELECT COUNT(painting)
FROM  asian_gallery
GROUP BY painter)
GO

-- ИНДЕКСИ 

CREATE INDEX index_paintings
ON paintings(catalog_number, name, year, artist, technique, style, movement, [height(mm)],[width(mm)],gallery,[estimate(EURO)]);

CREATE UNIQUE INDEX index_painting
ON paintings(catalog_number);

CREATE INDEX index_artefacts
ON artefacts(catalog_number,name, century, discovery_site, civilization, material, portable, count,	gallery, [estimate(EURO)]);

CREATE UNIQUE INDEX index_artefact
ON artefacts(catalog_number);


CREATE INDEX index_sculptures
ON sculptures(catalog_number, name, year, artist, material, country, [area_requiered(sq_cm)], gallery, [estimate(EURO)]);

CREATE UNIQUE INDEX index_sculpture
ON sculptures(catalog_number);


CREATE INDEX index_artists
ON artists(name, born, died, country, style);


CREATE INDEX index_membership_cards
ON membership_cards(name, address, city, date_of_birth, date_of_expiry, gallery, price);


CREATE INDEX index_galleries
ON galleries(name, most_famous_exhibit, [curator(EGN)], halls);


CREATE INDEX index_curators
ON curators(EGN, name, address, date_of_birth, university, date_of_appointment, academic_title, participation_in_exhibitions);
