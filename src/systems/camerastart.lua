--- System that starts camera usage.
-- Used during the rendering stage to start translating entities.

local tiny = require "lib.tiny"
local Camera = require "src.camera"

local CameraStartSystem = tiny.system()
CameraStartSystem.isDrawSystem = true

--- Starts the camera.
function CameraStartSystem:update()
    Camera:start()
end

return CameraStartSystem
