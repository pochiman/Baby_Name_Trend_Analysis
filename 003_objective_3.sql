USE baby_names_db;

-- OBJECTIVE 3: COMPARE POPULARITY ACROSS REGIONS

-- 1. Return the number of babies born in each of the six regions 
-- (Hint: The state of MI should be in the Midwest region, but it is not represented that way)

SELECT * FROM regions;

SELECT DISTINCT Region FROM regions;

WITH clean_regions AS (SELECT State,
	CASE WHEN Region = 'New England' THEN 'New_England' ELSE Region END AS clean_region
FROM regions
UNION
SELECT 'MI' AS State, 'Midwest' AS Region)

SELECT clean_region, SUM(Births) AS num_babies
FROM names n LEFT JOIN clean_regions cr
	ON n.State = cr.State
GROUP BY clean_region;

-- 2. Return the 3 most popular girl names and 3 most popular boy names within each region.

SELECT * FROM

(WITH babies_by_region AS (
	WITH clean_regions AS (SELECT State,
		CASE WHEN Region = 'New England' THEN 'New_England' ELSE Region END AS clean_region
	FROM regions
	UNION
	SELECT 'MI' AS State, 'Midwest' AS Region)

	SELECT cr.clean_region, n.Gender, n.Name, SUM(n.Births) AS num_babies
	FROM names n LEFT JOIN clean_regions cr
		ON n.State = cr.State
	GROUP BY cr.clean_region, n.Gender, n.Name)

SELECT clean_region, Gender, Name,
	ROW_NUMBER() OVER (PARTITION BY clean_region, gender ORDER BY num_babies DESC) AS popularity
FROM babies_by_region) AS region_popularity

WHERE popularity < 4;