USE PC;
--1
SELECT MODEL, speed AS MHZ, hd AS GB 
FROM pc
WHERE price < 1200 ;

--2
SELECT DISTINCT maker
FROM product
WHERE type LIKE 'printer';

--3
SELECT model, hd, screen 
FROM laptop
WHERE price > 1000;

--4
SELECT * 
FROM printer
WHERE color LIKE 'y';

--5
SELECT model, speed, hd 
FROM pc
WHERE (cd LIKE '12x' OR cd LIKE '16x') AND price < 2000;