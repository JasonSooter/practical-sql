--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- Chapter 5 Code Examples
--------------------------------------------------------------
-- Listing 5-1: Basic addition, subtraction and multiplication with SQL
--
-- addition

SELECT
  2 + 2;

-- subtraction

SELECT
  9 - 1;

-- multiplication

SELECT
  3 * 4;

-- Listing 5-2: Integer and decimal division with SQL
--
-- integer division

SELECT
  11 / 6;

-- modulo division

SELECT
  11 % 6;

-- decimal division

SELECT
  11.0 / 6;

-- Use CAST to change the data type of a value

SELECT
  CAST(11 AS numeric(3, 1)) / 6;

-- Listing 5-3: Exponents, roots and factorials with SQL
--
-- exponentiation

SELECT
  3 ^ 4;

-- square root (operator)

SELECT
  |/ 10;

-- square root (function)

SELECT
  sqrt(10);

-- cube root

SELECT
  ||/ 10;

-- factorial

SELECT
  4 !;

--
-- Order of operations
-- answer: 79
--

SELECT
  7 + 8 * 9;

--
-- Order of operations
-- answer: 135
--

SELECT
  (7 + 8) * 9;

--
-- answer: 26
--

SELECT
  3 ^ 3 - 1;

-- answer: 9

SELECT
  3 ^ (3 - 1);

--
-- Listing 5-4: Selecting Census population columns
-- by race with aliases
--

SELECT
  geo_name,
  state_us_abbreviation AS "st",
  p0010001 AS "Total Population",
  p0010003 AS "White Alone",
  p0010004 AS "Black or African American Alone",
  p0010005 AS "Am Indian/Alaska Native Alone",
  p0010006 AS "Asian Alone",
  p0010007 AS "Native Hawaiian and Other Pacific Islander Alone",
  p0010008 AS "Some Other Race Alone",
  p0010009 AS "Two or More Races"
FROM
  us_counties_2010;

--
-- Listing 5-5: Adding two columns in us_counties_2010
--

SELECT
  geo_name,
  state_us_abbreviation,
  p0010003 AS "White Alone",
  p0010004 AS "Black Alone",
  p0010003 + p0010004 AS "Total White and Black"
FROM
  us_counties_2010;

--
-- Listing 5-6: Checking Census data totals
--

SELECT
  geo_name,
  state_us_abbreviation AS "st",
  p0010001 AS "Total",
  p0010003 + p0010004 + p0010005 + p0010006 + p0010007 + p0010008 + p0010009 AS "All Races",
  (p0010003 + p0010004 + p0010005 + p0010006 + p0010007 + p0010008 + p0010009) - p0010001 AS "Difference"
FROM
  us_counties_2010
ORDER BY
  "Difference" DESC;

--
-- Listing 5-7: Calculating the percent of the population that is
-- Asian by county (percent of the whole)
--

SELECT
  geo_name,
  state_us_abbreviation AS "st",
  (CAST(p0010006 AS numeric(8, 1)) / p0010001) * 100 AS "pct_asian"
FROM
  us_counties_2010
ORDER BY
  "pct_asian" DESC;

--
-- Listing 5-8: Calculating percent change
--

CREATE TABLE percent_change (
  department varchar(20),
  spend_2014 numeric(10, 2),
  spend_2017 numeric(10, 2)
);

INSERT INTO percent_change
    VALUES ('Building',
      250000,
      289000),
    ('Assessor',
      178556,
      179500),
    ('Library',
      87777,
      90001),
    ('Clerk',
      451980,
      650000),
    ('Police',
      250000,
      223000),
    ('Recreation',
      199000,
      195000);
SELECT
  department,
  spend_2014,
  spend_2017,
  round((spend_2017 - spend_2014) / spend_2014 * 100, 1) AS "pct_change"
FROM
  percent_change;

--
-- Listing 5-9: Using sum() and avg() aggregate functions
--

SELECT
  sum(p0010001) AS "County Sum",
  round(avg(p0010001), 0) AS "County Average"
FROM
  us_counties_2010;

--
-- Listing 5-10: Testing SQL percentile functions
--

CREATE TABLE percentile_test (
  numbers integer
);

INSERT INTO percentile_test (numbers)
    VALUES (1),
    (2),
    (3),
    (4),
    (5),
    (6);
--
-- Select with _cont & _disc to see the difference
--

SELECT
  percentile_cont(.5)
  WITHIN GROUP (ORDER BY numbers),
  percentile_disc(.5)
  WITHIN GROUP (ORDER BY numbers)
FROM
  percentile_test;

--
-- Listing 5-11: Using sum(), avg(), and percentile_cont() aggregate functions
--

SELECT
  sum(p0010001) AS "County Sum",
  round(avg(p0010001), 0) AS "County Average",
  percentile_cont(.5)
  WITHIN GROUP (ORDER BY p0010001) AS "County Median"
FROM
  us_counties_2010;

--
-- Listing 5-12: Passing an array of values to percentile_cont()
-- quartiles
--

SELECT
  percentile_cont(ARRAY[.25,.5,.75])
  WITHIN GROUP (ORDER BY p0010001) AS "quartiles"
FROM
  us_counties_2010;

SELECT
  percentile_cont(.25)
  WITHIN GROUP (ORDER BY p0010001) AS "first quartile",
  percentile_cont(.5)
  WITHIN GROUP (ORDER BY p0010001) AS "median",
  percentile_cont(.7)
  WITHIN GROUP (ORDER BY p0010001) AS "third quartile"
FROM
  us_counties_2010;

--
-- Quartiles Array
--

SELECT
  percentile_cont(ARRAY[.2,.4,.6,.8])
  WITHIN GROUP (ORDER BY p0010001) AS "quintiles"
FROM
  us_counties_2010;

--
-- Deciles Array
--

SELECT
  percentile_cont(ARRAY[.1,.2,.3,.4,.5,.6,.7,.8,.9])
  WITHIN GROUP (ORDER BY p0010001) AS "deciles"
FROM
  us_counties_2010;

--
-- Listing 5-13: Using unnest() to turn an array into rows
--
--
-- quartiles
--

SELECT
  unnest(percentile_cont(ARRAY[.25,.5,.75])
    WITHIN GROUP (ORDER BY p0010001)) AS "quartiles"
FROM
  us_counties_2010;

--
-- deciles
--

SELECT
  unnest(percentile_cont(ARRAY[.1,.2,.3,.4,.5,.6,.7,.8,.9])
    WITHIN GROUP (ORDER BY p0010001)) AS "deciles"
FROM
  us_counties_2010;

--
-- Listing 5-14: Creating a median() aggregate function in PostgreSQL
-- Source: https://wiki.postgresql.org/wiki/Aggregate_Median
--

CREATE OR REPLACE FUNCTION _final_median (anyarray)
  RETURNS float8
  AS $$
  WITH q AS (
    SELECT
      val
    FROM
      unnest($1) val
    WHERE
      val IS NOT NULL
    ORDER BY
      1
),
cnt AS (
  SELECT
    count(*) AS c
  FROM
    q
)
SELECT
  avg(val)::float8
FROM (
  SELECT
    val
  FROM
    q
  LIMIT 2 - MOD((
      SELECT
        c FROM cnt), 2) offset greatest (CEIL((
          SELECT
            c FROM cnt) / 2.0) - 1,
        0)) q1;
$$
LANGUAGE sql
IMMUTABLE;

CREATE aggregate median (
  anyelement) (
  SFUNC = array_append,
  STYPE = anyarray,
  FINALFUNC = _final_median,
  INITCOND = '{}'
);

--
-- Listing 5-15: Using a median() aggregate function
--

SELECT
  sum(p0010001) AS "County Sum",
  round(avg(p0010001), 0) AS "County Average",
  median (p0010001) AS "County Median",
  percentile_cont(.5)
  WITHIN GROUP (ORDER BY p0010001) AS "50th Percentile"
FROM
  us_counties_2010;

--
-- Listing 5-16: Finding the most-frequent value with mode()
--

SELECT
  mode()
  WITHIN GROUP (ORDER BY p0010001)
FROM
  us_counties_2010;

--
-- Exercises
----------------------------------------------------
--
-- Exercise 1
--

SELECT
  3.14 * 5 ^ 2 AS "Area of a 5 inch circle";

--
-- Exercise 2
--
-- Using the 2010 Census county data, find out which New York
-- state county has the highest percentage of the population
-- that identified as "American Indian/Alaska Native Alone"
-- What can you learn about the county from the online
-- research that explains the relatively large proportion
-- of American Indian population compared with the other
-- New York counties?
--

SELECT
  geo_name,
  p0010001 AS "Total Pop",
  p0010005 AS "Native American pop",
  (CAST(p0010005 AS numeric(8, 1)) / p0010001) * 100 AS "pct_native"
FROM
  us_counties_2010
WHERE
  state_us_abbreviation = 'NY'
ORDER BY
  "pct_native" DESC;

-- Franklin County
-- Total Pop 51599
-- Native Pop 3797
-- => Pct Native 7.3586697% <=
--
-- Exercise 3
--
-- Was the 2010 median county population higher in
-- California or New York?

SELECT
  median (p0010001) AS "NY Median County Population"
FROM
  us_counties_2010
WHERE
  state_us_abbreviation = 'NY';

--
--> New York median county population 91301
--

SELECT
  median (p0010001) AS "CA Median County Population"
FROM
  us_counties_2010
WHERE
  state_us_abbreviation = 'CA';

--
--> California median county population 179140.5
--
-- California has the higher median county population
-- 179140.5 > 91301
