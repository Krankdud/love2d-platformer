--- LevelIntroState displays the level number and title for a short period of time.

local class = require "lib.middleclass"
local log = require "lib.log"
local gamestate = require "lib.hump.gamestate"
local Timer = require "lib.hump.timer"

local screenScaler = require "src.screenscaler"
local State = require "src.states.state"
-- Systems
local DrawSystem               = require "src.systems.draw"
local ScreenScalerStartSystem  = require "src.systems.screenscalerstart"
local ScreenScalerFinishSystem = require "src.systems.screenscalerfinish"
local TimerSystem              = require "src.systems.timer"

local TEXT_Y = 160

local LevelIntroState = class("LevelIntroState", State)
--- Initializes the level intro state.
-- @param game Game object to obtain the current level from.
function LevelIntroState:initialize(game)
    State.initialize(self,
        TimerSystem:new(),
        ScreenScalerStartSystem:new(),
        DrawSystem:new(),
        ScreenScalerFinishSystem:new()
    )

    Timer.after(3, function()
        gamestate.switch(self.factory.create("Level", game))
    end)

    local map = assets.levels[game:getCurrentLevel()]

    log.debug("Reading map '" .. game:getCurrentLevel() .. "'")

    local levelNum = "Level " .. game.level
    self.world:addEntity({
        draw = function()
            local font = assets.fonts.monogram(16)
            love.graphics.setFont(font)
            love.graphics.printf(levelNum, 0, TEXT_Y, screenScaler.width, "center")
            love.graphics.printf(map.properties.title, 0, TEXT_Y + font:getHeight(), screenScaler.width, "center")
        end
    })
end

return LevelIntroState
