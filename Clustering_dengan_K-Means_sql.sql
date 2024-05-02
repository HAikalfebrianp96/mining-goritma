USE training;
DROP TABLE IF EXISTS `customer_data`;
-- Membuat tabel contoh
CREATE TABLE `customer_data` (
  id INT PRIMARY KEY,
  age INT,
  income FLOAT,
  spend FLOAT
);

INSERT INTO customer_data VALUES
  (1, 25, 50000, 2000),
  (2, 35, 70000, 3500),
  (3, 40, 60000, 2500),
  (4, 28, 55000, 1800),
  (5, 32, 65000, 3200);

SELECT * FROM customer_data;

-- Menormalisasi data
CREATE TABLE normalized_data AS
SELECT
  id,
  (age - (SELECT MIN(age) FROM customer_data)) / (SELECT MAX(age) - MIN(age) FROM customer_data) AS normalized_age,
  (income - (SELECT MIN(income) FROM customer_data)) / (SELECT MAX(income) - MIN(income) FROM customer_data) AS normalized_income,
  (spend - (SELECT MIN(spend) FROM customer_data)) / (SELECT MAX(spend) - MIN(spend) FROM customer_data) AS normalized_spend
FROM customer_data;

-- Menghitung jarak antar data
CREATE TABLE distances AS
SELECT
  a.id AS id1,
  b.id AS id2,
  SQRT(POW(a.normalized_age - b.normalized_age, 2) + POW(a.normalized_income - b.normalized_income, 2) + POW(a.normalized_spend - b.normalized_spend, 2)) AS distance
FROM normalized_data a
CROSS JOIN normalized_data b;

-- Clustering dengan K-Means (k=2)
SET @k = 2;

CREATE TABLE clusters (
  id INT PRIMARY KEY,
  cluster_id INT
);


INSERT INTO clusters (id, cluster_id)
SELECT id, FLOOR(1 + RAND() * @k) 
FROM customer_data;

SELECT * FROM clusters;