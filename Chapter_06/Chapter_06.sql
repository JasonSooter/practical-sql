--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- Chapter 6 Code Examples
--------------------------------------------------------------
--
-- Listing 6-1: Creating the departments and employees tables
--

CREATE TABLE departments (
  dept_id bigserial,
  dept varchar(100),
  city varchar(100),
  CONSTRAINT dept_key PRIMARY KEY (dept_id),
  CONSTRAINT dept_city_unique UNIQUE (dept, city)
);

CREATE TABLE employees (
  emp_id bigserial,
  first_name varchar(100),
  last_name varchar(100),
  salary integer,
  dept_id integer REFERENCES departments (dept_id),
  CONSTRAINT emp_key PRIMARY KEY (emp_id),
  CONSTRAINT emp_dept_unique UNIQUE (emp_id, dept_id)
);

INSERT INTO departments (dept,
  city)
    VALUES ('Tax',
      'Atlanta'),
    ('IT',
      'Boston');
INSERT INTO employees (first_name,
  last_name,
  salary,
  dept_id)
    VALUES ('Nancy',
      'Jones',
      62500,
      1),
    ('Lee',
      'Smith',
      59300,
      1),
    ('Soo',
      'Nguyen',
      83000,
      2),
    ('Janet',
      'King',
      95000,
      2);
SELECT
  *
FROM
  departments;

SELECT
  *
FROM
  employees;

--
-- Listing 6-2: Joining the employees and departments tables
--

SELECT
  *
FROM
  employees
  JOIN departments ON employees.dept_id = departments.dept_id;

--
-- Listing 6-3: Creating two tables to explore JOIN types
--

CREATE TABLE schools_left (
  id integer CONSTRAINT left_id_key PRIMARY KEY,
  left_school varchar(30)
);

CREATE TABLE schools_right (
  id integer CONSTRAINT right_id_key PRIMARY KEY,
  right_school varchar(30)
);

INSERT INTO schools_left (id,
  left_school)
    VALUES (1,
      'Oak Street School'),
    (2,
      'Roosevelt High School'),
    (5,
      'Washington Middle School'),
    (6,
      'Jefferson High School');
INSERT INTO schools_right (id,
  right_school)
    VALUES (1,
      'Oak Street School'),
    (2,
      'Roosevelt High School'),
    (3,
      'Morrison Elementary'),
    (4,
      'Chase Magnet Academy'),
    (6,
      'Jefferson High School');
SELECT
  *
FROM
  schools_left;

SELECT
  *
FROM
  schools_right;

--
-- Listing 6-4: Using JOIN
-- Bonus: Also can be specified as INNER JOIN
--

SELECT
  *
FROM
  schools_left INNER JOIN schools_right ON schools_left.id = schools_right.id;

--
-- Listing 6-5: Using LEFT JOIN
--

SELECT
  *
FROM
  schools_left
  LEFT JOIN schools_right ON schools_left.id = schools_right.id;

--
-- Listing 6-6: Using RIGHT JOIN
--

SELECT
  *
FROM
  schools_left
  RIGHT JOIN schools_right ON schools_left.id = schools_right.id;

--
-- Listing 6-7: Using FULL OUTER JOIN
--

SELECT
  *
FROM
  schools_left
  FULL OUTER JOIN schools_right ON schools_left.id = schools_right.id;

--
-- Listing 6-8: Using CROSS JOIN
--

SELECT
  *
FROM
  schools_left
  CROSS JOIN schools_right;

--
-- Listing 6-9: Filtering to show missing values with IS NULL
--

SELECT
  *
FROM
  schools_left
  LEFT JOIN schools_right ON schools_left.id = schools_right.id
WHERE
  schools_right.id IS NULL;

SELECT
  *
FROM
  schools_left
  RIGHT JOIN schools_right ON schools_left.id = schools_right.id
WHERE
  schools_left.id IS NULL;

--
-- Why you need table name when querying multiple tables via Join
-- => column reference "id" is ambiguous

SELECT
  id
FROM
  schools_left
  LEFT JOIN schools_right ON schools_left.id = schools_right.id;

--
-- Listing 6-10: Querying specific columns in a join
--

SELECT
  schools_left.id,
  schools_left.left_school,
  schools_right.right_school
FROM
  schools_left
  LEFT JOIN schools_right ON schools_left.id = schools_right.id;

--
-- Listing 6-11: Simplifying code with table aliases
--

SELECT
  lt.id,
  lt.left_school,
  rt.right_school
FROM
  schools_left AS lt
  LEFT JOIN schools_right AS rt ON lt.id = rt.id;

--
-- Listing 6-12: Joining multiple tables
--

CREATE TABLE schools_enrollment (
  id integer,
  enrollment integer
);

CREATE TABLE schools_grades (
  id integer,
  grades varchar(10)
);

INSERT INTO schools_enrollment (id,
  enrollment)
    VALUES (1,
      360),
    (2,
      1001),
    (5,
      450),
    (6,
      927);
INSERT INTO schools_grades (id,
  grades)
    VALUES (1,
      'K-3'),
    (2,
      '9-12'),
    (5,
      '6-8'),
    (6,
      '9-12');
SELECT
  lt.id,
  lt.left_school,
  en.enrollment,
  gr.grades
FROM
  schools_left AS lt
  LEFT JOIN schools_enrollment AS en ON lt.id = en.id
  LEFT JOIN schools_grades AS gr ON lt.id = gr.id;

--
-- Listing 6-13: Performing math on joined Census tables
-- Decennial Census 2000. Full data dictionary at https://www.census.gov/prod/cen2000/doc/pl94-171.pdf
-- Note: Some non-number columns have been given more descriptive names

CREATE TABLE us_counties_2000 (
  geo_name varchar(90),
  -- County/state name,

  state_us_abbreviation varchar(2),
  -- State/U.S. abbreviation

  state_fips varchar(2),
  -- State FIPS code

  county_fips varchar(3),
  -- County code

  p0010001 integer,
  -- Total population

  p0010002 integer,
  -- Population of one race:

  p0010003 integer,
  -- White Alone

  p0010004 integer,
  -- Black or African American alone

  p0010005 integer,
  -- American Indian and Alaska Native alone

  p0010006 integer,
  -- Asian alone

  p0010007 integer,
  -- Native Hawaiian and Other Pacific Islander alone

  p0010008 integer,
  -- Some Other Race alone

  p0010009 integer,
  -- Population of two or more races

  p0010010 integer,
  -- Population of two races

  p0020002 integer,
  -- Hispanic or Latino

  p0020003 integer -- Not Hispanic or Latino:

);

COPY us_counties_2000
FROM
  '/Users/jasonsooter/dev-space/practical-sql/Chapter_06/us_counties_2000.csv' WITH (
    format csv,
    header
);

--
--
--

SELECT
  c2010.geo_name,
  c2010.state_us_abbreviation AS state,
  c2010.p0010001 AS pop_2010,
  c2000.p0010001 AS pop_2000,
  c2010.p0010001 - c2000.p0010001 AS raw_change,
  round((CAST(c2010.p0010001 AS numeric(8, 1)) - c2000.p0010001) / c2000.p0010001 * 100, 1) AS pct_change
FROM
  us_counties_2010 c2010
  INNER JOIN us_counties_2000 c2000 ON c2010.state_fips = c2000.state_fips
    AND c2010.county_fips = c2000.county_fips
    AND c2010.p0010001 <> c2000.p0010001
  ORDER BY
    pct_change DESC;

--
-- Exercises
--
--
-- Find the difference in number of counties from 2000 to 2010
--

SELECT
  (
    SELECT
      count(geo_name)
    FROM
      us_counties_2010) - (
    SELECT
      count(geo_name)
    FROM
      us_counties_2000) AS county_difference;

--
-- Exercise 1
-- Determine missing counties in 2010 that were in 2000
--

SELECT
  c2010.state_us_abbreviation AS c2010_state_us_abbreviation,
  -- c2010.state_fips AS c2010_state_fips,
  -- c2010.county_fips AS c2010_county_fips,
  c2010.geo_name AS c2010_geo_name,
  c2000.state_us_abbreviation AS c2000_state_us_abbreviation,
  -- c2000.state_fips AS c2000_state_fips,
  -- c2000.county_fips AS c2000_county_fips,
  c2000.geo_name AS c2000_geo_name
FROM
  us_counties_2010 AS c2010
  FULL JOIN us_counties_2000 AS c2000 ON c2010.state_fips = c2000.state_fips
    AND c2010.county_fips = c2000.county_fips
WHERE
  c2010.county_fips IS NULL
  OR c2000.county_fips IS NULL;

-- 2000 census started at 3141 counties
-- -1 to 3140 Clifton Forge city 51-560 was an independent city IN 2000.
-- Now part of Alleghany county in 2010
--
-- +1 to 3141 Wrangell-Petersburg Census area split into 2 census areas
--
-- +1 to 3142 Skagway-Hoonah-Angoon Census Area, Alaska split into
-- Skagway Municipality and Hoonah-Angoon Census Area
--
-- +1 to 3143 Wrangell-Petersburg Census Area split into
--  Wrangell City and Petersburg cenus area
--
-- Exercise 2
--
-- Using either the median() or percentile_cont() functions in
-- Chapter5 determine the median of the percent change in county population

SELECT
  min(percent_change),
  percentile_cont(.25)
  WITHIN GROUP (ORDER BY percent_change) "25th quartile",
  percentile_cont(.5)
  WITHIN GROUP (ORDER BY percent_change) median,
  percentile_cont(.75)
  WITHIN GROUP (ORDER BY percent_change) "75th quartile",
  percentile_cont(.9)
  WITHIN GROUP (ORDER BY percent_change) "90th quartile",
  max(percent_change)
FROM (
  -- subquery to get difference and percent change (percent_change)
  SELECT
    round((CAST(c2010.p0010001 AS numeric(8, 1)) - c2000.p0010001) / c2000.p0010001 * 100, 2) "percent_change"
  FROM
    us_counties_2010 c2010
    INNER JOIN us_counties_2000 c2000 ON c2010.state_fips = c2000.state_fips
      AND c2010.county_fips = c2000.county_fips
      AND c2010.p0010001 <> c2000.p0010001
    ORDER BY
      percent_change ASC) t;

-- min -46.60%
-- 25th quartile-2.5175%
-- median 3.195%
-- 75th quartile 10.2325%
-- 90th quartile 20.62%
-- max 110.35%
--
--
-- Exercise 3
--
-- Which county had the greatest percentage loss of population between 2000 and 2010?
-- Explain why?
--

SELECT
  geo_name,
  percent_change
FROM (
  -- subquery to geo_name and percent change
  SELECT
    c2010.geo_name,
    round((CAST(c2010.p0010001 AS numeric(8, 1)) - c2000.p0010001) / c2000.p0010001 * 100, 2) AS percent_change
  FROM
    us_counties_2010 c2010
    INNER JOIN us_counties_2000 c2000 ON c2010.state_fips = c2000.state_fips
      AND c2010.county_fips = c2000.county_fips
      AND c2010.p0010001 <> c2000.p0010001
    ORDER BY
      percent_change ASC) AS t
LIMIT 1;

-- St. Bernard Parish population declined by 46.60% due to Hurricane Katrina in 2005
