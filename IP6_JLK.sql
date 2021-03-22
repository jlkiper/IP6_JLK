#Individual Project 6
#Author: Jaylon Kiper
#Version: 1.0
#Semester: Spring 2021
#Summary: The goal of this project is to write several different 
#SQL queries to extract data from a database over the network.

USE crime_data;

#1.Extract the number of different crime types are in the incident_reports table. Name the
#output column unique_crimes.
SELECT DISTINCT(crime_type) AS unique_crimes
FROM incident_reports;

#2.Extract the number of incidents for each crime type in the incident_reports table. The
#output column for count of each crime type should be called num_crimes and the results should be 
#sorted alphabetically (ascending) by crime type.
SELECT DISTINCT(crime_type) AS unique_crimes, COUNT(crime_type) AS num_crimes
FROM incident_reports
GROUP BY crime_type
ORDER BY crime_type ASC;

#3.Extract the number of incidents that were reported on the same day they occurred. You
#will need to determine how to get the difference of date columns in MySQL.
SELECT date_reported,date_occured
FROM incident_reports
WHERE DATE(date_reported) LIKE DATE(date_occured);

#4.Find the amount of time between the date an incident was reported and the date it occurred.
#The result should include the date it was reported, the date it occurred, the crime type and the difference in
#years. In addition, the result should only include differences that were one year or more. Sort the result so
#the longest distance appears at the top.
SELECT date_reported, date_occured, crime_type, YEAR(date_reported) - YEAR(date_occured) as diff_years
FROM incident_reports
ORDER BY diff_years DESC;

#5.Get a count by year of all crimes from the past 10 years (e.g. 2021 – 2012). Your results
#should be sorted so 2021 appears at the top and your columns should be named year and num_incidents.
SELECT DISTINCT YEAR(date_reported) as year, COUNT(incident_number)
FROM incident_reports
GROUP BY year
ORDER BY year DESC;

#6.Return all columns in rows in which the crime type is robbery.
SELECT *
FROM incident_reports
WHERE crime_type = "ROBBERY";

#7.Return the LMPD division, Incident Number, and date the incident occurred (in that
#order) for attempted robberies. Order the results by the LMPD Division and the date (ascending for both).
SELECT lmpd_division, incident_number, date_occured
FROM incident_reports
WHERE crime_type = "ROBBERY" AND att_comp = "ATTEMPTED"
ORDER BY lmpd_division, date_occured;

#8.Return the date the incident occurred and the type of crime for the zip code 40202. Order
#the results by the type of crime and then by the date the incident occurred.
SELECT date_occured, crime_type
FROM incident_reports
WHERE zip_code = "40202"
ORDER BY crime_type, date_occured;

#9.Determine which zip code has the highest number of vehicle thefts. In your query,
#include the zip code and a number of incidents in that zip code in a column named num_thefts. Sort the
#output so the zip code with the highest number of thefts appears at the top. For this, report the query, the
#number of results, and the zip code with the highest number of thefts.
SELECT DISTINCT zip_code, COUNT(incident_number) AS num_thefts
FROM incident_reports
WHERE crime_type = "MOTOR VEHICLE THEFT" AND LENGTH(zip_code) = 5
GROUP BY zip_code
ORDER BY num_thefts DESC;
#40214 has the highest number of thefts with 4566.

#10.Determine how many different cities are the reported in the Incident Reports.
SELECT COUNT(DISTINCT city) as city_count
FROM incident_reports;
#234

#11.Determine which city had the second highest number of incidents behind Louisville.
#Your query should only include the city and the number of incidents and be sorted by the number of
#incidents. For this report the query, the city with the second highest number of incidents and the number.
#Comment on if you see anything weird in your results.
SELECT city, COUNT(incident_number) as incident_count
FROM incident_reports
GROUP BY city
ORDER BY incident_count DESC;
#LVIL, 37299

#12.Return Uniform Offense Reporting code and the type of crime order in which the type of
#crime is not OTHER. Order the results by the UOR code and then by crime type. In your result, explain
#what the difference between the two columns seem to be.
SELECT uor_desc, crime_type
FROM incident_reports
WHERE crime_type NOT LIKE "OTHER"
ORDER BY uor_desc,crime_type;
#The uor_desc is a full description of the incident while 
#the other column just lists the type of crime it is.

#13.Determine how many LMPD beats there are.
SELECT COUNT(DISTINCT lmpd_beat) as beat_count
FROM incident_reports;
#60

#14.Determine how many NIBRS codes exist (in the nibrs_codes table).
SELECT COUNT(*) as code_count
FROM nibrs_codes;
#61

#15.Determine how many of the NIBRS codes appear in the Incident Reports table. You are
#finding UNIQUE NIBRS codes.
SELECT COUNT(DISTINCT nibrs_code) as code_count
FROM incident_reports;
#54

#16.List the date the incident occurred, the Block address, the zip code and the NIBRS
#Offense Description. Retrieve only rows for NIBRS codes 240, 250, 270, and 280. Sort the results by the
#Block address.
SELECT date_occured, block_address, zip_code, nibrs_code
FROM incident_reports
WHERE nibrs_code = 240 AND 250 AND 270 AND 280
ORDER BY block_address;

#17.Show the zip code and the type of entity the offense was against. In your results, remove
#any rows with an empty NIBRS code and an invalid zip code. You can do that with the LENGTH function in
#MySQL to find all zip codes that 5 digits or more. Sort the results by zip code.
SELECT zip_code, offense_against
FROM nibrs_codes
JOIN incident_reports ON
nibrs_codes.offense_code = incident_reports.nibrs_code
WHERE offense_against NOT LIKE "" and LENGTH(zip_code) = 5 and offense_code NOT LIKE 999
ORDER BY zip_code DESC;

#18.Show a count of each number of offense against various entities (e.g. Not a Crime,
#Property, etc.) Order the results by the offense against column in the nibrs_codes table. Remove any rows
#for which the offense against value is empty.
SELECT offense_against,COUNT(offense_against) AS entity_count
FROM nibrs_codes
GROUP BY offense_against
HAVING offense_against NOT LIKE "";

#19.Single table query of your own choosing that I haven’t already asked for that performs an aggregate
#query of some type and that restricts the result row with a HAVING clause.
SELECT COUNT(ucr_hierarchy)
FROM incident_reports
GROUP BY ucr_hierarchy
HAVING ucr_hierarchy = "PART I";

#20.Multi-table query of your own choosing that I haven’t already asked for that show data from both
#tables, which applies a sort of some type and restricts rows by some criteria.
SELECT incident_number,lmpd_division,offense_category
FROM incident_reports
JOIN nibrs_codes ON
incident_reports.nibrs_code = nibrs_codes.offense_code
ORDER BY lmpd_division
LIMIT 100;
