--- System that calls the drawOnTop function of entities.
-- DrawOnTop is for anything that is drawn over the screen and disregards
-- the camera, e.g. HUD, fade in / fade out effect, etc.

local class = require "lib.middleclass"
local tiny = require "lib.tiny"

local DrawOnTopSystem = tiny.processingSystem(class("DrawOnTopSystem"))
DrawOnTopSystem.isDrawSystem = true
DrawOnTopSystem.filter = tiny.requireAll("drawOnTop")

--- Calls the drawOnTop function on an entity
-- @param e Entity
function DrawOnTopSystem:process(e)
    e:drawOnTop()
end

return DrawOnTopSystem
