--- LevelState is the main gameplay state.

local class = require "lib.middleclass"
local Timer = require "lib.hump.timer"

local State = require "src.states.state"
-- Systems
local CollisionDetectionSystem  = require "src.systems.collisiondetection"
local CollisionResolutionSystem = require "src.systems.collisionresolution"
local CollisionWithLevelSystem  = require "src.systems.collisionwithlevel"
local DrawSystem                = require "src.systems.draw"
local IntegrateAxisSystem       = require "src.systems.integrateaxis"
local LimitVelocitySystem       = require "src.systems.limitvelocity"
local UpdateSystem              = require "src.systems.update"

local Level = require "src.level"

local LevelState = class("LevelState", State)
--- Initializes the state and loads a level
function LevelState:initialize()
    State.initialize(self,
        UpdateSystem,

        IntegrateAxisSystem:new("x", "velocity", "acceleration"),
        IntegrateAxisSystem:new("y", "velocity", "acceleration"),
        LimitVelocitySystem,

        IntegrateAxisSystem:new("x", "position", "velocity"),
        IntegrateAxisSystem:new("y", "position", "velocity"),

        CollisionDetectionSystem,
        CollisionWithLevelSystem,
        CollisionResolutionSystem,

        DrawSystem
    )

    self.world:addEntity(Level:new("assets/levels/test2.lua", self.world))
end

--- Updates the state
-- @param dt Delta time
function LevelState:update(dt)
    Timer.update(dt)
    State.update(self)
end

return LevelState
