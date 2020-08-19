-- QuickApp SENSOR.COMMUNITY 

-- This QuickApp reads the PM2.5, PM10 values directly from a sensor somewhere in this world
-- That sensor doesn't have to be your sensor, any sensor can be used, just find one in your neighborhood. 
-- For locating a sensor(ID) in your neighborhood see: https://sensor.community/en/
-- The PM2.5 and PM10 readings are stored in the value of two (child) devices, so you can read the value from your own scenes
-- This QuickApp will send notifications when PM2.5 or PM10 readings reach a breakpoint


-- Version 0.5
-- ...

-- Version 0.4:
-- Added child devices for PM2.5 and PM10
-- Added time of measurement, adjusted to your timezone
-- Added Timeout QuickApp variable with high http timeout value to prevent errors
-- Error message instead off debug message in case of an error
-- Changed method of adding QuickApp variables, so they can be edited


-- See also https://luftdaten.info
-- See also for CVS files: https://archive.luftdaten.info
-- See also https://github.com/opendata-stuttgart/
-- API documentation: https://github.com/opendata-stuttgart/meta/wiki/EN-APIs

-- Variables (mandatory): 
-- Address = http://data.sensor.community/airrohr/v1/sensor/[SensorID]/
-- SensorID = [number] (your own SensorID or from someone else, 13463 is an example)
-- Interval = [number] (in seconds)
-- Timeout = [number] (in seconds for http timeout)
-- UserID = [number] userID to notify of PM2.5 / PM10 breakpoints

-- PM2.5 breakpoints
-- 0 - 30    GOOD (Minimal)
-- 31 - 60   SATISFACTORY (Minor breathing discomfort to sensitive people)
-- 61 - 90   MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children
-- 91 - 120  POOR (Breathing discomfort to all)
-- 121 - 250 VERY POOR (Respiratory illness on prolonged exposure)
-- 250+      SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)

-- PM10 breakpoints
-- 0 - 50    GOOD (Minimal)
-- 51 - 100  SATISFACTORY (Minor breathing discomport to sensitive people)
-- 101 - 250 MODERATELY POLLUTED Breathing discomfoort to asthma patients, elderly and children
-- 251 - 350 POOR (Breathing discomfort to all)
-- 351 - 430 VERY POOR (Respiratory illness on prolonged exposure)
-- 430+      SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)

-- No editing of this code is needed 


class 'PolutionSensorPM25'(QuickAppChild)
function PolutionSensorPM25:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("PM2.5 sensor initiated, deviceId:",self.id)
end

function PolutionSensorPM25:updateValue(data,UserID)  

  local pm25,pm25prev = data.pm25,data.pm25prev

  -- Send notifications when PM2.5 level reach breakpoints 
  -- PM2.5 breakpoint 0 - 30 GOOD (Minimal)
  if (tonumber(pm25) > 0 and tonumber(pm25) <= 30) then
    pm25Text = "GOOD"
    if (pm25prev > 30) then
      fibaro.alert("push", {UserID}, "PM2.5 "..pm25 .." µg/m³" .." level GOOD (Minimal)")
      self:debug("PM2.5 level GOOD (Minimal)",pm25 .." µg/m³")
    end
  end
  -- PM2.5 breakpoint 31 - 60 SATISFACTORY (Minor breathing discomfort to sensitive people)
  if (tonumber(pm25) >= 31 and tonumber(pm25) <= 60) then
    pm25Text = "SATISFACTORY"
    if (pm25prev < 31 or pm25prev > 60) then
      fibaro.alert("push", {UserID}, "PM2.5 "..pm25 .." µg/m³" .." level SATISFACTORY (Minor breathing discomfort to sensitive people)")
      self:debug("PM2.5 level SATISFACTORY (Minor breathing discomfort to sensitive people)",pm25 .." µg/m³")
    end
  end
  -- PM2.5 breakpoint 61 - 90 MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children
  if (tonumber(pm25) >= 61 and tonumber(pm25) <= 90) then
    pm25Text = "MODERATELY POLLUTED"
    if (pm25prev < 61 or pm25prev > 90) then
      fibaro.alert("push", {UserID}, "PM2.5 "..pm25 .." µg/m³" .." level MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children")
      self:debug("PM2.5 level MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children",pm25 .." µg/m³")
    end 
  end
  -- PM2.5 breakpoint 91 - 120 POOR (Breathing discomfort to all)
  if (tonumber(pm25) >= 91 and tonumber(pm25) <= 120) then
    pm25Text = "POOR"
    if (pm25prev < 91 or pm25prev > 120) then
      fibaro.alert("push", {UserID}, "PM2.5 "..pm25 .." µg/m³" .." level POOR (Breathing discomfort to all)")
      self:debug("PM2.5 level POOR (Breathing discomfort to all)",pm25 .." µg/m³")
    end
  end
  -- PM2.5 breakpoint 120 - 250 VERY POOR (Respiratory illness on prolonged exposure)
  if (tonumber(pm25) >= 120 and tonumber(pm25) <= 250) then
    pm25Text = "VERY POOR"
    if (pm25prev < 121 or pm25prev > 250) then
      fibaro.alert("push", {UserID}, "PM2.5 "..pm25 .." µg/m³" .." level VERY POOR (Respiratory illness on prolonged exposure)")
      self:debug("PM2.5 level VERY POOR (Respiratory illness on prolonged exposure)",pm25 .." µg/m³")
    end
  end
  -- PM2.5 breakpoint 250+ SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)
  if (tonumber(pm25) >= 250 ) then
    pm25Text = "SEVERE"
    if (pm25prev < 250) then
      fibaro.alert("push", {UserID}, "PM2.5 "..pm25 .." µg/m³" .." level SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)")
      self:debug("PM2.5 level EVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)",pm25 .." µg/m³")
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

function PolutionSensorPM10:updateValue(data,UserID) 
  local pm10,pm10prev = data.pm10,data.pm10prev

  -- Send notifications when PM10 level reach breakpoints 
  -- PM10 breakpoint 0 - 50 GOOD (Minimal)
  if (tonumber(pm10) > 0 and tonumber(pm10) <= 50) then
    pm10Text = "GOOD"
    if (pm10prev > 50) then
      fibaro.alert("push", {UserID}, "PM10 "..pm10 .." µg/m³" .." level GOOD (Minimal)")
      self:debug("PM10 level GOOD (Minimal)",pm10 .." µg/m³")
    end
  end
  -- PM10 breakpoint 51 - 100 SATISFACTORY (Minor breathing discomfort to sensitive people)
  if (tonumber(pm10) >= 51 and tonumber(pm10) <= 100) then
    pm10Text = "SATISFACTORY"
    if (pm10prev < 51 or pm10prev > 100) then
      fibaro.alert("push", {UserID}, "PM10 "..pm10 .." µg/m³" .." level SATISFACTORY (Minor breathing discomfort to sensitive people)")
      self:debug("PM10 level SATISFACTORY (Minor breathing discomfort to sensitive people)",pm10 .." µg/m³")
    end
  end
  -- PM10 breakpoint 101 - 250 MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children
  if (tonumber(pm10) >= 101 and tonumber(pm10) <= 250) then
    pm10Text = "MODERATELY POLLUTED"
    if (pm10prev < 101 or pm10prev > 250) then
      fibaro.alert("push", {UserID}, "PM10 "..pm10 .." µg/m³" .." level MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children")
      self:debug("PPM10 level MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children",pm10 .." µg/m³")
    end
  end
  -- PM10 breakpoint 251 - 350 POOR (Breathing discomfort to all)
  if (tonumber(pm10) >= 251 and tonumber(pm10) <= 350) then
    pm10Text = "POOR"
    if (pm10prev < 251 or pm10prev > 350) then
      fibaro.alert("push", {UserID}, "PM10 "..pm10 .." µg/m³" .." level POOR (Breathing discomfort to all)")
      self:debug("PM10 level POOR (Breathing discomfort to all)",pm10 .." µg/m³")
    end
  end
  -- PM10 breakpoint 351 - 430 VERY POOR (Respiratory illness on prolonged exposure)
  if (tonumber(pm10) >= 351 and tonumber(pm10) <= 439) then
    pm10Text = "VERY POOR"
    if (pm10prev < 351 or pm10prev > 430) then
      fibaro.alert("push", {UserID}, "PM10 "..pm10 .." µg/m³" .." level VERY POOR (Respiratory illness on prolonged exposure)")
      self:debug("PM10 level VERY POOR (Respiratory illness on prolonged exposure)",pm10 .." µg/m³")
    end
  end
  -- PM10 breakpoint 430+ SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)
  if (tonumber(pm10) >= 439 ) then
    pm10Text = "SEVERE"
    if  (pm10prev < 430) then
      fibaro.alert("push", {UserID}, "PM10 "..pm10 .." µg/m³" .." level SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)")
      self:debug("PM10 level EVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)",pm10 .." µg/m³")
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

local function getChildVariable(child,varName)
  for _,v in ipairs(child.properties.quickAppVariables or {}) do
    if v.name==varName then return v.value end
  end
  return ""
end

function QuickApp:onInit()
  __TAG = "SENSOR_COMMUNITY_"..self.id
  self:debug("onInit") 

  local cdevs = api.get("/devices?parentId="..self.id) or {} -- Pick up all my children 
  function self:initChildDevices() end -- Null function, else Fibaro calls it after onInit()...

  if #cdevs==0 then -- No children, create children
    local initChildData = { -- Just my own local table to be able to make a loop - you may get your initial data elsewhere...
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
  else  -- Ok, we already have children, instantiate them with the correct class
    -- This is more or less what self:initChildDevices does but this can handle mapping different classes to the same type...
    for _,child in ipairs(cdevs) do
      local className = getChildVariable(child,"className") -- Fetch child class name
      local childObject = _G[className](child) -- Create child object from the constructor name
      self.childDevices[child.id]=childObject
      childObject.parent = self -- Setup parent link to device controller 
    end
  end

  -- Get all variables 
  local Address = self:getVariable("Address")
  local SensorID = self:getVariable("SensorID")
  local Interval = tonumber(self:getVariable("Interval")) 
  local Timeout = tonumber(self:getVariable("Timeout")) 
  local UserID = tonumber(self:getVariable("UserID")) 

  -- Check existence of the mandatory variables, if not, create them with default values
  if Address == "" or Address == nil then
    Address = "http://data.sensor.community/airrohr/v1/sensor/" -- Default Address
    self:setVariable("Address",Address)
    self:trace("Added QuickApp variable Address")
  end
  if SensorID =="" or SensorID == nil then
    SensorID = "13463" -- Default SensorID is 13463 (just random sensor)
    self:setVariable("SensorID",SensorID)
    self:trace("Added QuickApp variable SensorID")
  end
  if Interval == "" or Interval == nil then
    Interval = "146" -- Default interval is 146, normally the sensor renews its readings every 145 seconds 
    self:setVariable("Interval",Interval)
    self:trace("Added QuickApp variable Interval")
    Interval = tonumber(Interval)
  end  
  if Timeout == "" or Timeout == nil then
    Timeout = "120" -- Default timeout is 120 (higher than normal to prevent errors)
    self:setVariable("Timeout",Timeout)
    self:trace("Added QuickApp variable Timeout")
    Timeout = tonumber(Timeout)
  end
  if UserID == "" or UserID == nil then 
    UserID = "2" -- Default userID
    self:setVariable("UserID",UserID)
    self:trace("Added QuickApp variable UserID")
    UserID = tonumber(UserID)
  end

  -- Start of reading the data from the sensor

  local http = net.HTTPClient({timeout=tonumber(Timeout)*1000}) -- High timeout value to prevent errors

  local pm25prev,pm10prev = 0,0
  local pm10Text,pm25Text,pm25Trend,pm10Trend = "","","",""

  local Address = Address .. SensorID .."/" 

  --self:debug("-------------- QUICKAPP SENSOR COMMUNITY -------------")

  local function collectData()
    http:request(Address, {
        options={
          headers = {
            Accept = "application/json"
          },
          method = 'GET'
        },        
        success = function(response)
          --self:debug("response status:", response.status) 
          --self:debug("headers:", response.headers["Content-Type"])
          local apiResult = response.data
          --self:debug("Api result: ",apiResult)

          local jsonTable = json.decode(apiResult) -- JSON decode from api to lua-table
          local data  = {}

          -- Get the values       
          data.pm10 = jsonTable[1].sensordatavalues[1].value
          data.pm25 = jsonTable[1].sensordatavalues[2].value
          data.timestamp = jsonTable[1].timestamp 
          
          -- Check timezone and daylight saving time
          local timezone = os.difftime(os.time(), os.time(os.date("!*t",os.time())))/3600
          if os.date("*t").isdst then -- Check daylight saving time 
            timezone = timezone + 1
          end
          --self:debug("Timezone + dst: ",timezone)

          -- Convert time of measurement to local timezone
          local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
          local runyear, runmonth, runday, runhour, runminute, runseconds = data.timestamp:match(pattern)
          local convertedTimestamp = os.time({year = runyear, month = runmonth, day = runday, hour = runhour, min = runminute, sec = runseconds})
          local newtimestamp = os.date("%d-%m-%Y %X", convertedTimestamp +(timezone*3600))
          --self:debug("newtimestamp:", newtimestamp)

          -- Update labels
          self:updateView("label1", "text", "PM2.5: " ..data.pm25 .." µg/m³")
          self:updateView("label2", "text", "PM10:  " ..data.pm10 .." µg/m³")
          self:updateView("label3", "text", "Sensor ID:  " ..SensorID)
          self:updateView("label4", "text", "Measurement:  " ..newtimestamp)

          --Update properties
          self:updateProperty("log", newtimestamp)

          data.pm25prev=pm25prev
          data.pm10prev=pm10prev

          for id,child in pairs(self.childDevices) do 
            child:updateValue(data,UserID) 
          end

          pm25prev = tonumber(data.pm25)
          pm10prev = tonumber(data.pm10)

          self:debug("Measurement:  " ..newtimestamp .." / PM2.5: "..data.pm25 .." µg/m³ / PM10: " ..data.pm10 .." µg/m³ / Sensor ID: " ..SensorID)
          
          --self:debug("--------------------- END --------------------")
        end,
        error = function(error)
          self:error('error: ' ..json.encode(error))
          self:updateProperty("log", "error: " ..json.encode(error))
        end
      }) 

    fibaro.setTimeout(Interval*1000, collectData) -- Check every [Interval] seconds for new data

  end

  collectData() -- start checking data

end


