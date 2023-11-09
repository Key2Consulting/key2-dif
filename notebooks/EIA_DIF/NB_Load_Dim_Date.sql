-- Databricks notebook source
USE eia_gold;
CREATE OR REPLACE TABLE dim_date
AS
SELECT REPLACE(calendar_date, '-', '') AS date_id
	, calendar_date AS date_full
	, YEAR(calendar_date) AS year
	, QUARTER(calendar_date) AS quarter
	, MONTH(calendar_date) AS month
	, weekofyear(calendar_date) AS week
	, DAY(calendar_date) AS day
	, WEEKDAY(calendar_date) AS day_of_week
	, date_format(calendar_date, 'EEEE') AS day_name
	, date_format(calendar_date, 'MMMM') AS month_name
	, CASE 
      WHEN dayofweek(calendar_date) IN (1, 7) THEN 0
		  ELSE 1
		END AS is_weekday
	, CASE 
		  WHEN year(calendar_date) % 4 = 0 THEN 1
		  ELSE 0
		END AS is_leapyear
FROM
  (
    SELECT explode(sequence(DATE '2010-01-01', DATE '2030-12-31', INTERVAL 1 DAY)) AS calendar_date
  ) AS dates


-- COMMAND ----------

SELECT *
FROM eia_gold.dim_date
