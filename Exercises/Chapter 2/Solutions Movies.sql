USE movies

--1
SELECT name 
FROM moviestar
WHERE gender LIKE 'M' and name IN ( SELECT starname 
				    FROM starsin 
				    WHERE movietitle LIKE 
				    'The Usual Suspects' );

--2
SELECT n.starname 
FROM starsin n
JOIN movie m ON m.title = n.movietitle AND m.year = n.movieyear
WHERE n.movieyear = 1995 AND m.studioname LIKE 'MGM';

--3
SELECT DISTINCT n.name
FROM movieexec n
JOIN movie m ON n.CERT# = m.PRODUCERC# 
WHERE m.studioname LIKE 'MGM'

--4
SELECT title
FROM movie
WHERE length > (SELECT length 
		FROM movie
		WHERE title LIKE 'star wars');

--5
SELECT name 
FROM movieexec
WHERE networth > (SELECT networth
		  FROM movieexec
		  WHERE name LIKE 'stephen spielberg'); 

--6
SELECT m.title
FROM movie m
JOIN movieexec n ON n.CERT# = m.PRODUCERC#
WHERE n.NETWORTH > (SELECT NETWORTH
		    FROM MOVIEEXEC
		    WHERE name LIKE 'stephen spielberg');
