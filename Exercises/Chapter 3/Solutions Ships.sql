USE ships

--1
SELECT DISTINCT country
FROM classes
WHERE numguns >= ALL(SELECT numguns
		     FROM CLASSES);

--2
SELECT DISTINCT class 
FROM ships
WHERE name IN (SELECT ship
	       FROM outcomes
	       WHERE result LIKE 'sunk');

--3
SELECT name, class
FROM ships
WHERE class IN (SELECT class
		FROM classes
		WHERE bore=16);

--4
SELECT battle
FROM outcomes
WHERE ship IN (SELECT name
	       FROM ships
	       WHERE class LIKE 'Kongo');  

--5
SELECT class, name
FROM ships
WHERE class IN (SELECT class
		FROM classes c1
		WHERE numguns >= ALL(SELECT numguns
				     FROM classes c2
				     WHERE c1.bore = c2.bore) )
ORDER BY class;
