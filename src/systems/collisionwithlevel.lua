--- System that resolves collision with the level.
-- Requires entities to have "aabb", "collideWithLevel", and "velocity" components.

local class = require "lib.middleclass"
local tiny = require "lib.tiny"

local CollisionWithLevelSystem = tiny.processingSystem(class("CollisionWithLevelSystem"))
CollisionWithLevelSystem.filter = tiny.requireAll("velocity", "collideWithLevel", "aabb")

--- Resolves collision between entity and level by setting the velocity to 0.
-- @param e Entity
function CollisionWithLevelSystem:process(e)
    e.aabb.onGround = false
    e.aabb.onCeiling = false
    e.aabb.onWall = false
    e.aabb.onLevel = false

    for _,collision in ipairs(e.aabb.collisions) do
        if collision.other.properties ~= nil then
            if collision.normal.x ~= 0 then
                e.aabb.onWall = true
                e.aabb.onLevel = true

                e.velocity.x = 0
            end
            if collision.normal.y ~= 0 then
                e.aabb.onGround = collision.normal.y < 0
                e.aabb.onCeiling = collision.normal.y > 0
                e.aabb.onLevel = true

                e.velocity.y = 0
            end
        end
    end
end

return CollisionWithLevelSystem
