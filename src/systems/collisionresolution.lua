--- System that calls collision resolution functions in entities.
-- Requires entities to have the "aabb" component and an "onCollision" function.

local tiny = require "lib.tiny"

local CollisionResolutionSystem = tiny.processingSystem()
CollisionResolutionSystem.filter = tiny.requireAll("aabb")

--- Calls collision resolution functions and clears the collision list
-- @param e Entity
function CollisionResolutionSystem:process(e)
    if e.onCollision ~= nil then
        for _,collision in ipairs(e.aabb.collisions) do
            e:onCollision(collision)
        end
    end
    e.aabb.collisions = nil
end

return CollisionResolutionSystem
