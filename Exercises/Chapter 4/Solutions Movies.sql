USE movies

--1
SELECT m.title, e.name
FROM movie m
JOIN movieexec e ON m.producerc# = e.cert#
WHERE m.producerc# IN (SELECT producerc#
		       FROM movie
		       WHERE title LIKE 'Star Wars');

--2
SELECT DISTINCT e.name
FROM movieexec e
JOIN movie m ON m.producerc# = e.cert#
JOIN starsin s ON s.movietitle LIKE m.title
WHERE s.starname LIKE 'Harrison Ford';

--3
SELECT DISTINCT m.studioname, s.starname
FROM starsin s
JOIN movie m ON s.movietitle LIKE m.title
ORDER BY m.studioname;

--4
SELECT s.starname, e.networth, m.title 
FROM movieexec e
JOIN movie m ON m.producerc# = e.cert#
JOIN starsin s ON m.title LIKE s.movietitle
WHERE e.networth >= ALL(SELECT networth
			FROM movieexec);

--5
SELECT m.name, s.movietitle
FROM moviestar m
LEFT JOIN starsin s ON m.name LIKE s.starname
WHERE s.movietitle IS NULL;
