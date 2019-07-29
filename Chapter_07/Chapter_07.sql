--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- Chapter 7 Code Examples
--------------------------------------------------------------
-- Surrounding identifiers with quotes (") allows for case sensitivity

CREATE TABLE customers (
  customer_id serial
);

CREATE TABLE Customers (
  customer_id serial
);

-- => error `relation "customers" already exists`
-- Use quotes around `Customers` if you want to make a second table
-- with the same name but with first capital letter
-- Keep in mind this is a bad idea

CREATE TABLE "Customers" (
  customer_id serial
);

-- => Success
-- Keep in mind this is a bad idea
-- This table will require quoting in future references such as:

SELECT
  *
FROM
  "Customers";

DROP TABLE "Customers";

DROP TABLE "customers";

--
-- Listing 7-1: Declaring a single-column natural key as primary key
-- As a column constraint

CREATE TABLE natural_key_example (
  license_id varchar(10) PRIMARY KEY,
  first_name varchar(50),
  last_name varchar(50)
);

-- Drop the table before trying again

DROP TABLE natural_key_example;

-- As a table constraint

CREATE TABLE natural_key_example (
  license_id varchar(10),
  first_name varchar(50),
  last_name varchar(50),
  CONSTRAINT license_key PRIMARY KEY (license_id)
);

-- Listing 7-2: Example of a primary key violation

INSERT INTO natural_key_example (license_id,
  first_name,
  last_name)
    VALUES ('T229901',
      'Lynn',
      'Malero');
INSERT INTO natural_key_example (license_id,
  first_name,
  last_name)
    VALUES ('T229901',
      'Sam',
      'Tracy');
-- => ERROR:  duplicate key value violates unique constraint "license_key"
-- => DETAIL:  Key (license_id)=(T229901) already exists.
-- fails because license_id is not unique
--
--
-- Listing 7-3: Declaring a composite primary key as a natural key

CREATE TABLE natural_key_composite_example (
  student_id varchar(10),
  school_day date,
  present boolean,
  CONSTRAINT student_key PRIMARY KEY (student_id, school_day)
);

-- Listing 7-4: Example of a composite primary key violation

INSERT INTO natural_key_composite_example (student_id,
  school_day,
  present)
    VALUES (775,
      '1/22/2017',
      'Y');
INSERT INTO natural_key_composite_example (student_id,
  school_day,
  present)
    VALUES (775,
      '1/23/2017',
      'Y');
INSERT INTO natural_key_composite_example (student_id,
  school_day,
  present)
    VALUES (775,
      '1/23/2017',
      'N');
-- => ERROR:  duplicate key value violates unique constraint "student_key"
-- => DETAIL:  Key (student_id, school_day)=(775, 2017-01-23) already exists.
-- Error because the combination of student_id and school_day are not unique
--
-- Listing 7-5: Declaring a bigserial column as a surrogate key

CREATE TABLE surrogate_key_example (
  order_number bigserial,
  product_name varchar(50),
  order_date date,
  CONSTRAINT order_key PRIMARY KEY (order_number)
);

INSERT INTO surrogate_key_example (product_name,
  order_date)
    VALUES ('Beachball Polish',
      '2015-03-17'),
    ('Wrinkle De-Atomizer',
      '2017-05-22'),
    ('Flux Capacitor',
      '1985-10-26');
--

SELECT
  *
FROM
  surrogate_key_example;

-- Listing 7-6: A foreign key example

CREATE TABLE licenses (
  license_id varchar(10),
  first_name varchar(50),
  last_name varchar(50),
  CONSTRAINT licenses_key PRIMARY KEY (license_id)
);

CREATE TABLE registrations (
  registration_id varchar(10),
  registration_date date,
  license_id varchar(10) REFERENCES licenses (license_id) ON DELETE CASCADE,
  CONSTRAINT registration_key PRIMARY KEY (registration_id, license_id)
);

INSERT INTO licenses (license_id,
  first_name,
  last_name)
    VALUES ('T229901',
      'Lynn',
      'Malero');
INSERT INTO registrations (registration_id,
  registration_date,
  license_id)
    VALUES ('A203391',
      '3/17/2017',
      'T229901');
INSERT INTO registrations (registration_id,
  registration_date,
  license_id)
    VALUES ('A75772',
      '3/17/2017',
      'T000001');
-- ==> ERROR:  insert or update on table "registrations" violates foreign key constraint "registrations_license_id_fkey"
-- ==> DETAIL:  Key (license_id)=(T000001) is not present in table "licenses".
--
--
-- Listing 7-7: CHECK constraint examples
--

CREATE TABLE check_constraint_example (
  user_id bigserial,
  user_role varchar(50),
  salary integer,
  CONSTRAINT user_id_key PRIMARY KEY (user_id),
  CONSTRAINT check_role_in_list CHECK (user_role IN ('Admin',
      'Staff')),
  CONSTRAINT check_salary_not_zero CHECK (salary > 0)
);

-- Both of these will fail:

INSERT INTO check_constraint_example (user_role)
    VALUES ('admin');
INSERT INTO check_constraint_example (salary)
    VALUES (0);
--
-- Listing 7-8: UNIQUE constraint example
--

CREATE TABLE unique_constraint_example (
  contact_id bigserial CONSTRAINT contact_id_key PRIMARY KEY,
  first_name varchar(50),
  last_name varchar(50),
  email varchar(200),
  CONSTRAINT email_unique UNIQUE (email)
);

INSERT INTO unique_constraint_example (first_name,
  last_name,
  email)
    VALUES ('Samantha',
      'Lee',
      'slee@example.org');
INSERT INTO unique_constraint_example (first_name,
  last_name,
  email)
    VALUES ('Betty',
      'Diaz',
      'bdiaz@example.org');
INSERT INTO unique_constraint_example (first_name,
  last_name,
  email)
    VALUES ('Sasha',
      'Lee',
      'slee@example.org');
SELECT
  *
FROM
  unique_constraint_example;

-- Listing 7-9: NOT NULL constraint example

CREATE TABLE not_null_example (
  student_id bigserial CONSTRAINT student_id_key PRIMARY KEY,
  first_name varchar(50) NOT NULL,
  last_name varchar(50) NOT NULL,
);

INSERT INTO not_null_example (first_name,
  last_name)
    VALUES ('Jason',
      'Sooter');
--
-- ==> The below fails because first_name cannot be null

INSERT INTO not_null_example (last_name)
    VALUES ('Sooter');
--

SELECT
  *
FROM
  not_null_example;

-- Listing 7-10: Dropping and Adding a primary key and a NOT NULL constraint
--
-- Drop

ALTER TABLE not_null_example DROP CONSTRAINT student_id_key;

-- Add

ALTER TABLE not_null_example
  ADD CONSTRAINT student_id_key PRIMARY KEY (student_id);

-- Drop

ALTER TABLE not_null_example ALTER COLUMN first_name DROP NOT NULL;

-- Add

ALTER TABLE not_null_example ALTER COLUMN first_name SET NOT NULL;

-- Listing 7-11: Importing New York City address data

CREATE TABLE new_york_addresses (
  longitude numeric(9, 6),
  latitude numeric(9, 6),
  street_number varchar(10),
  street varchar(32),
  unit varchar(7),
  postcode varchar(5),
  id integer CONSTRAINT new_york_key PRIMARY KEY
);

COPY new_york_addresses
FROM
  '/Users/jasonsooter/dev-space/practical-sql/Chapter_07/city_of_new_york.csv' WITH (
    format csv,
    header
);

SELECT
  count(*)
FROM
  new_york_addresses;

-- Listing 7-12: Benchmark queries for index performance

EXPLAIN ANALYZE
SELECT
  *
FROM
  new_york_addresses
WHERE
  street = 'BROADWAY';

-- "QUERY PLAN - BEFORE"
-- "Gather  (cost=1000.00..15259.38 rows=3856 width=46) (actual time=0.730..83.897 rows=3336 loops=1)"
-- "  Workers Planned: 2"
-- "  Workers Launched: 2"
-- "  ->  Parallel Seq Scan on new_york_addresses  (cost=0.00..13873.78 rows=1607 width=46) (actual time=0.299..77.432 rows=1112 loops=3)"
-- "        Filter: ((street)::text = 'BROADWAY'::text)"
-- "        Rows Removed by Filter: 312346"
-- "Planning Time: 0.834 ms"
-- "Execution Time: 84.290 ms"
--
-- "QUERY PLAN - AFTER"
-- "Bitmap Heap Scan on new_york_addresses  (cost=94.31..7177.57 rows=3856 width=46) (actual time=1.844..17.235 rows=3336 loops=1)"
-- "  Recheck Cond: ((street)::text = 'BROADWAY'::text)"
-- "  Heap Blocks: exact=2157"
-- "  ->  Bitmap Index Scan on street_idx  (cost=0.00..93.34 rows=3856 width=0) (actual time=1.374..1.375 rows=3336 loops=1)"
-- "        Index Cond: ((street)::text = 'BROADWAY'::text)"
-- "Planning Time: 1.012 ms"
-- "Execution Time: 17.634 ms"

EXPLAIN ANALYZE
SELECT
  *
FROM
  new_york_addresses
WHERE
  street = '52 STREET';

-- "QUERY PLAN - BEFORE"
-- "Gather  (cost=1000.00..14889.08 rows=153 width=46) (actual time=0.823..97.116 rows=860 loops=1)"
-- "  Workers Planned: 2"
-- "  Workers Launched: 2"
-- "  ->  Parallel Seq Scan on new_york_addresses  (cost=0.00..13873.78 rows=64 width=46) (actual time=0.519..89.479 rows=287 loops=3)"
-- "        Filter: ((street)::text = '52 STREET'::text)"
-- "        Rows Removed by Filter: 313171"
-- "Planning Time: 0.841 ms"
-- "Execution Time: 97.329 ms"
--
-- "QUERY PLAN - AFTER"
-- "Bitmap Heap Scan on new_york_addresses  (cost=5.61..556.18 rows=153 width=46) (actual time=0.806..7.977 rows=860 loops=1)"
-- "  Recheck Cond: ((street)::text = '52 STREET'::text)"
-- "  Heap Blocks: exact=704"
-- "  ->  Bitmap Index Scan on street_idx  (cost=0.00..5.57 rows=153 width=0) (actual time=0.542..0.542 rows=860 loops=1)"
-- "        Index Cond: ((street)::text = '52 STREET'::text)"
-- "Planning Time: 1.613 ms"
-- "Execution Time: 8.176 ms"

EXPLAIN ANALYZE
SELECT
  *
FROM
  new_york_addresses
WHERE
  street = 'ZWICKY AVENUE';

-- "QUERY PLAN - BEFORE"
-- "Gather  (cost=1000.00..14889.08 rows=153 width=46) (actual time=21.715..92.724 rows=6 loops=1)"
-- "  Workers Planned: 2"
-- "  Workers Launched: 2"
-- "  ->  Parallel Seq Scan on new_york_addresses  (cost=0.00..13873.78 rows=64 width=46) (actual time=51.782..85.736 rows=2 loops=3)"
-- "        Filter: ((street)::text = 'ZWICKY AVENUE'::text)"
-- "        Rows Removed by Filter: 313456"
-- "Planning Time: 0.895 ms"
-- "Execution Time: 92.816 ms"
--
-- "QUERY PLAN - AFTER"
-- "Bitmap Heap Scan on new_york_addresses  (cost=5.61..556.18 rows=153 width=46) (actual time=0.101..0.155 rows=6 loops=1)"
-- "  Recheck Cond: ((street)::text = 'ZWICKY AVENUE'::text)"
-- "  Heap Blocks: exact=6"
-- "  ->  Bitmap Index Scan on street_idx  (cost=0.00..5.57 rows=153 width=0) (actual time=0.084..0.084 rows=6 loops=1)"
-- "        Index Cond: ((street)::text = 'ZWICKY AVENUE'::text)"
-- "Planning Time: 0.436 ms"
-- "Execution Time: 0.181 ms"
--
-- Listing 7-13: Creating a B-Tree index on the new_york_addresses table

CREATE INDEX street_idx ON new_york_addresses (street);

--
--
-- Exercises
--

CREATE TABLE albums (
  album_id bigserial,
  album_catalog_code varchar(100),
  album_title text NOT NULL,
  album_artist text NOT NULL,
  album_release_date date,
  album_genre varchar(40),
  album_description text,
  CONSTRAINT album_key PRIMARY KEY (album_id)
);

CREATE TABLE songs (
  song_id bigserial,
  song_title text NOT NULL,
  song_artist text NOT NULL,
  album_id bigint REFERENCES albums (album_id),
  CONSTRAINT songs_key PRIMARY KEY (songs_id)
);

-------------
-- Exercise 1
--
-- The `albums` table will have a PRIMARY KEY CONSTRAINT set on `album_id`
-- The `songs` table will have a PRIMARY KEY CONSTRAINT set on `song_id`
-- The `songs` table will have a REFERENCES CONSTRAINT set for album_id
-- that points to `album_id` in the `albums` table
--
-- The `albums` table columns `album_title` and `album_artist` were set to NOT NULL
-- because a record with no title or artist is not useful.
-- The `songs` table columns `song_title` and `song_artist` were set to NOT NULL
-- because a record with no title or artist is not useful.
--
-------------
-- Exercise 2
--
-- The `albums` table column `album_catalog_code` appeared to be a candidate as
-- a natural primary key, but based on reading this article:
--   -https://www.thebalancecareers.com/catalog-number-2460354
-- There are 2 reasons
--   - No "governing authority that determines how the numbers should be issued".
--   - There is no requirement for a release to have a catalog number
-- Record companies are tasked with determining their own catalog code.
--
-- For this reason, we have no guarantee of unqiqueness or that all albums will indeed
-- have a catalog number. Sticking with a synthetic primary key makes sense in this case.
--
-------------
-- Exercise 3
--
-- For the `albums` table, putting an index on `album_title` and `album_artist` might make
-- sense because we are likely to use them in a WHERE clause.

-- For the `songs` table, putting an index on `song_title` and `song_artist` might make
-- sense because we are likely to use them in a WHERE clause.
