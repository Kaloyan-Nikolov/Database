-- ПРИМЕРИ СЪС СЪЕДИНЕНИЯ

-- QUERY 1

-- Изведете имената, адреса и града на местообитание на хората, които имат намаление на посещаването на галерии,
-- които имат скулптори от Италия.

SELECT DISTINCT m.name, m.address, m.city
FROM membership_cards m
JOIN galleries g ON g.name = m.gallery
JOIN sculptures s ON s.gallery = g.name
WHERE s.country LIKE 'Italy'
ORDER BY m.name;
GO

-- QUERY 2

-- Изведете цената на онези карти за галерии, които са били продадени поне 2 пъти.

SELECT DISTINCT m1.price
FROM membership_cards m1
CROSS JOIN membership_cards m2
WHERE m2.name != m1.name AND m1.price = m2.price
ORDER BY m1.price;
GO

-- QUERY 3

-- Намерете онези хора, които имат карти за безплатен вход в галерии, в които кураторите са по-млади от тях и има
-- артефакти, датиращи от преди Христа.

SELECT DISTINCT m.name, m.date_of_birth
FROM membership_cards m
JOIN curators c ON c.date_of_birth < m.date_of_birth
JOIN galleries g ON g.[curator(EGN)] = c.egn AND g.name = m.gallery
JOIN artefacts a ON a.gallery = g.name
WHERE a.century LIKE '%BC'
ORDER BY m.name;
GO

-- QUERY 4

-- Изведете имената на онези куратори, които имат докторска степен и поддържат галерии, в които има преносими
-- артефакти.

SELECT DISTINCT c.name AS curator_name, c.academic_title, g.name AS gallery_name
FROM galleries g
JOIN artefacts a ON a.gallery = g.name
RIGHT JOIN curators c ON c.egn = g.[curator(EGN)]
WHERE a.portable LIKE 'y' AND c.academic_title LIKE 'Doctor%';
GO

-- QUERY 5

-- Изведете имената и ЕГН-тата на онези куратори, които поддържат галерии, в които има само артефакти.

SELECT DISTINCT c.name, c.egn
FROM galleries g
LEFT JOIN paintings p ON p.gallery = g.name
LEFT JOIN sculptures s ON s.gallery = g.name
LEFT JOIN artefacts a ON a.gallery = g.name
LEFT JOIN curators c ON c.egn = g.[curator(EGN)]
WHERE p.name IS NULL AND s.name IS NULL;
GO
