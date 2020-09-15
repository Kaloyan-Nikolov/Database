USE movies

--1
SELECT name
FROM moviestar
WHERE gender LIKE 'F'
AND name IN (SELECT name
	     FROM MOVIEEXEC
	     WHERE NETWORTH > 10000000);

--2
SELECT name
FROM moviestar
EXCEPT
SELECT name
FROM movieexec;

--3
SELECT title
FROM movie
WHERE length > (SELECT length
		FROM movie
		WHERE title LIKE 'Star Wars');

--4
SELECT m.title, e.name
FROM movieexec e
JOIN movie m ON e.cert# = m.producerc#
WHERE e.networth > (SELECT networth
		    FROM movieexec
		    WHERE name LIKE 'Merv Griffin');
		    
