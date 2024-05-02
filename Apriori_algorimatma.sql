USE training;
DROP TABLE IF EXISTS `transactions`;

-- Membuat tabel contoh
CREATE TABLE transactions (
  id INT PRIMARY KEY,
  items SET('Roti', 'Susu', 'Telur', 'Keju', 'Daging')
);

INSERT INTO transactions VALUES
  (1, 'Roti,Susu,Telur'),
  (2, 'Roti,Susu,Keju'),
  (3, 'Susu,Telur,Daging'),
  (4, 'Roti,Susu,Keju,Daging'),
  (5, 'Roti,Susu,Daging');

DROP TABLE IF EXISTS itemset_supports;
-- Menghitung support untuk setiap itemset
CREATE TABLE itemset_supports AS
SELECT item, COUNT(*) AS support
FROM (
  SELECT id, SUBSTRING_INDEX(SUBSTRING_INDEX(items, ',', numbers.n), ',', -1) AS item
  FROM transactions, 
       (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) numbers
  WHERE n <= CHAR_LENGTH(items) - CHAR_LENGTH(REPLACE(items, ',', '')) + 1
) AS items_exploded
GROUP BY item;

--- Membuat contoh sederhana dari aturan asosiasi (sudah diubah untuk menyederhanakan)
CREATE TABLE association_rules AS
SELECT 'Roti => Susu' AS rule, 
       (SELECT support FROM itemset_supports WHERE item = 'Roti') / 
       (SELECT COUNT(*) FROM transactions) AS confidence;
       
SELECT * FROM association_rules;