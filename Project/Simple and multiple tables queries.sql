-- ПРИМЕРИ С ПРОСТИ ЗАЯВКИ
-- QUERY 1

-- Намерете имената на всички картини, чиято стойност е повече от 11000 евро

SELECT paintings.name 
FROM paintings
where [estimate(EURO)] > 11000
GO

-- QUERY 2

-- Намерете цените на всички абонаментни карти за галерията 'Ancient Greece'

SELECT price
FROM membership_cards
WHERE gallery='Ancient Greece'
GO

-- QUERY 3

-- Намерете имената на всички галерии, където има артефакти от Древен Египет, без да се дублират

SELECT DISTINCT gallery
FROM artefacts
WHERE artefacts.civilization='Ancient Egypt'
GO

-- QUERY 4

--  Намерете имената и адресите на всички хора с абонаментни карти, чиито адреси започват с '2'

SELECT name,address
FROM membership_cards
WHERE address LIKE '2 %'
GO

-- QUERY 5

-- Намерете имената и датите на започване на работа на всички куратори, които са завършили Yale University.
-- Задайте псевдоними на атрибутите за за име и датата съответно  'name‘ и ‘Started working on'

SELECT name AS 'Curator', date_of_appointment AS 'Started working on'
FROM curators
WHERE university = 'Yale University'
GO
-----------------------------------------------------------------------------------------------------------------------------------

-- ПРИМЕРИ СЪС ЗАЯВКИ ВЪРХУ ДВЕ ИЛИ ПОВЕЧЕ РЕЛАЦИИ

-- QUERY 1

-- Намерете имената на всички художници, който са от Италия и стилът на картините им е 'Landscape'

(SELECT artist FROM paintings WHERE style='Landscape')
INTERSECT
(SELECT  name FROM artists WHERE country='Italy')
GO

-- QUERY 2

-- Намерете всички картини и скулптури, чиито цени са поне 500 000 евро

(SELECT DISTINCT paintings.name,paintings.[estimate(EURO)] FROM paintings WHERE paintings.[estimate(EURO)]>=500000 )
UNION 
(SELECT DISTINCT sculptures.name,sculptures.[estimate(EURO)] FROM sculptures WHERE sculptures.[estimate(EURO)]>=500000)
GO

-- QUERY 3

-- Намерете имената на галериите, в които има артефакти от камък, без тези, в които има картини, чиито имена започват с 'А'

(SELECT gallery FROM artefacts WHERE artefacts.material='stone')
EXCEPT
(SELECT gallery FROM paintings WHERE paintings.name LIKE 'A%' )
GO

-- QUERY 4

-- Намерете имената на картините, които са нарисувани след 2000 година или са най-известното изложение в галерията
-- Задайте псевдоним на атрибута за име на картината - 'painting'

SELECT DISTINCT paintings.name AS painting
FROM paintings, galleries 
WHERE  paintings.name = galleries.most_famous_exhibit 
OR paintings.year>2000
GO

-- QUERY 5

-- Намерете имената на галериите и кураторите, които са завършили Stanfort University.
-- Задайте псевдоним на атрибутите за име съответно gallery и curator

SELECT DISTINCT galleries.name AS gallery, curators.name AS curator
FROM galleries,curators
WHERE curators.university='Stanfort University' AND galleries.[curator(EGN)]=curators.EGN
GO
