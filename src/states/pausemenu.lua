local class = require "lib.middleclass"
local gamestate = require "lib.hump.gamestate"

local Menu = require "src.menu"
local State = require "src.states.state"

-- Systems
local DrawSystem               = require "src.systems.draw"
local ScreenScalerStartSystem  = require "src.systems.screenscalerstart"
local ScreenScalerFinishSystem = require "src.systems.screenscalerfinish"
local UpdateSystem             = require "src.systems.update"

local PlayerInput = require "src.input.player"

local PauseMenuState = class("PauseMenuState", State)
function PauseMenuState:initialize()
    State.initialize(self,
        UpdateSystem:new(),
        ScreenScalerStartSystem:new(),
        DrawSystem:new(),
        ScreenScalerFinishSystem:new()
    )

    self.menu = Menu:new({
        {
            title = "Resume",
            caption = "Resume the game",
            confirm = function()
                gamestate.pop()
            end
        },
        {
            title = "Options",
            caption = "Change resolution, volume, or controls",
            confirm = function()
                gamestate.push(self.factory.create("OptionsMenu"))
            end
        },
        {
            title = "Main menu",
            caption = "Return to the main menu",
            confirm = function()
                -- Pop to go back to the level state, then switch to get rid of the level state
                gamestate.pop()
                gamestate.switch(self.factory.create("MainMenu"))
            end
        },
        {
            title = "Exit game",
            caption = "Exit the game",
            confirm = function()
                love.event.quit()
            end
        }
    },
    {
        y = 100
    })

    self.world:addEntity(self.menu)
end

function PauseMenuState:update(dt)
    State.update(self, dt)

    if PlayerInput:pressed("pause") then
        gamestate.pop()
    end
end

return PauseMenuState
