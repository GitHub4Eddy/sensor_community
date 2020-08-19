# sensor_community

QuickApp SENSOR.COMMUNITY 

This QuickApp reads the PM2.5, PM10 values directly from a sensor somewhere in this world. That sensor doesn't have to be your sensor, any sensor can be used, just find one in your neighborhood. For locating a sensor(ID) in your neighborhood see: https://sensor.community/en/

The PM2.5 and PM10 readings are stored in the value of two (child) devices, so you can read the value from your own scenes. This QuickApp will send notifications when PM2.5 or PM10 readings reach a breakpoint

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
- Address = http://data.sensor.community/airrohr/v1/sensor/[SensorID]/
- SensorID = [number] (your own SensorID or from someone else, 13463 is an example)
- Interval = [number] (in seconds)
- Timeout = [number] (in seconds for http timeout)
- UserID = [number] userID to notify of PM2.5 / PM10 breakpoints

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
