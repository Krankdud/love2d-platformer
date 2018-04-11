local class = require "lib.middleclass"
local gamestate = require "lib.hump.gamestate"

-- Systems
local DrawSystem   = require "src.systems.draw"
local UpdateSystem = require "src.systems.update"

local KeysMenuState = require "src.states.keysmenu"
local Menu = require "src.menu"
local State = require "src.states.state"

local OptionsMenuState = class("OptioneMenuState", State)
function OptionsMenuState:initialize()
    State.initialize(self,
        UpdateSystem:new(),
        DrawSystem:new()
    )

    self.menu = Menu:new({
        {
            title = "Resolution",
            caption = "Change resolution of the game",
            confirm = function()
            end
        },
        {
            title = "Fullscreen",
            caption = "Toggle fullscreen mode",
            confirm = function()
            end
        },
        {
            title = "Sound Volume",
            caption = "Adjust the sound volume"
        },
        {
            title = "Music Volume",
            caption = "Adjust the music volume"
        },
        {
            title = "Key Bindings",
            caption = "Customize your controls",
            confirm = function()
                gamestate.push(KeysMenuState:new())
            end
        },
        {
            title = "Back",
            caption = "Return to the main menu",
            confirm = function()
                gamestate.pop()
            end
        }
    },
    {
        back = function()
            gamestate.pop()
        end
    })

    self.world:addEntity(self.menu)
end

return OptionsMenuState
