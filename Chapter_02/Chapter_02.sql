--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- Chapter 2 Code Examples
--------------------------------------------------------------
-- Listing 2-1: Querying all rows and columns from the teachers table
-- Question answered: What are all the records in this table?
--

SELECT
  *
FROM
  teachers;

--
-- Listing 2-2: Querying all rows and a subset of columns from the teachers table
-- Question answered: What are the teachers and their salaries?
--

SELECT
  last_name,
  first_name,
  salary
FROM
  teachers;

--
-- Listing 2-3: Querying distinct values in the school column
-- Question answered: What are the schools in our district?
--

SELECT DISTINCT
  school
FROM
  teachers;

--
-- Listing 2-4: Querying distinct pairs of values in the school and salary columns
-- Question answered: What are the various unique salaries across our school district?
--

SELECT DISTINCT
  school,
  salary
FROM
  teachers;

--
-- Listing 2-5: Querying subset of records ordered by salary desc
-- Question answered: What are the highest and lowest paid teachers?
--

SELECT
  first_name,
  last_name,
  salary
FROM
  teachers
ORDER BY
  salary DESC;

--
-- Listing 2-6: Querying subset of records ordered by school and hire date
-- Question answered: What are the newest teachers at each school?
--

SELECT
  last_name,
  school,
  hire_date
FROM
  teachers
ORDER BY
  school ASC,
  hire_date DESC;

--
-- Listing 2-7: Filtering rows using WHERE
-- Question answered: Which teachers work at Myers Middle School
--

SELECT
  last_name,
  school,
  hire_date
FROM
  teachers
WHERE
  school = 'Myers Middle School';

--
-- Comparison and Matdhing Operators
-- = | Equal to
-- <> or != | Not Equal to
-- > | Greater than
-- < | Less than
-- >= | Greater than or equal to
-- <= | Less than or equal to
-- BETWEEN | Within a range
-- In | Match a set of values | WHERE last_name IN ('Sooter', 'Wolfe', 'Thompson')
-- LIKE | Match a pattern (case sensitive) | WHERE first_name LIKE 'Sam%'
-- ILIKE | Match a pattern (case insensitive) | WHERE first_name ILIKE 'sam%'
-- NOT | Negates a condition | WHERE first_name NOT ILIKE 'sam%'
--
-- Teachers WITH FIRST name OF Janet
--

SELECT
  first_name,
  last_name,
  school
FROM
  teachers
WHERE
  first_name = 'Janet';

--
-- School names not equal to F.D. Roosevelt HS
--

SELECT
  school
FROM
  teachers
WHERE
  school != 'F.D. Roosevelt HS';

--
-- Teachers hired before Jan. 1, 2000
--

SELECT
  first_name,
  last_name,
  hire_date
FROM
  teachers
WHERE
  hire_date < '2000-01-01';

--
-- Teachers earning 43,500 or more
--

SELECT
  first_name,
  last_name,
  salary
FROM
  teachers
WHERE
  salary >= 43500;

--
-- Teachers who earn between $40,000 and $65,000
--

SELECT
  first_name,
  last_name,
  school,
  salary
FROM
  teachers
WHERE
  salary BETWEEN 40000 AND 65000;

--
-- Listing 2-8: Filtering with LIKE AND ILIKE
--
-- No results from first query due to case sensitivity

SELECT
  first_name
FROM
  teachers
WHERE
  first_name LIKE 'sam%';

-- Using PostgreSQL ILIKE returns results as it is case insensitive

SELECT
  first_name
FROM
  teachers
WHERE
  first_name ILIKE 'sam%';

--
-- Listing 2-9: Combining operators using AND and OR
--
--Teachers at Myers Middle school with a salary greater than 40000

SELECT
  *
FROM
  teachers
WHERE
  school = 'Myers Middle School'
  AND salary > 40000;

-- Teachers with last_name Cole or last_name Bush

SELECT
  *
FROM
  teachers
WHERE
  last_name = 'Cole'
  OR last_name = 'Bush';

-- Teachers at FD Roosevelt HS with
-- salary less than 38000 and greater than 40000

SELECT
  *
FROM
  teachers
WHERE
  school = 'F.D. Roosevelt HS'
  AND (salary < 38000
    OR salary > 40000);

-- Listing 2-10: A SELECT statement including WHERE and ORDER BY

SELECT
  first_name,
  last_name,
  school,
  hire_date,
  salary
FROM
  teachers
WHERE
  school LIKE '%Roos%'
ORDER BY
  hire_date DESC;

--
-- Exercise 1
-- List of teaters from each school alphabetically sorted
--

SELECT
  *
FROM
  teachers
ORDER BY
  school ASC,
  first_name ASC;

--
-- Exercise 2
-- Teacher with
-- first_name that starts with S and
-- earns more than 400000
--

SELECT
  *
FROM
  teachers
WHERE
  first_name ILIKE 's%'
  AND salary > 40000;

--
-- Exercise 3
-- Rank teachers hired since Jan 1, 2010 ordered by
-- highest paid to lowest
--

SELECT
  *
FROM
  teachers
WHERE
  hire_date >= '2010-01-01'
ORDER BY
  salary;

