--- System that finishes camera usage.
-- Used during the rendering stage to stop translating entities.

local tiny = require "lib.tiny"
local Camera = require "src.camera"

local CameraFinishSystem = tiny.system()
CameraFinishSystem.isDrawSystem = true

--- Finish using the camera.
function CameraFinishSystem:update()
    Camera:finish()
end

return CameraFinishSystem
