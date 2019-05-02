--[[----------------------------------------------------------------------------

  Application Name:
  Median3D

  Description:
  Applying Median filter on a 3D image.

  How to Run:
  Starting this sample is possible either by running the app (F5) or
  debugging (F7+F10). Setting breakpoint on the first row inside the 'main'
  function allows debugging step-by-step after 'Engine.OnStarted' event.
  Results can be seen in the viewer on the DevicePage.
  Select Reflectance in the View: box at the top of the GUI and zoom in on the
  data for best experience.

  More Information:
  Tutorial "Algorithms - Filtering and Arithmetic".

------------------------------------------------------------------------------]]
--Start of Global Scope---------------------------------------------------------

Script.serveEvent('Median3D.OnMessage1', 'OnMessage1', 'string')
Script.serveEvent('Median3D.OnMessage2', 'OnMessage2', 'string')

-- Create viewer for original and filtered 3D image
local viewer1 = View.create()
viewer1:setID('viewer1')
local viewer2 = View.create()
viewer2:setID('viewer2')

--End of Global Scope-----------------------------------------------------------

-- Start of Function and Event Scope--------------------------------------------

--@filteringImage(heightMap:Image, intensityMap:Image)
local function filteringImage(heightMap, intensityMap)
  -- MEDIAN: Applies median filter to the image to smooth and remove noise

  -- Visualize the input (original image)
  viewer1:clear()
  viewer1:addHeightmap({heightMap, intensityMap}, {}, {'Reflectance'})
  viewer1:present()

  Script.notifyEvent('OnMessage1', 'Original image')

  -- Filter on the heightMap
  local kernelsize = 5 -- Size of the kernel, must be positive and odd
  local medianImage = heightMap:median(kernelsize) -- Median filtering
  local medianIntensityMap = intensityMap:median(kernelsize) -- Median filtering

  -- Visualize the output (median image)
  viewer2:clear()
  viewer2:addHeightmap({medianImage, medianIntensityMap}, {}, {'Reflectance'})
  viewer2:present()

  Script.notifyEvent('OnMessage2', 'Median filter, kernel size: ' .. kernelsize)
end

local function main()
  -- Load a json-image
  local data = Object.load('resources/image_23.json')

  -- Extract heightmap, intensity map and sensor data
  local heightMap = data[1]
  local intensityMap = data[2]
  local sensorData = data[3] --luacheck: ignore

  -- Filter image
  filteringImage(heightMap, intensityMap)

  print('App finished')
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--End of Function and Event Scope-------------------------------------------------
