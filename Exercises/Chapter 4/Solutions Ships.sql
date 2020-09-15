USE ships

--1
SELECT *
FROM ships s
JOIN classes c ON s.class LIKE c.class
ORDER BY s.name

--2
SELECT *
FROM ships s
RIGHT JOIN classes c ON s.class LIKE c.class
WHERE s.name IS NOT NULL OR c.class IN (SELECT DISTINCT name
										FROM ships)
ORDER BY s.name;

--3
SELECT c.country, s.name
FROM ships s
JOIN classes c ON s.class LIKE c.class
LEFT JOIN outcomes o ON s.name LIKE o.ship
WHERE o.ship is NULL
ORDER BY c.country;

--4
SELECT s.name AS [Ship Name]
FROM ships s
JOIN classes c ON s.class LIKE c.class
WHERE c.numguns >= 7 AND s.launched = 1916

--5
SELECT s.name, o.battle, b.date
FROM ships s
JOIN outcomes o ON s.name LIKE o.ship
JOIN battles b ON  o.battle LIKE b.name
WHERE o.result LIKE 'sunk'
ORDER BY o.battle;

--6
SELECT s.name, c.displacement, s.launched
FROM ships s
JOIN classes c ON s.class LIKE c.class
WHERE s.name LIKE s.class;

--7
SELECT c.class, c.type, c.country, c.numguns, c.bore, c.displacement
FROM classes c
LEFT JOIN ships s ON c.class LIKE s.class
WHERE s.name IS NULL;

--8
SELECT s.name, c.displacement, c.numguns, o.result
FROM ships s
JOIN classes c ON s.class LIKE c.class
JOIN outcomes o ON s.name LIKE o.ship
WHERE o.battle LIKE 'North Atlantic';