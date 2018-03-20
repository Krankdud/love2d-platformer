local class = require "lib.middleclass"

local State = require "src.states.state"
-- Systems
local DrawSystem          = require "src.systems.draw"
local IntegrateAxisSystem = require "src.systems.integrateaxis"
local LimitVelocitySystem = require "src.systems.limitvelocity"
local PositionSystem      = require "src.systems.position"
local UpdateSystem        = require "src.systems.update"

-- Entities
local Player = require "src.entities.player"

local LevelState = class("LevelState", State)
function LevelState:initialize()
	State.initialize(self,
		UpdateSystem,

		IntegrateAxisSystem:new("x", "velocity", "acceleration"),
		IntegrateAxisSystem:new("y", "velocity", "acceleration"),
		LimitVelocitySystem,

		IntegrateAxisSystem:new("x", "position", "velocity"),
		PositionSystem:new("x"),

		IntegrateAxisSystem:new("y", "position", "velocity"),
		PositionSystem:new("y"),
		DrawSystem
	)

	self.world:addEntity(Player:new(16, 100))
end

return LevelState
