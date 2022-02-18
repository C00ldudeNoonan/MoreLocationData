USE General

--SELECT  * from dbo.worldcities
--Go

-- adding id field to avoid duplicates. Same city name in mulitple countries
--ALTER TABLE dbo.worldcities
--ADD CityID int primary key IDENTITY(1,1) NOT NULL
--ALTER TABLE dbo.worldcities
--DROP COLUMN Id; 
--GO


 --creating time zone stage table
--IF OBJECT_ID('dbo.CityTimeZoneStage') is not null
--DROP TABLE dbo.CityTimeZoneStage 
--GO

--CREATE TABLE dbo.CityTimeZoneStage (
--	CityID Int NOT NULL,
--	CityName Varchar(225),
--	TimeZone Varchar(40)

--)
--GO

-- query to populate work queue
--SELECT
--worldcities.CityID,
--city_ascii AS CityName,
--Lat,
--Lng
--FROM dbo.worldcities
--LEFT JOIN dbo.CityTimeZoneStage
--	on CityTimeZoneStage.CityID = worldcities.CityID
--WHERE CityTimeZoneStage.CityID is null
--Go
---- results of python process
--SELECT * FROM CityTimeZoneStage

-- time zone table loaded in
-- updating time zone table for float for the offset
--UPDATE TimeZones
--Set Offset =
---- converting to float for the offset
--CASE WHEN Offset like '%:45%' then Replace(Replace(Offset,'UTC' ,''),':45', '.75') 
--	WHEN  Offset like '%:30%' then Replace(Replace(Offset,'UTC' ,''),':30', '.5') 
--	WHEN  Offset like '%:00%' then Replace(Replace(Offset,'UTC' ,''),':00', '.0') 
--	ELSE  Replace(Offset,'UTC' ,'') END
--ALTER TABLE TimeZones
--Add TimeZoneID int primary key IDENTITY(1,1) NOT NULL

--ALTER TABLE TimeZones
--ALTER COLUMN Offset float;

SELECT * FROM TimeZones
ORDER BY Time_zone_name DESC



--Distinct Time zones and lookup

--ALTER TABLE worldcities
--ADD TimezoneID int

---- Adding Foreign key constraint
--ALTER TABLE worldcities
--ADD CONSTRAINT FK_TimeZoneCity
--FOREIGN KEY (TimezoneId) REFERENCES TimeZones(TimezoneId); 


--Duplicate abbreviations
;WITH MulitpleAbbrevations as(
SELECT
Abbreviation,
COUNT(Distinct Time_zone_name) Counts
FROM TimeZones
GROUP BY
Abbreviation
HAVING COUNT(Distinct Time_zone_name) >1)

SELECT
TimeZones.TimeZoneID,
Time_zone_name,
TimeZones.Abbreviation
FROM MulitpleAbbrevations
JOIN TimeZones
	on MulitpleAbbrevations.Abbreviation = TimeZones.Abbreviation
GO

UPDATE TimeZones
SET Abbreviation = 'ACRE'
WHERE TimezoneID = 4

UPDATE TimeZones
SET Abbreviation = 'ARABT'
WHERE TimezoneID = 7

UPDATE TimeZones
SET Abbreviation = 'AMZNST'
WHERE TimezoneID = 16

UPDATE TimeZones
SET Abbreviation = 'AMZN'
WHERE TimezoneID = 18

UPDATE TimeZones
SET Abbreviation = 'CHINST'
WHERE TimezoneID = 63

UPDATE TimeZones
SET Abbreviation = 'BOUG'
WHERE TimezoneID = 40

UPDATE TimeZones
SET Abbreviation = 'ARABS'
WHERE TimezoneID = 24

UPDATE TimeZones
SET Abbreviation = 'BANG'
WHERE TimezoneID = 41

UPDATE TimeZones
SET Abbreviation = 'CUBA'
WHERE TimezoneID = 48

UPDATE TimeZones
SET Abbreviation = 'SGEG'
WHERE TimezoneID = 99

UPDATE TimeZones
SET Abbreviation = 'IRIS'
WHERE TimezoneID = 116

UPDATE TimeZones
SET Abbreviation = 'CUBAS'
WHERE TimezoneID = 64

UPDATE TimeZones
SET Abbreviation = 'ISRA'
WHERE TimezoneID = 117

UPDATE TimeZones
SET Abbreviation = 'PICT'
WHERE TimezoneID = 175

UPDATE TimeZones
SET Abbreviation = 'PYON'
WHERE TimezoneID = 180

UPDATE TimeZones
SET Abbreviation = 'WSAM'
WHERE TimezoneID = 234
GO

--Query to match the time zone from the api to the time zones in the database
-- need to sort out the one to many relationships
SELECT Distinct 
	CityTimeZoneStage.CityID,
	CASE WHEN CityTimeZoneStage.CityID = 810 THEN 'MHT'
		WHEN CityTimeZoneStage.CityID in (828,13439,23217) THEN 'WIT' 
		WHEN TimeZone like '%+%' THEN LEFT(TimeZone,3) 
		WHEN TimeZone = 'URUT' THEN 'KGT'
		WHEN TimeZone = 'VOLT' THEN 'MSK'
		WHEN TimeZone ='KGST' THEN 'OMST'
		WHEN TimeZone = 'QYZST' THEN 'OMST'
		WHEN TimeZone = 'ORAST' THEN 'ORAT'
		WHEN CountryName = 'China' AND TimeZone = 'CST'  THEN 'CHINST'
		WHEN CountryName ='Cuba' THEN 'CUBAS'
		ELSE TimeZone END AS TimeZone,
	TimeZones.Time_zone_name,
	Timezones.Location,
	TimeZones.Abbreviation,
	Timezones.TimeZoneId,
	Countries.CountryName

FROM CityTimeZoneStage
JOIN worldcities

	on worldcities.CityID = CityTimeZoneStage.CityID
JOIN Countries
	on Countries.CountryId = worldcities.CountryId
LEFT JOIN TimeZones
	on TimeZones.Abbreviation = CASE WHEN CityTimeZoneStage.CityID = 810 THEN 'MHT'
	WHEN CityTimeZoneStage.CityID in (828,13439,23217) THEN 'WIT' 
	WHEN TimeZone like '%+%' THEN LEFT(TimeZone,3) 
	WHEN TimeZone = 'URUT' THEN 'KGT'
	WHEN TimeZone = 'VOLT' THEN 'MSK'
	WHEN TimeZone ='KGST' THEN 'OMST'
	WHEN TimeZone = 'QYZST' THEN 'OMST'
	WHEN TimeZone = 'ORAST' THEN 'ORAT'
	--north America and China
	WHEN CountryName = 'China' AND TimeZone = 'CST'  THEN 'CHINST'
	WHEN CountryName = 'Cuba' THEN 'CUBAS'
	ELSE TimeZone END
WHERE 
--TimeZones.Abbreviation is null And 
CityTimeZoneStage.TimeZone <> ''
--AND CountryName ='Cuba'




-- putting update into temp table
SELECT Distinct 
CityTimeZoneStage.CityID,
--CASE WHEN CityTimeZoneStage.CityID = 810 THEN 'MHT'
--	WHEN CityTimeZoneStage.CityID in (828,13439,23217) THEN 'WIT' 
--	WHEN TimeZone like '%+%' THEN LEFT(TimeZone,3) 
--	WHEN TimeZone = 'URUT' THEN 'KGT'
--	WHEN TimeZone = 'VOLT' THEN 'MSK'
--	WHEN TimeZone ='KGST' THEN 'OMST'
--	WHEN TimeZone = 'QYZST' THEN 'OMST'
--	WHEN TimeZone = 'ORAST' THEN 'ORAT'
--	WHEN CountryName = 'China' AND TimeZone = 'CST'  THEN 'CHINST'
--	WHEN CountryName ='Cuba' THEN 'CUBAS'
----	ELSE TimeZone END AS TimeZone,
--	TimeZones.Time_zone_name,
--	Timezones.Location,
--	TimeZones.Abbreviation,
	Timezones.TimeZoneId
	--Countries.CountryName
INTO #TempUpdate
FROM CityTimeZoneStage
JOIN worldcities
	on worldcities.CityID = CityTimeZoneStage.CityID
JOIN Countries
	on Countries.CountryId = worldcities.CountryId
LEFT JOIN TimeZones
	on TimeZones.Abbreviation = CASE WHEN CityTimeZoneStage.CityID = 810 THEN 'MHT'
	WHEN CityTimeZoneStage.CityID in (828,13439,23217) THEN 'WIT' 
	WHEN TimeZone like '%+%' THEN LEFT(TimeZone,3) 
	WHEN TimeZone = 'URUT' THEN 'KGT'
	WHEN TimeZone = 'VOLT' THEN 'MSK'
	WHEN TimeZone ='KGST' THEN 'OMST'
	WHEN TimeZone = 'QYZST' THEN 'OMST'
	WHEN TimeZone = 'ORAST' THEN 'ORAT'
	WHEN CountryName = 'China' AND TimeZone = 'CST'  THEN 'CHINST'
	WHEN CountryName = 'Cuba' THEN 'CUBAS'
	ELSE TimeZone END
WHERE 
--TimeZones.Abbreviation is null And 
CityTimeZoneStage.TimeZone <> ''
GO

-- updating main table
UPDATE worldcities
SET worldcities.TimeZoneid = #TempUpdate.TimeZoneId
FROM #TempUpdate
WHERE worldcities.CityID = #TempUpdate.CityID
GO

DROP TABLE #TempUpdate
GO

-- add id column
ALTER TABLE dbo.ZipCode
ADD ZipID int primary key IDENTITY(1,1) NOT NULL

-- time zone match up
ALTER TABLE ZipCode
ADD TimezoneID int


SELECT 
ZipCode.state,
COUNT(DISTINCT Timezone)
FROM ZipCode
GROUP BY 
ZipCode.state
HAVING COUNT( DISTINCT Timezone) >1



SELECT DISTINCT
--acceptable_cities, 1) uncomment for mapping query
ZipCode.ZipID,
--state, 1)
--timezone,
--TimezoneID,
 CASE 
	WHEN state in ('AL', 'AR', 'IL', 'IA', 'LA', 'MN', 'MS', 'MO', 'OK', 'WI') 
		or timezone in ( 'America/Chicago' , 'America/Kentucky/Louisville', 'America/Kentucky/Monticello', 'America/Menominee'
						, 'America/Indiana/Tell_City', 'America/North_Dakota/Center', 'America/North_Dakota/New_Salem', 'America/Indiana/Knox')THEN 'CST'
	WHEN state in ('CT','DC', 'DE', 'GA','FL', 'ME', 'MA', 'NH', 'NJ', 'NY', 'NC', 'OH', 'PA', 'PR','RI', 'SC', 'VT', 'VA', 'WV', 'VI')
		or timezone in ('America/New_York', 'America/Detroit', 'America/Indiana/Marengo', 'America/Indiana/Vincennes'
						, 'America/Indiana/Winamac', 'America/Indiana/Indianapolis', 'America/Indiana/Petersburg', 'America/Indiana/Vevay') THEN 'EST'
	WHEN state in ('HI') or timezone = 'America/Adak' THEN 'HST'
	WHEN State in ('AZ', 'CO', 'MT', 'NM', 'UT', 'WY') OR timezone in ('America/Denver', 'America/North_Dakota/Beulah') THEN 'MST'
	WHEN State in ('CA', 'WA') OR timezone in ('America/Los_Angeles', 'America/Boise') THEN 'PST'
	WHEN timezone in ('America/Anchorage', 'America/Juneau', 'America/Metlakatla', 'America/Nome', 'America/Sitka', 'America/Yakutat', 'Napakiak') THEN 'AKST'
	WHEN state in ('PW') THEN 'PWT'
	WHEN state in ('GU', 'FM', 'MP') THEN 'CHST'
	WHEN state = 'MH' THEN 'MHT'
	WHEN state = 'AS' THEN 'SST'
	WHEN state in ('AE', 'AP', 'AA') THEN 'UTC'
	WHEN state IN ('TX', 'OR') and timezone is null then 'MST'
	ELSE null END AS TimezoneAbrreviation
INTO #TempUpdate
FROM ZipCode
--WHERE 
--timezone is not null AND 1)
 --CASE 
	--WHEN state in ('AL', 'AR', 'IL', 'IA', 'LA', 'MN', 'MS', 'MO', 'OK', 'WI') 
	--	or timezone in ( 'America/Chicago' , 'America/Kentucky/Louisville', 'America/Kentucky/Monticello', 'America/Menominee'
	--					, 'America/Indiana/Tell_City', 'America/North_Dakota/Center', 'America/North_Dakota/New_Salem', 'America/Indiana/Knox')THEN 'CST'
	--WHEN state in ('CT','DC', 'DE', 'GA','FL', 'ME', 'MA', 'NH', 'NJ', 'NY', 'NC', 'OH', 'PA', 'PR','RI', 'SC', 'VT', 'VA', 'WV', 'VI')
	--	or timezone in ('America/New_York', 'America/Detroit', 'America/Indiana/Marengo', 'America/Indiana/Vincennes'
	--					, 'America/Indiana/Winamac', 'America/Indiana/Indianapolis', 'America/Indiana/Petersburg', 'America/Indiana/Vevay') THEN 'EST'
	--WHEN state in ('HI') or timezone = 'America/Adak' THEN 'HST'
	--WHEN State in ('AZ', 'CO', 'MT', 'NM', 'UT', 'WY') OR timezone in ('America/Denver', 'America/North_Dakota/Beulah') THEN 'MST'
	--WHEN State in ('CA', 'WA') OR timezone in ('America/Los_Angeles', 'America/Boise') THEN 'PST'
	--WHEN timezone in ('America/Anchorage', 'America/Juneau', 'America/Metlakatla', 'America/Nome', 'America/Sitka', 'America/Yakutat', 'Napakiak') THEN 'AKST'
	--WHEN state in ('PW') THEN 'PWT'
	--WHEN state in ('GU', 'FM', 'MP') THEN 'CHST'
	--WHEN state = 'MH' THEN 'MHT'
	--WHEN state = 'AS' THEN 'SST'
	--WHEN state in ('AE', 'AP', 'AA') THEN 'UTC'
	--WHEN state IN ('TX', 'OR') and timezone is null then 'MST'
	--ELSE null END is null

--SELECT * FROM TimeZones
GO

-- loading into temp table for update
UPDATE ZipCode
SET ZipCode.TimezoneID = TimeZones.TimeZoneID
FROM #TempUpdate
JOIN TimeZones
	on TimeZones.Abbreviation = #TempUpdate.TimezoneAbrreviation
GO

DROP TABLE #TempUpdate

---- Adding Foreign key constraint
ALTER TABLE ZipCode
ADD CONSTRAINT FK_TimeZoneZip
FOREIGN KEY (TimezoneId) REFERENCES TimeZones(TimezoneId); 
--city id mapping

SELECT * FROM ZipCode

ALTER TABLE ZipCode
DROP COlUMN timezone


IF OBJECT_ID('dbo.CityTimeZoneStage') is not null
DROP TABLE dbo.CityTimeZoneStage 
GO

ALTER TABLE worldcities
ADD CONSTRAINT FK_worldcitiesTimeZone
FOREIGN KEY (TimezoneId) REFERENCES TimeZones(TimezoneId); 
GO

ALTER TABLE worldcities
ADD CONSTRAINT FK_worldcitiesCountries
FOREIGN KEY (CountryId) REFERENCES Countries(CountryId); 
GO 