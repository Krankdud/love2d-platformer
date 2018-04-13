--- System that finishes camera usage.
-- Used during the rendering stage to stop translating entities.

local class = require "lib.middleclass"
local tiny = require "lib.tiny"
local Camera = require "src.camera"

local CameraFinishSystem = tiny.system(class("CameraFinishSystem"))
CameraFinishSystem.isDrawSystem = true

--- Finish using the camera.
function CameraFinishSystem:update()
    Camera:finish()
end

return CameraFinishSystem
