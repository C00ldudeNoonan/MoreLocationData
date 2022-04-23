

import pyodbc
import pandas as pd
import time 
import requests

conn = pyodbc.connect('Driver=SQL Server;Server=;Database=General;Trusted_Connection=yes;')

# select top 10 for testing process
df = pd.read_sql_query('SELECT \
                            worldcities.WorldCitiesID,\
                            CityName_ASCII AS CityName,\
                            ROUND(Latitude,2) as Latitude,\
                            ROUND(Longitude,2) as Longitude\
                        FROM dbo.worldcities\
                        LEFT JOIN dbo.CityTimeZoneStage\
	                        on CityTimeZoneStage.WorldCitiesID = worldcities.WorldCitiesid\
                        WHERE CityTimeZoneStage.WorldCitiesID is null', conn)
# need to read in query from sql server for city name, latitude and longitude
conn.close()

# print(df.head())

# for loop through dataframe 
# not fastest way to iterate but its conceptually easy
# 1 request per second from api slows it down anyway

key = ""

# timezones = []
for index, row in df.iterrows():
    # debug prints
    # print(row['Lat'])
    # print(row['Lng'])
    # print(row['CityName'])
    # this api request returns a JSON object
    r = requests.get("http://api.timezonedb.com/v2.1/get-time-zone?key="+key+"&format=json&by=position&lat="+str(row['Latitude'])+"&lng="+str(row['Longitude'])).json()
    
    # inspecting JSON Object
    # print(r)
    
    # appeding pairs to list
    #timezones.append([row['CityName'], r['abbreviation']])

    conn = pyodbc.connect('Driver=SQL Server;Server=;Database=General;Trusted_Connection=yes;')

    # inserting into SQL Staging table
    cursor = conn.cursor()
    cursor.execute("INSERT INTO dbo.CityTimeZoneStage (WorldCitiesID, CityName,TimeZone) values(?,?,?)",row['WorldCitiesID'], row['CityName'], r['abbreviation'])
    conn.commit()
    cursor.close()

    # wait 3 seconds
    time.sleep(3)
    
# to see what list looks like
# print(timezones)

#df = pd.DataFrame(timezones, columns=['CityName', 'TimeZone'])

# load results into sql table
#conn = pyodbc.connect('Driver=SQL Server;Server=;Database=General;Trusted_Connection=yes;')

#cursor = conn.cursor()
# Insert Dataframe into SQL Server:
#for index, row in df.iterrows():
     #cursor.execute("INSERT INTO dbo.CityTimeZoneStage (CityName,TimeZone) values(?,?)", row['CityName'], row['TimeZone'])

#conn.commit()
#cursor.close()
