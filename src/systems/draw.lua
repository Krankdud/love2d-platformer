--- System that calls the draw function of entities.
-- Sorts entities using the drawLayer property. Lower values are drawn
-- underneath higher values.

local class = require "lib.middleclass"
local tiny = require "lib.tiny"

local DrawSystem = tiny.sortedProcessingSystem(class("DrawSystem"))
DrawSystem.isDrawSystem = true
DrawSystem.filter = tiny.requireAll("draw")

--- Compares two entities and sorts them based on their drawLayer properties.
-- Entities with lower drawLayer values are drawn below other entities.
-- If an entity doesn't have a drawLayer property, try to draw them above
-- everything else. Comparing two entities that both do not have a drawLayer
-- property is undefined.
-- @param a Entity
-- @param b Entity
function DrawSystem:compare(a, b)
    -- Undefined behaviour
    if a.drawLayer == nil or b.drawLayer == nil then
        return false
    end

    return a.drawLayer < b.drawLayer
end

--- Calls the draw function on an entity
-- @param e Entity
function DrawSystem:process(e)
    e:draw()
end

return DrawSystem
