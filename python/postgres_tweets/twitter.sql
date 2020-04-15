CREATE TABLE twitter(
	Title VARCHAR,
	tweet VARCHAR,
	Recommended INT
);

SELECT * FROM twitter;
SELECT COUNT(recommended) FROM twitter;
SELECT COUNT(DISTINCT recommended) FROM twitter;
SELECT MAX(LENGTH(tweet)) FROM twitter;