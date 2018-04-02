--- System that resolves collision with the level.
-- Requires entities to have "aabb", "collideWithLevel", and "velocity" components.

local tiny = require "lib.tiny"

local CollisionWithLevelSystem = tiny.processingSystem()
CollisionWithLevelSystem.filter = tiny.requireAll("velocity", "collideWithLevel", "aabb")

--- Resolves collision between entity and level by setting the velocity to 0.
-- @param e Entity
function CollisionWithLevelSystem:process(e)
    for _,collision in ipairs(e.aabb.collisions) do
        if collision.other.properties ~= nil then
            if collision.normal.x ~= 0 then
                e.velocity.x = 0
            end
            if collision.normal.y ~= 0 then
                e.aabb.onGround = collision.normal.y < 0

                e.velocity.y = 0
            end
        end
    end
end

return CollisionWithLevelSystem
