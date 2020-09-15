USE movies;

--1
SELECT address 
FROM studio
WHERE name LIKE 'Disney';

--2
SELECT birthdate
FROM moviestar
WHERE name LIKE 'Jack Nicholson'

--3
SELECT starname
FROM starsin
WHERE movieyear = 1980 OR movietitle LIKE '% Knight %';

--4
SELECT name 
FROM movieexec
WHERE networth > 10000000;

--5
SELECT name
FROM moviestar
WHERE gender LIKE 'm' OR address LIKE 'Prefect Rd';