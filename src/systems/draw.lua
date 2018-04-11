--- System that calls the draw function of entities.

local class = require "lib.middleclass"
local tiny = require "lib.tiny"

local DrawSystem = tiny.processingSystem(class("DrawSystem"))
DrawSystem.isDrawSystem = true
DrawSystem.filter = tiny.requireAll("draw")

--- Calls the draw function on an entity
-- @param e Entity
function DrawSystem:process(e)
    e:draw()
end

return DrawSystem
