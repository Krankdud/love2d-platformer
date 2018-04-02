local tiny = require "lib.tiny"

local CollisionDetectionSystem = tiny.processingSystem()
CollisionDetectionSystem.filter = tiny.requireAll("position", "aabb")

--- Detects collisions using bump
-- @param e Entity
function CollisionDetectionSystem:process(e)
    local actualX, actualY, cols = e.aabb.world:move(e, e.position.x, e.position.y, e.aabb.filter)
    e.position.x = actualX
    e.position.y = actualY
    e.aabb.collisions = cols
end

return CollisionDetectionSystem
