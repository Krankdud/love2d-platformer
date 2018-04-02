local class = require "lib.middleclass"
local tiny = require "lib.tiny"

local IntegrateAxisSystem = tiny.processingSystem(class("IntegrateAxisSystem"))

--- System that "integrates" over an axis.
-- Really just adds the components together. The name comes from how displacement or velocity
-- is calculated in physics (e.g. you get displacement by integrating velocity over a set time period)
-- @param axis The axis to process ("x" or "y")
-- @param integral Integral component
-- @param differential Differential component
function IntegrateAxisSystem:initialize(axis, integral, differential)
    self.axis = axis
    self.integral = integral
    self.differential = differential
end

--- Filters entities that contain the integral and differential components
-- @param e Entity
-- @return True if the entity should be processed by this system
function IntegrateAxisSystem:filter(e)
    return e[self.integral] ~= nil and e[self.differential] ~= nil
end

--- Adds the differential component to the integral component on an axis.
-- @param e Entity
function IntegrateAxisSystem:process(e)
    local eIntegral = e[self.integral]
    local eDifferential = e[self.differential]
    eIntegral[self.axis] = eIntegral[self.axis] + eDifferential[self.axis]
end

return IntegrateAxisSystem

