--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- Chapter 3 Code Examples
--------------------------------------------------------------
-- Listing 3-1: Character data types in action
--
-- Create char_data_types table
--

CREATE TABLE char_data_types (
  varchar_column varchar(10),
  char_column char(10),
  text_column text
);

--
-- Seed char_data_types table
--

INSERT INTO char_data_types
    VALUES ('abc',
      'abc',
      'abc'),
    ('defghi',
      'defghi',
      'defghi');
--
-- Show data that has been added
--

SELECT
  *
FROM
  char_data_types;

--
-- Export table data as CSV
-- Notice how field lengths are maintained for char_column
--

COPY char_data_types TO '/Users/jasonsooter/dev-space/practical-sql/Chapter_03/typetest.csv' WITH (
  FORMAT CSV,
  HEADER,
  DELIMITER ','
);

--
-- Listing 3-2: Number data types in action
--
-- numeric(precision, scale) === decimal(precision, scale)
-- precision: number of digits to the left and right of the decimal point
-- scale: number of digits allowable on the right of the decimal point
--
-- real: allows precision to 6 decimal digits
-- double precision: allows precision to 15 decimal points of precision

CREATE TABLE number_data_types (
  numeric_column numeric(20, 5),
  real_column real,
  double_column double precision
);

INSERT INTO number_data_types
    VALUES (.7,
.7,
.7),
    (2.13579,
      2.13579,
      2.13579),
    (2.1357987654,
      2.1357987654,
      2.1357987654);
SELECT
  *
FROM
  number_data_types;

-- Listing 3-3: Rounding issues with float columns
-- Assumes table created and loaded with Listing 3-2

SELECT
  numeric_column * 10000000 AS "Fixed",
  real_column * 10000000 AS "Float"
FROM
  number_data_types
WHERE
  numeric_column =.7;

--
-- Listing 3-4: Timestamp and interval types in action
--

CREATE TABLE date_time_types (
  timestamp_column timestamp WITH time zone,
  interval_column interval
);

INSERT INTO date_time_types
    VALUES ('2018-12-31 01:00 EST',
      '2 days'),
    ('2018-12-31 01:00 PST',
      '1 month'),
    ('2018-12-31 01:00 Australia/Melbourne',
      '1 century'),
    (now(),
      '1 week');
SELECT
  *
FROM
  date_time_types;

--
-- Listing 3-5: Using the interval data type
-- to created computed column (expression) new_date
--

SELECT
  timestamp_column,
  interval_column,
  timestamp_column - interval_column AS new_date
FROM
  date_time_types;

--
-- Listing 3-6: Three CAST() examples
--

SELECT
  timestamp_column,
  CAST(timestamp_column AS varchar(10))
FROM
  date_time_types;

SELECT
  numeric_column,
  CAST(numeric_column AS integer),
  CAST(numeric_column AS varchar(6))
FROM
  number_data_types;

--
-- Does not work:
-- Unable to cast character type to integer type
--

SELECT
  CAST(char_column AS integer)
FROM
  char_data_types;

--
-- PostgreSQL-only alternate notation for CAST is the double-colon ::
--

SELECT
  timestamp_column::varchar(10)
FROM
  date_time_types;

--
-- Exercise 1
--
-- daily_mileage can be stored as decimal(5,2)
-- 3 digits on the left + 2 digits on the right = 5 total digits
--
-- Exercise 2
--
-- The 'text' or varchar(50) could be used for first_name and last_name
-- It's a good idea to separate first and last name for cases that you
-- need use one or the other.
-- i.e. Sort by last_name, use first_name for greeting, etc
--
-- Exercise 3
--

INSERT INTO date_time_types
    VALUES ('4//2017',
      '2 days')
    -- This produces and error:
    -- "invalid input syntax for type timestamp with time zone: "4//2017""
