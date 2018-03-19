local class = require "lib.middleclass"
local lume = require "lib.lume"
local tiny = require "lib.tiny"

local math = math

local PositionSystem = tiny.processingSystem(class("PositionSystem"))
PositionSystem.filter = tiny.requireAll("position")

--- System that processes entities with a position component. 
-- It only processes the position on one of the axes, so two systems are required to process both axes.
-- @param axis The axis to process ("x" or "y")
function PositionSystem:initialize(axis)
	self.axis = axis
end

--- Converts the value on an axis to an integer value, and tracks the fractional value.
-- If the fractional value becomes greater than 1, it is added to the x or y value.
-- The entity's prevX and prevY is also set to the x and y after processing the value,
-- so it can be accessed after modifying the x or y value on the next iteration.
-- @param e Entity
-- @param dt Delta time (not used)
function PositionSystem:process(e, dt)
	if self.axis == "x" then
		self:_processAxis(e.position, "x", "prevX", "subpixelX")
	else
		self:_processAxis(e.position, "y", "prevY", "subpixelY")
	end
end

-- Private function to handle updating an axis
function PositionSystem:_processAxis(position, axis, prevAxis, subpixelAxis)
	local x, subpixelX = math.modf(position[axis])
	position[axis] = x
	position[subpixelAxis] = position[subpixelAxis] + subpixelX
	if math.abs(position[subpixelAxis]) >= 1 then
		position[axis] = position[axis] + lume.sign(position[subpixelAxis])
		position[subpixelAxis] = position[subpixelAxis] - lume.sign(position[subpixelAxis])
	end

	position[prevAxis] = position[axis]
end

return PositionSystem
