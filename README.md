# sensor_community
This QuickApp reads the PM2.5, PM10, Temperature, Humidity and Airpressure values directly from a sensor somewhere in this world
That sensor doesn't have to be your own sensor, any sensor can be used, just find one in your neighborhood 
For locating the sensor(ID's) in your neighborhood see: https://sensor.community/en/
Select two (!) SensorID's, one for PM2.5 and PM10 values and one for Temperature, Humidity and Airpressure values

The PM2.5, PM10, Temperature, Humidity, Absolute Humidity and Airpressure readings are stored in the value of six (child) devices, so you can read the value from your own scenes
This QuickApp will send notifications when PM2.5 or PM10 readings reach a breakpoint (if userID ~= 0)

Absolute humidity is the measure of water vapor (moisture) in the air, regardless of temperature. It is expressed as grams of moisture per cubic meter of air (g/m3) 


Version 1.0 (7th February 2021)
- Added Child Devices for Temperature, Humidity, Absolute Humidity and Airpressure
- Changed the quickapp variable SensorID to two variables, one for PM values and one for Temperature, Humidity and Airpressure values
- Added Quickapp variable for debug level (1=some, 2=few, 3=all). Recommended default value is 1.
- Added QuickApp Variable for user defined icon master device-- Added Airpressure Text in log of Airpressure Child Device
- Removed QuickApp Variable address, there was no need to change it by user
- Added values for Temperature, Humidity, Absolute Humidity and Airpressure to the lables
- Added values for Country, Latitude and Longitude to the labels
- Added Sensor ID to the log below the value
- Added "Refresh" button
- Added extra check for empty data return from Sensor Community

Version 0.4:
- Added child devices for PM2.5 and PM10
- Added time of measurement, adjusted to your timezone
- Added Timeout QuickApp variable with high http timeout value to prevent errors
- Error message instead off debug message in case of an error
- Changed method of adding QuickApp variables, so they can be edited


See also https://luftdaten.info
See also for CVS files: https://archive.luftdaten.info
See also https://github.com/opendata-stuttgart/
API documentation: https://github.com/opendata-stuttgart/meta/wiki/EN-APIs


Variables (mandatory): 
- sensorID1 = [number] SensorID for PM2.5 and PM10 values, your own sensor or from someone else, 13463 is an example
- sensorID2 = [number] SensorID for Temperature, Humidity and Airpressure values, your own sensor or from someone else, 13464 is an example
- interval = [number] in seconds time to get the sensor data from sensor.community
- timeout = [number] in seconds for http timeout
- userID = [number] userID to notify of PM2.5 / PM10 breakpoints
- debugLevel = [number] Debug logging (1=some, 2=few, 3=all) (default = 1)
- icon = [numbber] User defined icon number (add the icon via an other device and lookup the number)


PM2.5 breakpoints
0 - 30    GOOD (Minimal)
31 - 60   SATISFACTORY (Minor breathing discomfort to sensitive people)
61 - 90   MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children
91 - 120  POOR (Breathing discomfort to all)
121 - 250 VERY POOR (Respiratory illness on prolonged exposure)
250+      SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)

PM10 breakpoints
0 - 50    GOOD (Minimal)
51 - 100  SATISFACTORY (Minor breathing discomport to sensitive people)
101 - 250 MODERATELY POLLUTED Breathing discomfoort to asthma patients, elderly and children
251 - 350 POOR (Breathing discomfort to all)
351 - 430 VERY POOR (Respiratory illness on prolonged exposure)
430+      SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)
