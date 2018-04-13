--- System that updates the camera.

local class = require "lib.middleclass"
local tiny = require "lib.tiny"
local Camera = require "src.camera"

local CameraUpdateSystem = tiny.system(class("CameraUpdateSystem"))

--- Updates the camera.
function CameraUpdateSystem:update()
    Camera:update()
end

return CameraUpdateSystem
