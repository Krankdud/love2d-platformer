--- System that calls the draw function of entities.

local tiny = require "lib.tiny"

local DrawSystem = tiny.processingSystem()
DrawSystem.isDrawSystem = true
DrawSystem.filter = tiny.requireAll("draw")

--- Calls the draw function on an entity
-- @param e Entity
function DrawSystem:process(e)
    e:draw()
end

return DrawSystem
