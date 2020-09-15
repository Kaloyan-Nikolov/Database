USE pc

--1
SELECT p.maker, l.speed
FROM product p
JOIN laptop l ON p.model = l.model
WHERE hd > 9;

--2
SELECT model, price
FROM pc
WHERE model in (SELECT model FROM product WHERE maker LIKE 'B')
UNION
SELECT model, price
FROM laptop
WHERE model in (SELECT model FROM product WHERE maker LIKE 'B')
UNION
SELECT model, price
FROM printer
WHERE model in (SELECT model FROM product WHERE maker LIKE 'B');

--3
SELECT DISTINCT maker
FROM product
WHERE type LIKE 'laptop'
except
SELECT DISTINCT maker
FROM product
WHERE type LIKE 'pc'

--4
SELECT DISTINCT a.hd
FROM pc a
JOIN pc b ON a.hd = b.hd
WHERE a.code != b.code;

--5
SELECT a.model, b.model
from pc a
JOIN pc b ON a.hd = b.hd AND a.speed = b.speed
WHERE a.model < b.model 

--6
SELECT DISTINCT maker
FROM product p 
WHERE model in (SELECT model
				FROM pc 
				WHERE speed > 400 
				GROUP BY model HAVING COUNT(model)>1);