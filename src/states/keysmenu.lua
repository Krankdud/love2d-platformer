local class = require "lib.middleclass"
local gamestate = require "lib.hump.gamestate"

-- Systems
local DrawSystem   = require "src.systems.draw"
local UpdateSystem = require "src.systems.update"

local Menu = require "src.menu"
local State = require "src.states.state"

local KeysMenuState = class("OptioneMenuState", State)
function KeysMenuState:initialize()
    State.initialize(self,
        UpdateSystem:new(),
        DrawSystem:new()
    )

    self.menu = Menu:new({
        {
            title = "Left",
            caption = "Press [Enter] to change the key binding",
            confirm = function()
            end
        },
        {
            title = "Right",
            caption = "Press [Enter] to change the key binding",
            confirm = function()
            end
        },
        {
            title = "Up",
            caption = "Press [Enter] to change the key binding",
            confirm = function()
            end
        },
        {
            title = "Down",
            caption = "Press [Enter] to change the key binding",
            confirm = function()
            end
        },
        {
            title = "Jump",
            caption = "Press [Enter] to change the key binding",
            confirm = function()
            end
        },
        {
            title = "Shoot",
            caption = "Press [Enter] to change the key binding",
            confirm = function()
            end
        },
        {
            title = "Restore Defaults",
            caption = "Restore the default controls",
            confirm = function()
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

return KeysMenuState
