local class = require "lib.middleclass"
local gamestate = require "lib.hump.gamestate"

local Menu = require "src.menu"
local State = require "src.states.state"

-- Systems
local DrawSystem   = require "src.systems.draw"
local UpdateSystem = require "src.systems.update"

local LevelState = require "src.states.level"
local OptionsMenuState = require "src.states.optionsmenu"

local MainMenuState = class("MainMenuState", State)
function MainMenuState:initialize()
    State.initialize(self,
        UpdateSystem:new(),
        DrawSystem:new()
    )

    self.menu = Menu:new({
        {
            title = "New Game",
            caption = "Start a new game",
            confirm = function()
                gamestate.switch(LevelState:new())
            end
        },
        {
            title = "Continue",
            caption = "Continue your previous game"
        },
        {
            title = "Options",
            caption = "Change resolution, volume, or controls",
            confirm = function()
                gamestate.push(OptionsMenuState:new())
            end
        },
        {
            title = "Exit",
            caption = "Exit the game",
            confirm = function()
                love.event.quit()
            end
        }
    },
    {
        y = 140
    })

    self.world:addEntity(self.menu)
end

return MainMenuState
