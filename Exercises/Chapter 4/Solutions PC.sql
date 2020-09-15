USE pc

--1
SELECT pr.maker, pr.model, pr.type
FROM product pr
LEFT JOIN laptop l ON pr.model = l.model
LEFT JOIN pc p ON pr.model = p.model
LEFT JOIN printer pt ON pr.model = pt.model
WHERE l.price IS NULL
AND p.price IS NULL
AND pt.price IS NULL;

--2
SELECT pr.maker
FROM product pr
JOIN laptop l ON pr.model = l.model
INTERSECT
SELECT pr.maker
FROM product pr
JOIN printer p ON pr.model = p.model;
 
 --3
 SELECT DISTINCT l1.hd
 FROM laptop l1
 JOIN laptop l2 ON l1.hd = l2.hd
 WHERE l1.model > l2.model

 --4
 SELECT *
 FROM product pr
 RIGHT JOIN pc p ON pr.model = p.model
 WHERE pr.maker is NULL