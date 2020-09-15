USE ships

--1
SELECT class, country 
FROM classes
WHERE numguns < 10;

--2
SELECT name as shipname
FROM ships
WHERE launched < 1918;

--3
SELECT ship, battle
FROM outcomes
where result LIKE 'sunk';

--4
SELECT name
FROM ships
WHERE class LIKE name;

--5
SELECT name
FROM ships
WHERE name LIKE 'R%';

--6
SELECT name
FROM ships
WHERE name LIKE '% %'