CREATE DATABASE IF NOT EXISTS dictionary_db;
USE dictionary_db;

CREATE TABLE word_group (id INTEGER PRIMARY KEY AUTOINCREMENT,fword TEXT NOT NULL,
sword TEXT NOT NULL);

INSERT INTO word_group (fword, sword) VALUES
('hot', 'summer'),('cold', 'winter'),('happy', 'joy'),('sad', 'tears'),
('strong', 'muscle'),('weak', 'fragile'),('fast', 'speed'),('slow', 'turtle'),('light', 'feather'),
('dark', 'night'),('rain', 'umbrella'),('snow', 'flakes'),
('fire', 'burn'),('water', 'ocean'),('hello', 'world');
