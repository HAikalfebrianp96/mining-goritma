USE training;
DROP TABLE IF EXISTS `network_logs`;

-- Membuat tabel log jaringan
CREATE TABLE network_logs (
  id INT PRIMARY KEY,
  source_ip VARCHAR(15),
  destination_ip VARCHAR(15),
  bytes_sent INT
);

-- Memasukkan data ke dalam tabel, dengan satu nilai yang sangat tinggi sebagai anomali
INSERT INTO network_logs VALUES
  (1, '192.168.1.100', '10.0.0.1', 1000),
  (2, '192.168.1.101', '10.0.0.1', 1200),
  (3, '192.168.1.102', '10.0.0.1', 1300),
  (4, '192.168.1.103', '10.0.0.1', 1400),
  (5, '192.168.1.104', '10.0.0.1', 1500),
  (6, '192.168.1.105', '10.0.0.1', 50000); -- Anomali yang lebih jelas

-- Menghapus kemudian membuat tabel z_scores untuk menghitung dan menyimpan z-score
DROP TABLE IF EXISTS z_scores;
CREATE TABLE z_scores AS
SELECT
  id,
  (bytes_sent - (SELECT AVG(bytes_sent) FROM network_logs)) / (SELECT STD(bytes_sent) FROM network_logs) AS z_score
FROM 
  network_logs;

-- Menampilkan id, IP sumber, IP tujuan, bytes dikirim, dan z-score
-- dari log yang memiliki z-score lebih dari 2 (anomali yang lebih sensitif)
SELECT nl.id, nl.source_ip, nl.destination_ip, nl.bytes_sent, zs.z_score
FROM network_logs nl
JOIN z_scores zs ON nl.id = zs.id
WHERE ABS(zs.z_score) > 2;