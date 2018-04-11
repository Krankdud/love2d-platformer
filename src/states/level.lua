--- LevelState is the main gameplay state.

local class = require "lib.middleclass"
local gamestate = require "lib.hump.gamestate"

local State = require "src.states.state"
-- Systems
local CameraStartSystem         = require "src.systems.camerastart"
local CameraFinishSystem        = require "src.systems.camerafinish"
local CameraUpdateSystem        = require "src.systems.cameraupdate"
local CollisionDetectionSystem  = require "src.systems.collisiondetection"
local CollisionResolutionSystem = require "src.systems.collisionresolution"
local CollisionWithLevelSystem  = require "src.systems.collisionwithlevel"
local DrawSystem                = require "src.systems.draw"
local IntegrateAxisSystem       = require "src.systems.integrateaxis"
local LimitVelocitySystem       = require "src.systems.limitvelocity"
local TimerSystem               = require "src.systems.timer"
local UpdateSystem              = require "src.systems.update"

local Camera = require "src.camera"
local Level = require "src.level"

local LevelState = class("LevelState", State)
--- Initializes the state and loads a level
function LevelState:initialize()
    State.initialize(self,
        TimerSystem,
        UpdateSystem:new(),
        IntegrateAxisSystem:new("x", "velocity", "acceleration"),
        IntegrateAxisSystem:new("y", "velocity", "acceleration"),
        LimitVelocitySystem,

        IntegrateAxisSystem:new("x", "position", "velocity"),
        IntegrateAxisSystem:new("y", "position", "velocity"),

        CollisionDetectionSystem,
        CollisionWithLevelSystem,
        CollisionResolutionSystem,

        CameraUpdateSystem,

        CameraStartSystem,
        DrawSystem:new(),
        CameraFinishSystem
    )

    Camera:new()
    self.world:addEntity(Level:new("assets/levels/test.lua", self.world))
end

function LevelState:update(dt)
    State.update(self, dt)

    if love.keyboard.isScancodeDown("f5") then
        self.world:clearSystems()
        self.world:clearEntities()
        self.world:refresh()
        gamestate.switch(LevelState:new())
    end
end

return LevelState