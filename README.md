# MoreLocationData
Project Repo which expands the city database to include Timezones and American Zip Codes as added Dimensions

Timezones and Zip codes can be loaded into the SQL Database created from the previous post. 

Code that was used to troubleshoot or test out process is left in to show how process of iterating through a project. 

## SQL File

Lines 1-25: Creating staging table for storing the results of the time zone API pull. 

Lines 27-36: Query used to populate the work queue in Python

Lines 45-58: Cleaning up data and modifying Timezone table

Lines 67-74: Adding timezone foreign key to world cities

Lines 77-155: Cleaning up Timezone table of duplicates

Lines 158-199: Query to identify and correctly map Timezones from Stage table and TimeZone Table

Lines 205-253: Updating WorldCities table with Timezones using temp tables

Lines 260-265: Cleaning Up ZipCode Table

Lines 268-274: Multiple Timezones in a state check

Lines 278-334: Zipcode-Timezone Mapping query and update

Lines 339-359: Adding Constraints and dropping unneeded columns and objects 



## Python File

Lines 8-21: Connecting to Database and loading results into dataframe

Lines 29-54: Iterating over dataframe. Query from API, and loading results into SQL Staging table. 
