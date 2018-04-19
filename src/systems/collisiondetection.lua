--- System that handles collision detection.
-- Requires entities to have "position" and "aabb" components.

local class = require "lib.middleclass"
local tiny = require "lib.tiny"
local Collision = require "src.util.collision"

local CollisionDetectionSystem = tiny.processingSystem(class("CollisionDetectionSystem"))
CollisionDetectionSystem.filter = tiny.requireAll("position", "aabb")

--- Detects collisions using bump
-- @param e Entity
function CollisionDetectionSystem:process(e)
    local filter = e.aabb.filter ~= nil and e.aabb.filter or Collision.filter.default
    local actualX, actualY, cols = e.aabb.world:move(e, e.position.x, e.position.y, filter)
    e.position.x = actualX
    e.position.y = actualY
    e.aabb.collisions = cols
end

function CollisionDetectionSystem:onRemove(e)
    e.aabb.world:remove(e)
end

return CollisionDetectionSystem
