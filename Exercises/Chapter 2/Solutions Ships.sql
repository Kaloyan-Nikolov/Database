USE ships

--1
SELECT s.name
from ships s
JOIN classes c ON s.class = c.class
WHERE c.displacement > 50000;

--2
select s.name, c.DISPLACEMENT, c.NUMGUNS
from classes c
JOIN ships s ON c.class = s.class
where s.name IN (SELECT ship
				 FROM outcomes
				 WHERE battle LIKE 'Guadalcanal') 

--3
SELECT DISTINCT a.country 
FROM classes a
JOIN classes b ON a.country LIKE b.country
WHERE a.type like 'bb' and b.type like 'bc';

--4
SELECT a.ship
FROM OUTCOMES a, OUTCOMES b, battles bat1, battles bat2
WHERE a.result LIKE 'damaged' 
AND a.SHIP = b.SHIP --the two outcomes are for the same ship
AND bat1.name LIKE a.battle 
AND bat2.name LIKE b.battle
AND bat1.date < bat2.date;