--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- Chapter 1 Exercise 1 - Zoo Animals Database
--------------------------------------------------------------
-- Create a database named tulsa_zoo
CREATE DATABASE tulsa_zoo;
-- Create a table named animals with 6 columns
CREATE TABLE animals (
  id bigserial,
  -- name given to animal for exhibit
  public_name varchar(25),
  -- exact animal species name
  species_name varchar(25),
  -- family that species exists within
  family_name varchar(25),
  -- zoo department
  department varchar(25),
  -- animal birth date
  birth_date date
);
-- Remove (drop) the table
-- DROP TABLE tulsa_zoo;
-- Inserting data into the tulsa_zoo `animals` table
INSERT INTO
  animals (
    public_name,
    species_name,
    family_name,
    department,
    birth_date
  )
VALUES
  (
    'jason',
    'gorilla',
    'monkey',
    'primates',
    '1982-12-24'
  ),
  (
    'andrea',
    'bald eagle',
    'bird',
    'bird',
    '1984-09-16'
  ),
  (
    'ellie',
    'panda bear',
    'bear',
    'woodland',
    '2012-06-03'
  ),
  (
    'mac',
    'cheetah',
    'big cat',
    'grassland',
    '2013-12-31'
  ),
  (
    'poppy',
    'zebra',
    'mammal',
    'grassland',
    '2015-04-29'
  ),
  (
    'finnegan',
    'cat',
    'domestic cat',
    'domestic',
    '2008-08-31'
  );
-- Create `departments` table with 2 columns
  CREATE TABLE departments (
    id bigserial,
    -- department name
    department_name varchar(25)
  );
-- Insert departments
INSERT INTO
  departments (department_name)
VALUES
  ('primates'),
  ('bird'),
  ('woodland'),
  ('grassland'),
  ('domestic');