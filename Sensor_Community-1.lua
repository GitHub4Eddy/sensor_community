-- QuickApp SENSOR.COMMUNITY 

-- This QuickApp reads the PM2.5, PM10, Temperature, Humidity and Airpressure values directly from a sensor somewhere in this world
-- That sensor doesn't have to be your own sensor, any sensor can be used, just find one in your neighborhood 
-- For locating the sensor(ID's) in your neighborhood see: https://sensor.community/en/
-- Select two (!) SensorID's, one for PM2.5 and PM10 values and one for Temperature, Humidity and Airpressure values

-- The PM2.5, PM10, Temperature, Humidity, Absolute Humidity and Airpressure readings are stored in the value of six (child) devices, so you can read the value from your own scenes
-- This QuickApp will send notifications when PM2.5 or PM10 readings reach a breakpoint (if userID ~= 0)

-- Absolute humidity is the measure of water vapor (moisture) in the air, regardless of temperature. It is expressed as grams of moisture per cubic meter of air (g/m3) 


-- Version 1.0 (7th February 2021)
-- Added Child Devices for Temperature, Humidity, Absolute Humidity and Airpressure
-- Changed the quickapp variable SensorID to two variables, one for PM values and one for Temperature, Humidity and Airpressure values
-- Added Quickapp variable for debug level (1=some, 2=few, 3=all). Recommended default value is 1.
-- Added QuickApp Variable for user defined icon master device-- Added Airpressure Text in log of Airpressure Child Device
-- Removed QuickApp Variable address, there was no need to change it by user
-- Added values for Temperature, Humidity, Absolute Humidity and Airpressure to the lables
-- Added values for Country, Latitude and Longitude to the labels
-- Added Sensor ID to the log below the value
-- Added "Refresh" button
-- Added extra check for empty data return from Sensor Community


-- Version 0.4 (19th August 2020)
-- Added child devices for PM2.5 and PM10
-- Added time of measurement, adjusted to your timezone
-- Added timeout QuickApp variable with high http timeout value to prevent errors
-- Error message instead off debug message in case of an error
-- Changed method of adding QuickApp variables, so they can be edited


-- See also https://luftdaten.info
-- See also for CVS files: https://archive.luftdaten.info
-- See also https://github.com/opendata-stuttgart/
-- API documentation: https://github.com/opendata-stuttgart/meta/wiki/EN-APIs


-- Variables (mandatory): 
-- sensorID1 = [number] SensorID for PM2.5 and PM10 values, your own sensor or from someone else, 13463 is an example
-- sensorID2 = [number] SensorID for Temperature, Humidity and Airpressure values, your own sensor or from someone else, 13464 is an example
-- interval = [number] in seconds time to get the sensor data from sensor.community
-- timeout = [number] in seconds for http timeout
-- userID = [number] userID to notify of PM2.5 / PM10 breakpoints
-- debugLevel = [number] Debug logging (1=some, 2=few, 3=all) (default = 1)
-- icon = [numbber] User defined icon number (add the icon via an other device and lookup the number)


-- PM2.5 breakpoints
-- 0 - 30    GOOD (Minimal)
-- 31 - 60   SATISFACTORY (Minor breathing discomfort to sensitive people)
-- 61 - 90   MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children
-- 91 - 120  POOR (Breathing discomfort to all)
-- 121 - 250 VERY POOR (Respiratory illness on prolonged exposure)
-- 250+      SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)

-- PM10 breakpoints
-- 0 - 50    GOOD (Minimal)p
-- 51 - 100  SATISFACTORY (Minor breathing discomport to sensitive people)
-- 101 - 250 MODERATELY POLLUTED Breathing discomfoort to asthma patients, elderly and children
-- 251 - 350 POOR (Breathing discomfort to all)
-- 351 - 430 VERY POOR (Respiratory illness on prolonged exposure)
-- 430+      SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)


-- No editing of this code is needed 


class 'PolutionSensorTemp'(QuickAppChild)
function PolutionSensorTemp:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Air Quality Temperature sensor initiated, deviceId:",self.id)
end
function PolutionSensorTemp:updateValue(data,userID) 
  --self:debug("Temperature: ",data.temperature)
  self:updateProperty("value",tonumber(data.temperature))
end

class 'PolutionSensorHumid'(QuickAppChild)
function PolutionSensorHumid:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Air Quality Humidity sensor initiated, deviceId:",self.id)
end
function PolutionSensorHumid:updateValue(data,userID) 
  self:updateProperty("value",tonumber(data.humidity)) 
end

class 'PolutionSensorHumidAbs'(QuickAppChild)
function PolutionSensorHumidAbs:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Air Quality Absolute Humidity sensor initiated, deviceId:",self.id)
end
function PolutionSensorHumidAbs:updateValue(data,userID) 
  self:updateProperty("value",tonumber(data.humidityabsolute)) 
  self:updateProperty("unit", "g/m³")
end

class 'PolutionSensorPressure'(QuickAppChild)
function PolutionSensorPressure:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Air Quality Airpressure sensor initiated, deviceId:",self.id)
end
function PolutionSensorPressure:updateValue(data,userID) 
  self:updateProperty("value",tonumber(data.airpressure)) 
  self:updateProperty("unit", "hPa")
  self:updateProperty("log", data.airpressuretext)
end

class 'PolutionSensorPM25'(QuickAppChild)
function PolutionSensorPM25:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("PM2.5 sensor initiated, deviceId:",self.id)
end

function PolutionSensorPM25:updateValue(data,userID)  

  local pm25,pm25prev = data.pm25,data.pm25prev

  -- Send notifications when PM2.5 level reach breakpoints 
  -- PM2.5 breakpoint 0 - 30 GOOD (Minimal)
  if (tonumber(pm25) > 0 and tonumber(pm25) <= 30) then
    pm25Text = "GOOD"
    if (pm25prev > 30) then
      fibaro.alert("push", {userID}, "PM2.5 "..pm25 .." µg/m³" .." level GOOD (Minimal)")
      self:debug("PM2.5 level GOOD (Minimal)",pm25 .." µg/m³")
    end
  end
  -- PM2.5 breakpoint 31 - 60 SATISFACTORY (Minor breathing discomfort to sensitive people)
  if (tonumber(pm25) >= 31 and tonumber(pm25) <= 60) then
    pm25Text = "SATISFACTORY"
    if (pm25prev < 31 or pm25prev > 60) then
      fibaro.alert("push", {userID}, "PM2.5 "..pm25 .." µg/m³" .." level SATISFACTORY (Minor breathing discomfort to sensitive people)")
      self:debug("PM2.5 level SATISFACTORY (Minor breathing discomfort to sensitive people)",pm25 .." µg/m³")
    end
  end
  -- PM2.5 breakpoint 61 - 90 MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children
  if (tonumber(pm25) >= 61 and tonumber(pm25) <= 90) then
    pm25Text = "MODERATELY POLLUTED"
    if (pm25prev < 61 or pm25prev > 90) then
      fibaro.alert("push", {userID}, "PM2.5 "..pm25 .." µg/m³" .." level MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children")
      self:debug("PM2.5 level MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children",pm25 .." µg/m³")
    end 
  end
  -- PM2.5 breakpoint 91 - 120 POOR (Breathing discomfort to all)
  if (tonumber(pm25) >= 91 and tonumber(pm25) <= 120) then
    pm25Text = "POOR"
    if (pm25prev < 91 or pm25prev > 120) then
      fibaro.alert("push", {userID}, "PM2.5 "..pm25 .." µg/m³" .." level POOR (Breathing discomfort to all)")
      self:debug("PM2.5 level POOR (Breathing discomfort to all)",pm25 .." µg/m³")
    end
  end
  -- PM2.5 breakpoint 120 - 250 VERY POOR (Respiratory illness on prolonged exposure)
  if (tonumber(pm25) >= 120 and tonumber(pm25) <= 250) then
    pm25Text = "VERY POOR"
    if (pm25prev < 121 or pm25prev > 250) then
      fibaro.alert("push", {userID}, "PM2.5 "..pm25 .." µg/m³" .." level VERY POOR (Respiratory illness on prolonged exposure)")
      self:debug("PM2.5 level VERY POOR (Respiratory illness on prolonged exposure)",pm25 .." µg/m³")
    end
  end
  -- PM2.5 breakpoint 250+ SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)
  if (tonumber(pm25) >= 250 ) then
    pm25Text = "SEVERE"
    if (pm25prev < 250) then
      fibaro.alert("push", {userID}, "PM2.5 "..pm25 .." µg/m³" .." level SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)")
      self:debug("PM2.5 level SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)",pm25 .." µg/m³")
    end
  end

  if tonumber(pm25) > tonumber(pm25prev) then
    pm25Trend = " ↑"
  elseif tonumber(pm25) < tonumber(pm25prev) then
    pm25Trend = " ↓"
  else
    pm25Trend = " ="
  end 

  -- Update properties for PM2.5 sensor
  self:updateProperty("value", tonumber(pm25)) 
  self:updateProperty("unit", "㎍/㎥")
  self:updateProperty("log", pm25Text ..pm25Trend)
end

class 'PolutionSensorPM10'(QuickAppChild)
function PolutionSensorPM10:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("PM10 sensor initiated, deviceId:",self.id)
end

function PolutionSensorPM10:updateValue(data,userID) 
  local pm10,pm10prev = data.pm10,data.pm10prev

  -- Send notifications when PM10 level reach breakpoints 
  -- PM10 breakpoint 0 - 50 GOOD (Minimal)
  if (tonumber(pm10) > 0 and tonumber(pm10) <= 50) then
    pm10Text = "GOOD"
    if (pm10prev > 50) then
      fibaro.alert("push", {userID}, "PM10 "..pm10 .." µg/m³" .." level GOOD (Minimal)")
      self:debug("PM10 level GOOD (Minimal)",pm10 .." µg/m³")
    end
  end
  -- PM10 breakpoint 51 - 100 SATISFACTORY (Minor breathing discomfort to sensitive people)
  if (tonumber(pm10) >= 51 and tonumber(pm10) <= 100) then
    pm10Text = "SATISFACTORY"
    if (pm10prev < 51 or pm10prev > 100) then
      fibaro.alert("push", {userID}, "PM10 "..pm10 .." µg/m³" .." level SATISFACTORY (Minor breathing discomfort to sensitive people)")
      self:debug("PM10 level SATISFACTORY (Minor breathing discomfort to sensitive people)",pm10 .." µg/m³")
    end
  end
  -- PM10 breakpoint 101 - 250 MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children
  if (tonumber(pm10) >= 101 and tonumber(pm10) <= 250) then
    pm10Text = "MODERATELY POLLUTED"
    if (pm10prev < 101 or pm10prev > 250) then
      fibaro.alert("push", {userID}, "PM10 "..pm10 .." µg/m³" .." level MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children")
      self:debug("PM10 level MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children",pm10 .." µg/m³")
    end
  end
  -- PM10 breakpoint 251 - 350 POOR (Breathing discomfort to all)
  if (tonumber(pm10) >= 251 and tonumber(pm10) <= 350) then
    pm10Text = "POOR"
    if (pm10prev < 251 or pm10prev > 350) then
      fibaro.alert("push", {userID}, "PM10 "..pm10 .." µg/m³" .." level POOR (Breathing discomfort to all)")
      self:debug("PM10 level POOR (Breathing discomfort to all)",pm10 .." µg/m³")
    end
  end
  -- PM10 breakpoint 351 - 430 VERY POOR (Respiratory illness on prolonged exposure)
  if (tonumber(pm10) >= 351 and tonumber(pm10) <= 439) then
    pm10Text = "VERY POOR"
    if (pm10prev < 351 or pm10prev > 430) then
      fibaro.alert("push", {userID}, "PM10 "..pm10 .." µg/m³" .." level VERY POOR (Respiratory illness on prolonged exposure)")
      self:debug("PM10 level VERY POOR (Respiratory illness on prolonged exposure)",pm10 .." µg/m³")
    end
  end
  -- PM10 breakpoint 430+ SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)
  if (tonumber(pm10) >= 439 ) then
    pm10Text = "SEVERE"
    if  (pm10prev < 430) then
      fibaro.alert("push", {userID}, "PM10 "..pm10 .." µg/m³" .." level SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)")
      self:debug("PM10 level SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)",pm10 .." µg/m³")
    end
  end

  if tonumber(pm10) > tonumber(pm10prev) then
    pm10Trend = " ↑"
  elseif tonumber(pm10) < tonumber(pm10prev) then
    pm10Trend = " ↓"
  else
    pm10Trend = " ="
  end

  -- Update properties for PM10 sensor
  self:updateProperty("value",tonumber(pm10)) 
  self:updateProperty("unit", "㎍/㎥")
  self:updateProperty("log", pm10Text ..pm10Trend)
end


-- QuickApp functions


local function getChildVariable(child,varName)
  for _,v in ipairs(child.properties.quickAppVariables or {}) do
    if v.name==varName then return v.value end
  end
  return ""
end


function QuickApp:logging(level,text) -- Logging function for debug
  if tonumber(debugLevel) >= tonumber(level) then 
      self:debug(text)
  end
end


function QuickApp:setPressuretext(text) -- Setup for airpressuretext
  press = tonumber(text)
  if press < 974 then 
    return "Thunderstorms"
  elseif press < 990 then
    return "Stormy"
  elseif press < 1002 then
    return "Rain"
  elseif press < 1010 then
    return "Cloudy"
  elseif press < 1022 then
    return "Unstable"
  elseif press < 1035 then
    return "Stable"
  else
    return "Very dry"
  end
end


function QuickApp:button1Event()
  self:updateView("button1", "text", "Please wait...")
  self:getData()
  fibaro.setTimeout(5000, function() -- Pause for [timeout] seconds (default 5 seconds)
    self:updateView("button1", "text", "Refresh")
  end)
end


-- Calculate Absolute Humidity (based on Temperature, Relative Humidity and Airpressure)
function QuickApp:getHumidityAbs(hum,temp,press) -- Source from muhmuh at Fibaro forum
  local EXP = 2.71828182845904523536028747135266249775724709369995
  local humidityAbs = 0.622 * hum/100 * (1.01325 * 10^(5.426651 - 2005.1 / (temp + 273.15) + 0.00013869 * ((temp + 273.15) * (temp + 273.15) - 293700) / (temp + 273.15) * (10^(0.000000000011965 * ((temp + 273.15) * (temp + 273.15) - 293700) * ((temp + 273.15) * (temp + 273.15) - 293700)) - 1) - 0.0044 * 10^((-0.0057148 * (374.11 - temp)^1.25))) + (((temp + 273.15) / 647.3) - 0.422) * (0.577 - ((temp + 273.15) / 647.3)) * EXP^(0.000000000011965 * ((temp + 273.15) * (temp + 273.15) - 293700) * ((temp + 273.15) * (temp + 273.15) - 293700)) * 0.00980665) / (press/1000 - hum/100 * (1.01325 * 10^(5.426651 - 2005.1 / (temp + 273.15) + 0.00013869 * ((temp + 273.15) * (temp + 273.15) - 293700) / (temp + 273.15) * (10^(0.000000000011965 * ((temp + 273.15) * (temp + 273.15) - 293700) * ((temp + 273.15) * (temp + 273.15) - 293700)) - 1) - 0.0044 * 10^((-0.0057148 * (374.11 - temp)^1.25))) + (((temp + 273.15) / 647.3) - 0.422) * (0.577 - ((temp + 273.15) / 647.3)) * EXP^(0.000000000011965 * ((temp + 273.15) * (temp + 273.15) - 293700) * ((temp + 273.15) * (temp + 273.15) - 293700)) * 0.00980665)) * press/1000 * 100000000 / ((temp + 273.15) * 287.1)
  self:logging(3,"Absolute humidty: " ..string.format("%.2f",humidityAbs))
  return string.format("%.2f",humidityAbs)
end


function QuickApp:updateProperties() --Update properties
  self:logging(3,"updateProperties")
  self:updateProperty("log", newtimestamp .."\n" .."Sensor ID: " ..sensorID)
end


function QuickApp:updateLabels() -- Update labels
  self:logging(3,"updateLabels")
  local labelText = "PM2.5: " ..data.pm25 .." µg/m³" .."\n"
  labelText = labelText .."PM10:  " ..data.pm10 .." µg/m³" .."\n"
  labelText = labelText .."Temperature: " ..data.temperature .." °C" .."\n"
  labelText = labelText .."Humidity: " ..data.humidity .." %" .."\n"
  labelText = labelText .."Absolute Humidity: " ..data.humidityabsolute .." g/m³" .."\n" 
  labelText = labelText .."Airpressure: " ..data.airpressure .." hPa (" ..data.airpressuretext ..")" .."\n\n" 
  --labelText = labelText .."Airpressure: " ..data.airpressure .." hPa" .."\n\n" 
  labelText = labelText .."Sensor ID:  " ..sensorID1 .." / " ..sensorID2 .." (" ..data.country .." " ..data.latitude .." / " ..data.longitude ..")" .."\n\n"
  labelText = labelText .."Measurement: " ..newtimestamp
  self:logging(2,"labelText: " ..labelText)
  self:updateView("label1", "text", labelText) 
end


function QuickApp:getValues() -- Get the values
  self:logging(3,"getValues")
  local n = ""
  self:logging(3,"Sensor type: " ..jsonTable[1].sensor.sensor_type.name) 
  if jsonTable[1].sensor.sensor_type.name == "SDS011" or jsonTable[1].sensor.sensor_type.name == "DHT22" then
    n = 2
  elseif jsonTable[1].sensor.sensor_type.name == "BME280" then
    n = 3
  else
    self:warning("Unknown type sensor")
    n = 2
  end
  for i=1,n do
    if jsonTable[1].sensordatavalues[i].value_type == "P1" then
      data.pm10 = jsonTable[1].sensordatavalues[i].value
    elseif jsonTable[1].sensordatavalues[i].value_type == "P2" then
      data.pm25 = jsonTable[1].sensordatavalues[i].value
    elseif jsonTable[1].sensordatavalues[i].value_type == "temperature" then
      data.temperature = jsonTable[1].sensordatavalues[i].value
    elseif jsonTable[1].sensordatavalues[i].value_type == "pressure" then
      data.airpressure = string.format("%.0f",tonumber(jsonTable[1].sensordatavalues[i].value)/100)
    elseif jsonTable[1].sensordatavalues[i].value_type == "humidity" then
      data.humidity = string.format("%.0f",tonumber(jsonTable[1].sensordatavalues[i].value))
    else
      self:warning("Unknown measurement value")
    end
  end
  if data.pm10 == "" or data.pm10 == nil then
    data.pm10 = "0" -- Temporarily value
  end
  if data.pm25 == "" or data.pm25 == nil then
    data.pm25 = "0" -- Temporarily value
  end
  if data.temperature == "" or data.temperature == nil then
    data.temperature = "21" -- Temporarily value
  end
  if data.humidity == "" or data.humidity == nil then
    data.humidity = "50" -- Temporarily value
  end
  if data.airpressure == "" or data.airpressure == nil then
    data.airpressure = "1013" -- Temporarily value
  end

  self:logging(3,"Values: PM10: " ..data.pm10 .." PM25: " ..data.pm25 .." Temp: " ..data.temperature .." Hum: " ..data.humidity .." Press: " ..data.airpressure)

  data.timestamp = jsonTable[1].timestamp 
  data.country = jsonTable[1].location.country
  data.latitude = jsonTable[1].location.latitude
  data.longitude = jsonTable[1].location.longitude
  data.humidityabsolute = self:getHumidityAbs(data.humidity,data.temperature,data.airpressure) -- Calculate Absolute Humidity
  data.airpressuretext = self:setPressuretext(data.airpressure) -- Setup Airpressure Text
  self:logging(3,"airpressuretext: " ..data.airpressuretext)

  -- Check timezone and daylight saving time
  local timezone = os.difftime(os.time(), os.time(os.date("!*t",os.time())))/3600
  if os.date("*t").isdst then -- Check daylight saving time 
    timezone = timezone + 1
  end
  self:logging(3,"Timezone + dst: " ..timezone)

  -- Convert time of measurement to local timezone
  local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
  local runyear, runmonth, runday, runhour, runminute, runseconds = data.timestamp:match(pattern)
  local convertedTimestamp = os.time({year = runyear, month = runmonth, day = runday, hour = runhour, min = runminute, sec = runseconds})
  --local newtimestamp = os.date("%d-%m-%Y %X", convertedTimestamp +(timezone*3600)) 
  newtimestamp = os.date("%d-%m-%Y %X", convertedTimestamp +(timezone*3600))
  self:logging(3,"newtimestamp: " ..newtimestamp)
end


function QuickApp:getData()
  self:logging(3,"Start getData")
  self:logging(2,"URL: " ..address ..sensorID .."/")
  http:request(address ..sensorID .."/", {
    options={headers = {Accept = "application/json"},method = 'GET'},        
      success = function(response)
        self:logging(3,"response status: " ..response.status)
        self:logging(3,"headers: " ..response.headers["Content-Type"])
        self:logging(2,"Response data: " ..response.data)

        if response.data == nil or response.data == "" or response.data == "[]" then -- Check for empty result
          self:warning("Temporarily no data from Sensor Community")
          self:logging(3,"SetTimeout " ..interval .." seconds")
          fibaro.setTimeout(interval*1000, function() 
            self:getdata()
          end)
        end

        jsonTable = json.decode(response.data) -- JSON decode from api to lua-table

        self:getValues()
        self:updateLabels()
        self:updateProperties()

        data.pm25prev=pm25prev
        data.pm10prev=pm10prev

        for id,child in pairs(self.childDevices) do 
          child:updateValue(data,userID) 
        end

        pm25prev = tonumber(data.pm25)
        pm10prev = tonumber(data.pm10)
        
        self:logging(2,"sensorID former: " ..sensorID)
        if sensorID == sensorID1 then -- Change the sensorID form first to second and back
          sensorID = sensorID2
        else
          sensorID = sensorID1
        end
        self:logging(2,"sensorID next: " ..sensorID)
      
      end,
      error = function(error)
        self:error('error: ' ..json.encode(error))
        self:updateProperty("log", "error: " ..json.encode(error))
      end
    }) 

  self:logging(3,"SetTimeout " ..interval .." seconds")
  fibaro.setTimeout((interval/2)*1000, function() 
     self:getData()
  end)
end


function QuickApp:getQuickAppVariables() -- Get all variables 
  address = "http://data.sensor.community/airrohr/v1/sensor/"
  sensorID = ""
  sensorID1 = self:getVariable("sensorID1")
  sensorID2 = self:getVariable("sensorID2")
  interval = tonumber(self:getVariable("interval")) 
  httpTimeout = tonumber(self:getVariable("httpTimeout")) 
  userID = tonumber(self:getVariable("userID")) 
  debugLevel = tonumber(self:getVariable("debugLevel"))
  local icon = tonumber(self:getVariable("icon")) 

  if sensorID1 =="" or sensorID1 == nil then
    sensorID1 = "13463" -- Default sensorID is 13463 (just random sensor)
    self:setVariable("sensorID1",sensorID1)
    self:trace("Added QuickApp variable sensorID1")
  end
  if sensorID2 =="" or sensorID2 == nil then
    sensorID2 = "13464" -- Default sensorID is 13463 (just random sensor)
    self:setVariable("sensorID2",sensorID2)
    self:trace("Added QuickApp variable sensorID2")
  end
  if interval == "" or interval == nil then
    interval = "146" -- Default interval is 73 because values needs 2 cyclus, normally the sensor renews its readings every 145 seconds 
    self:setVariable("interval",interval)
    self:trace("Added QuickApp variable interval")
    interval = tonumber(interval)
  end  
  if httpTimeout == "" or httpTimeout == nil then
    httpTimeout = "60" -- Default timeout is 120 (higher than normal to prevent errors)
    self:setVariable("httpTimeout",httpTimeout)
    self:trace("Added QuickApp variable httpTimeout")
    httpTimeout = tonumber(httpTimeout)
  end
  if userID == "" or userID == nil then 
    userID = "0" -- Default userID
    self:setVariable("userID",userID)
    self:trace("Added QuickApp variable userID")
    userID = tonumber(userID)
  end
  if debugLevel == "" or debugLevel == nil then
    debugLevel = "1" -- Default value for debugLevel response in seconds
    self:setVariable("debugLevel",debugLevel)
    self:trace("Added QuickApp variable debugLevel")
    debugLevel = tonumber(debugLevel)
  end
  if icon == "" or icon == nil then 
    icon = "0" -- Default icon
    self:setVariable("icon",icon)
    self:trace("Added QuickApp variable icon")
    icon = tonumber(icon)
  end
  if icon ~= 0 then 
    self:updateProperty("deviceIcon", icon) -- set user defined icon 
  end
  sensorID = sensorID1 -- Set the sensorID to the first SensorID
end


function QuickApp:setupChildDevices()
  local cdevs = api.get("/devices?parentId="..self.id) or {} -- Pick up all my children 
  function self:initChildDevices() end -- Null function, else Fibaro calls it after onInit()...

  if #cdevs==0 then -- No children, create children
    local initChildData = { 
      {className="PolutionSensorTemp", name="Temperature", type="com.fibaro.temperatureSensor", value=0, unit="°C"},
      {className="PolutionSensorHumid", name="Humidity", type="com.fibaro.humiditySensor", value=0, unit="%"},
      {className="PolutionSensorHumidAbs", name="Absolute Humidity", type="com.fibaro.multilevelSensor", value=0, unit="g/m³"},
      {className="PolutionSensorPressure", name="Airpressure", type="com.fibaro.multilevelSensor", value=0, unit="hPa"},
      {className="PolutionSensorPM25", name="PM2.5", type="com.fibaro.multilevelSensor", value=0, unit="µg/m³"},
      {className="PolutionSensorPM10", name="PM10", type="com.fibaro.multilevelSensor", value=0, unit="µg/m³"},
    }
    for _,c in ipairs(initChildData) do
      local child = self:createChildDevice(
        {name = c.name,
          type=c.type,
          value=c.value,
          unit=c.unit,
          initialInterfaces = {}, -- Add interfaces if you need
        },
        _G[c.className] -- Fetch class constructor from class name
      )
      child:setVariable("className",c.className)  -- Save class name so we know when we load it next time
    end   
  else 
    for _,child in ipairs(cdevs) do
      local className = getChildVariable(child,"className") -- Fetch child class name
      local childObject = _G[className](child) -- Create child object from the constructor name
      self.childDevices[child.id]=childObject
      childObject.parent = self -- Setup parent link to device controller 
    end
  end
end


function QuickApp:onInit()
  __TAG = fibaro.getName(plugin.mainDeviceId) .." ID:" ..plugin.mainDeviceId
  self:debug("onInit") 
  self:setupChildDevices()
  self:getQuickAppVariables() 
  http = net.HTTPClient({timeout=httpTimeout*1000})
  pm25prev,pm10prev = 0,0
  pm10Text,pm25Text,pm25Trend,pm10Trend = "","","",""
  data = {}
  self:getData()
end

--EOF
