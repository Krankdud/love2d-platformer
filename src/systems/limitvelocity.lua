--- System that limits velocity.
-- Requires entities to have a "velocity" component and either a "minVelocity" or a "maxVelocity" component.

local class = require "lib.middleclass"
local tiny = require "lib.tiny"

local math = math

local LimitVelocitySystem = tiny.processingSystem(class("LimitVelocitySystem"))
LimitVelocitySystem.filter = tiny.filter("velocity&(minVelocity|maxVelocity)")

--- Limits the velocity of entities.
-- @param e Entity
function LimitVelocitySystem:process(e)
    if e.minVelocity then
        e.velocity.x = math.max(e.velocity.x, e.minVelocity.x)
        e.velocity.y = math.max(e.velocity.y, e.minVelocity.y)
    end

    if e.maxVelocity then
        e.velocity.x = math.min(e.velocity.x, e.maxVelocity.x)
        e.velocity.y = math.min(e.velocity.y, e.maxVelocity.y)
    end
end

return LimitVelocitySystem
