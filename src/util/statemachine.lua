local class = require "lib.middleclass"

local StateMachine = class("StateMachine")
function StateMachine:initialize(object, default)
	self.object = object
	self.states = {}

	self.states["default"] = default or {}
	self.states["default"].update = self.states["default"].update or function() end
	self.states["default"].draw = self.states["default"].draw or function() end
	self.states["default"].enter = self.states["default"].enter or function() end

	self.currentId = "default" 
end

function StateMachine:addState(id, state)
	self.states[id] = state
end

function StateMachine:setState(id)
	self.currentId = id
end

function StateMachine:update(...)
	local nextId
	if self.currentId == nil or self.states[self.currentId].update == nil then
		nextId = self.states["default"].update(self.object, ...)
	else
		nextId = self.states[self.currentId].update(self.object, ...)
	end

	if nextId ~= nil then
		self.currentId = nextId
		if self.states[nextId].enter ~= nil then
			self.states[nextId].enter(self.object)
		end
	end
end

function StateMachine:draw(...)
	if self.currentId == nil or self.states[self.currentId].draw == nil then
		self.states["default"].draw(self.object, ...)
	else
		self.states[self.currentId].draw(self.object, ...)
	end
end

return StateMachine
