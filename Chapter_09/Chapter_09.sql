--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- Chapter 9 Code Examples
--------------------------------------------------------------
-- Listing 9-1: Importing the FSIS Meat, Poultry, and Egg Inspection Directory
-- https://catalog.data.gov/dataset/meat-poultry-and-egg-inspection-directory-by-establishment-name

CREATE TABLE meat_poultry_egg_inspect (
  est_number varchar(50) CONSTRAINT est_number_key PRIMARY KEY,
  company varchar(100),
  street varchar(100),
  city varchar(30),
  st varchar(2),
  zip varchar(5),
  phone varchar(14),
  grant_date date,
  activities text,
  dbas text
);

COPY meat_poultry_egg_inspect
FROM
  '/Users/jasonsooter/dev-space/practical-sql/Chapter_09/MPI_Directory_by_Establishment_Name.csv' WITH (
    format csv,
    header,
    DELIMITER ',');

CREATE INDEX company_idx ON meat_poultry_egg_inspect (company);

-- Count the rows imported:
SELECT
  count(*)
FROM
  meat_poultry_egg_inspect;

-- Listing 9-2: Finding multiple companies at the same address
SELECT
  company,
  street,
  city,
  st,
  count(*) AS address_count
FROM
  meat_poultry_egg_inspect
GROUP BY
  company,
  street,
  city,
  st
HAVING
  count(*) > 1
ORDER BY
  company,
  street,
  city,
  st;

-- Listing 9-3: Grouping and counting states
SELECT
  st,
  count(*) AS st_count
FROM
  meat_poultry_egg_inspect
GROUP BY
  st
ORDER BY
  st Nulls FIRST;

-- Listing 9-4: Using IS NULL to find missing values in the st column
SELECT
  est_number,
  company,
  city,
  st,
  zip
FROM
  meat_poultry_egg_inspect
WHERE
  st IS NULL;

-- Listing 9-5: Using GROUP BY and count() to find inconsistent company names
SELECT
  company,
  count(*) AS company_count
FROM
  meat_poultry_egg_inspect
GROUP BY
  company
ORDER BY
  company ASC;

-- Listing 9-6: Using length() and count() to test the zip column
SELECT
  length(zip),
  count(*) AS length_count
FROM
  meat_poultry_egg_inspect
GROUP BY
  length(zip)
ORDER BY
  length(zip) ASC;

-- Listing 9-7: Filtering with length() to find short zip values
SELECT
  st,
  count(*) AS st_count
FROM
  meat_poultry_egg_inspect
WHERE
  length(zip) < 5
GROUP BY
  st
ORDER BY
  st ASC;

-- ADD COLUMN (ALTER TABLE)
ALTER TABLE xyz
  ADD COLUMN name varchar(100);

-- DROP COLUMN (ALTER TABLE)
ALTER TABLE xyz
  DROP COLUMN name;

-- ALTER COLUMN DATA TYPE (ALTER TABLE)
ALTER TABLE xyz
  ALTER COLUMN name SET data TYPE varchar(50);

-- ADD NOT NULL constraint to existing column
ALTER TABLE xyz
  ALTER COLUMN name SET NOT NULL;

-- DROP NOT NULL constraint from existing column
ALTER TABLE xyz
  ALTER COLUMN name DROP NOT NULL;

-- UPDATE data in an existing column
UPDATE
  xyz
SET
  name = 'not set';

-- UPDATE data in multiple existing columns
UPDATE
  xyz
SET
  first_name = 'not set',
  last_name = 'not set';

-- UPDATE data in existing column where criteria matches
UPDATE
  xyz
SET
  first_name = 'Jason',
  last_name = 'Sooter'
WHERE
  first_name = 'jason'
  AND last_name = 'sooter';

-- UPDATE table with values from another
UPDATE
  xyz
SET
  first_name = (
    SELECT
      first_name
    FROM
      abc
    WHERE
      xyz.first_name = abc.first_name)
WHERE
  EXISTS (
    SELECT
      first_name
    FROM
      abc
    WHERE
      xyz.first_name = abc.first_name);

-- UPDATE table with values from another table in Postgres
UPDATE
  table_a
SET
  first_name = table_b.first_name
FROM
  table_b
WHERE
  table_a.first_name = table_b.first_name;

-- Listing 9-8: Backing up a table
CREATE TABLE meat_poultry_egg_inspect_backup AS
SELECT
  *
FROM
  meat_poultry_egg_inspect;

-- Check number of records:
SELECT
  (
    SELECT
      count(*)
    FROM
      meat_poultry_egg_inspect) AS original,
  (
    SELECT
      count(*)
    FROM
      meat_poultry_egg_inspect_backup) AS backup;

-- Listing 9-9: Creating and filling the st_copy column with ALTER TABLE and UPDATE
ALTER TABLE meat_poultry_egg_inspect
  ADD COLUMN st_copy_2 varchar(2);

-- UPDATE st_copy column with copy of state from st column
UPDATE
  meat_poultry_egg_inspect
SET
  st = st_copy_2;

-- Listing 9-10: Checking values in the st and st_copy columns
SELECT
  st,
  st_copy,
  st_copy_2
FROM
  meat_poultry_egg_inspect
ORDER BY
  st_copy NULLS FIRST;

-- Listing 9-11: Updating the st column for three establishments
UPDATE
  meat_poultry_egg_inspect
SET
  st = 'MN'
WHERE
  est_number = 'V18677A';

UPDATE
  meat_poultry_egg_inspect
SET
  st = 'AL'
WHERE
  est_number = 'M45319+P45319';

UPDATE
  meat_poultry_egg_inspect
SET
  st = 'WI'
WHERE
  est_number = 'M263A+P263A+V263A';

-- Listing 9-12: Restoring original st column values
-- Restoring from the column backup

UPDATE
  meat_poultry_egg_inspect
SET
  st = st_copy;

-- Restoring from the table backup
UPDATE
  meat_poultry_egg_inspect original
SET
  st = backup.st
FROM
  meat_poultry_egg_inspect_backup backup
WHERE
  original.est_number = backup.est_number;

-- Remove temporary backup columns
ALTER TABLE meat_poultry_egg_inspect
  DROP COLUMN st_copy;

-- Check for Nulls in updated st column
SELECT
  st
FROM
  meat_poultry_egg_inspect
ORDER BY
  st NULLS FIRST;

-- Listing 9-13: Creating and filling the company_standard column
ALTER TABLE meat_poultry_egg_inspect
  ADD COLUMN company_standard varchar(100);

UPDATE
  meat_poultry_egg_inspect
SET
  company_standard = company;

-- Listing 9-14: Use UPDATE to modify field values that match a string
SELECT
  company,
  company_standard
FROM
  meat_poultry_egg_inspect
WHERE
  company LIKE 'Armour%'
GROUP BY
  company,
  company_standard;

UPDATE
  meat_poultry_egg_inspect
SET
  company_standard = 'Armour-Eckrich Meats'
WHERE
  company LIKE 'Armour%';

SELECT
  company,
  company_standard
FROM
  meat_poultry_egg_inspect
WHERE
  company LIKE 'Armour%';

-- Listing 9-15: Creating and filling the zip_copy column
-- ADD zip_copy column with 5 character limit

ALTER TABLE meat_poultry_egg_inspect
  ADD COLUMN zip_copy varchar(5);

-- SET zip_copy to zip values
UPDATE
  meat_poultry_egg_inspect
SET
  zip_copy = zip;

-- Listing 9-16: Modify codes in the zip column missing two leading zeros
-- View all zip codes from Puerto Rico & Virgin Islands

SELECT
  zip
FROM
  meat_poultry_egg_inspect
WHERE
  st IN ('PR', 'VI')
GROUP BY
  zip;

-- update PR and VI zip codes to be 5 characters long padded on the left with 00s
UPDATE
  meat_poultry_egg_inspect
SET
  zip = '00' || zip
WHERE
  st IN ('PR', 'VI')
  AND length(zip) = 3;

-- L 9-17: Modify zip column where codes missing one leading zero
-- Verify states with zip code length of 4 - CT MA ME NH NJ RI VT

SELECT
  st
FROM
  meat_poultry_egg_inspect
WHERE
  length(zip) = 4
GROUP BY
  st;

-- UPDATE CT MA ME NH NJ RI VT zip codes to be 5 characters padded on the left with 0s
UPDATE
  meat_poultry_egg_inspect
SET
  zip = '0' || zip
WHERE
  st IN ('CT', 'MA', 'ME', 'NH', 'NJ', 'RI', 'VT')
  AND length(zip) = 4;

-- Listing 9-18: Creating and filling a state_regions table
CREATE TABLE state_regions (
  st varchar(2) CONSTRAINT st_key PRIMARY KEY,
  region varchar(20) NOT NULL
);

COPY state_regions
FROM
  '/Users/jasonsooter/dev-space/practical-sql/Chapter_09/state_regions.csv' WITH (
    format csv,
    header,
    DELIMITER ',');

SELECT
  *
FROM
  state_regions
ORDER BY
  region;

-- Listing 9-19: Adding and updating an inspection_date column
ALTER TABLE meat_poultry_egg_inspect
  ADD COLUMN inspection_date date;

UPDATE
  meat_poultry_egg_inspect inspect
SET
  inspection_date = '2019-12-01'
WHERE
  EXISTS (
    SELECT
      state_regions.region
    FROM
      state_regions
    WHERE
      inspect.st = state_regions.st
      AND state_regions.region = 'New England');

-- Listing 9-20: Viewing updated inspection_date values
SELECT
  st,
  inspection_date
FROM
  meat_poultry_egg_inspect
WHERE
  inspection_date IS NOT NULL
GROUP BY
  st,
  inspection_date
ORDER BY
  st;

-- Listing 9-21: Delete rows matching an expression
-- show all columns of the meat_poultry_egg_inspect table

SELECT
  COLUMN_NAME
FROM
  information_schema.COLUMNS
WHERE
  TABLE_NAME = 'meat_poultry_egg_inspect';

-- Delete data for PR/VI to include just 50 US state info
DELETE FROM meat_poultry_egg_inspect
WHERE st IN ('PR', 'VI');

-- Listing 9-22: Remove a column from a table using DROP
UPDATE
  meat_poultry_egg_inspect
SET
  zip_copy = zip;

ALTER TABLE meat_poultry_egg_inspect
  DROP COLUMN zip_copy;

-- Listing 9-23: Remove a table from a database using DROP
DROP TABLE meat_poultry_egg_inspect_backup;

-- Listing 9-24: Demonstrating a transaction block
-- Start transaction and perform update

START TRANSACTION;

UPDATE
  meat_poultry_egg_inspect
SET
  company = 'AGRO Merchantss Oakland LLC'
WHERE
  company = 'AGRO Merchants Oakland, LLC';

-- view changes
SELECT
  company
FROM
  meat_poultry_egg_inspect
WHERE
  company LIKE 'AGRO%'
ORDER BY
  company;

-- Revert changes
ROLLBACK;

-- See restored state
SELECT
  company
FROM
  meat_poultry_egg_inspect
WHERE
  company LIKE 'AGRO%'
ORDER BY
  company;

-- Alternately, commit changes at the end:
START TRANSACTION;

UPDATE
  meat_poultry_egg_inspect
SET
  company = 'AGRO Merchants Oakland LLC'
WHERE
  company = 'AGRO Merchantss Oakland LLC';

COMMIT;

-- Listing 9-25: Backing up a table while adding and filling a new column
CREATE TABLE meat_poultry_egg_inspect_backup AS
SELECT
  *,
  '2018-02-07'::date AS reviewed_date
FROM
  meat_poultry_egg_inspect;

-- Listing 9-26: Swapping table names using ALTER TABLE
ALTER TABLE meat_poultry_egg_inspect RENAME TO meat_poultry_egg_inspect_temp;

ALTER TABLE meat_poultry_egg_inspect_backup RENAME TO meat_poultry_egg_inspect;

ALTER TABLE meat_poultry_egg_inspect_temp RENAME TO meat_poultry_egg_inspect_backup;

DROP TABLE meat_poultry_egg_inspect_backup;

-- EXERCISES
-- EXERCISE 1
-- Create 2 new columns called `meat_processing` and `poultry_process`
-- in the meat_poultry_egg_inspect table. Each column type will be boolean

CREATE TABLE meat_poultry_egg_inspect_backup AS
SELECT
  *,
  false::boolean AS meat_processing,
  false::boolean AS poultry_processing
FROM
  meat_poultry_egg_inspect;

-- EXERCISE 2
UPDATE
  meat_poultry_egg_inspect_backup
SET
  meat_processing = TRUE
WHERE
  activities LIKE '%Meat Processing%';

UPDATE
  meat_poultry_egg_inspect_backup
SET
  poultry_processing = TRUE
WHERE
  activities LIKE '%Poultry Processing%';

-- Exercise 3 - Use the new updated columns to count how many plants
-- perform each type of activity. For a bonus challenge, count how
-- many plants perform both activities

SELECT
  meat_processing,
  poultry_processing,
  count(*) AS count
FROM
  meat_poultry_egg_inspect_backup
GROUP BY
  meat_processing,
  poultry_processing;

-- Move data from backup table to prod table
ALTER TABLE meat_poultry_egg_inspect RENAME TO meat_poultry_egg_inspect_temp;

ALTER TABLE meat_poultry_egg_inspect_backup RENAME TO meat_poultry_egg_inspect;

ALTER TABLE meat_poultry_egg_inspect_temp RENAME TO meat_poultry_egg_inspect_backup;

DROP TABLE meat_poultry_egg_inspect_backup;

-- Get count of plants that perform both meat and poultry processing
SELECT
  count(*) AS both_count
FROM
  meat_poultry_egg_inspect
WHERE
  poultry_processing = TRUE
  AND meat_processing = TRUE;

