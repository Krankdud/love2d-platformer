--- LevelState is the main gameplay state.

local class = require "lib.middleclass"
local gamestate = require "lib.hump.gamestate"
local Timer = require "lib.hump.timer"

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
local PlayerInput = require "src.input.player"

local LevelState = class("LevelState", State)
--- Initializes the state and loads a level
-- @param game Game object to get the current level from
function LevelState:initialize(game)
    State.initialize(self,
        TimerSystem:new(),
        UpdateSystem:new(),
        IntegrateAxisSystem:new("x", "velocity", "acceleration"),
        IntegrateAxisSystem:new("y", "velocity", "acceleration"),
        LimitVelocitySystem:new(),

        IntegrateAxisSystem:new("x", "position", "velocity"),
        IntegrateAxisSystem:new("y", "position", "velocity"),

        CollisionDetectionSystem:new(),
        CollisionWithLevelSystem:new(),
        CollisionResolutionSystem:new(),

        CameraUpdateSystem:new(),

        CameraStartSystem:new(),
        DrawSystem:new(),
        CameraFinishSystem:new()
    )

    self.game = game
    self.isExitting = false

    Camera:new()
    self.world:addEntity(Level:new("assets/levels/" .. game:getCurrentLevel() .. ".lua", self, self.world))
end

function LevelState:update(dt)
    State.update(self, dt)

    if PlayerInput:pressed("pause") then
        gamestate.push(self.factory.create("PauseMenu"))
    end

    if love.keyboard.isScancodeDown("f5") then
        self.world:clearSystems()
        self.world:clearEntities()
        self.world:refresh()
        gamestate.switch(LevelState:new())
    end
end

function LevelState:exit()
    if self.isExitting then return end

    self.isExitting = true

    Timer.after(0.1, function()
        self.game.level = self.game.level + 1
        self.game:save()
        gamestate.switch(self.factory.create("LevelIntro", self.game))
    end)
end

return LevelState
