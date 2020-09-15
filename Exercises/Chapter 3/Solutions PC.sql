USE pc

--1 
SELECT DISTINCT pr.maker
FROM product pr
JOIN pc p ON pr.model = p.model
WHERE p.speed > 500;

--2
SELECT code, model, price
FROM printer
WHERE price >= ALL(SELECT price
				   FROM printer);

--3
SELECT *
FROM laptop
WHERE speed < ALL(SELECT speed
				  FROM pc);

--4
SELECT model, price
FROM laptop
WHERE price >= ALL(SELECT price FROM laptop
				   UNION
				   SELECT price FROM pc
				   UNION
				   SELECT price FROM printer)
UNION
SELECT model, price
FROM pc
WHERE price >= ALL(SELECT price FROM laptop
				   UNION
				   SELECT price FROM pc
				   UNION
				   SELECT price FROM printer)
UNION
SELECT model, price
FROM printer
WHERE price >= ALL(SELECT price FROM laptop
				   UNION
				   SELECT price FROM pc
				   UNION
				   SELECT price FROM printer);

--5
SELECT p.maker
FROM product p
JOIN printer pr ON p.model = pr.model
WHERE pr.color LIKE 'y'
AND pr.price <= ALL(SELECT price
					FROM printer
					WHERE color like 'y');

--6
SELECT DISTINCT pr.maker
FROM product pr
JOIN pc p ON pr.model = p.model
WHERE p.ram <= ALL(SELECT ram FROM pc)
AND p.speed >= ALL(SELECT speed FROM pc where ram = p.ram);