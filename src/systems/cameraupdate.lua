--- System that updates the camera.

local tiny = require "lib.tiny"
local Camera = require "src.camera"

local CameraUpdateSystem = tiny.system()

--- Updates the camera.
function CameraUpdateSystem:update()
    Camera:update()
end

return CameraUpdateSystem
