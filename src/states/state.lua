local class = require "lib.middleclass"
local tiny = require "lib.tiny"

local function filterDrawSystem(_, s)
	-- if nil return false instead of nil
	return not not s.isDrawSystem
end

local function filterUpdateSystem(_, s)
	return not s.isDrawSystem
end

local State = class("State")
function State:initialize()
	self.world = tiny.world()
end

function State:update(dt)
	self.world:update(dt, filterUpdateSystem)
end

function State:draw()
	self.world:update(0, filterDrawSystem)
end

return State
