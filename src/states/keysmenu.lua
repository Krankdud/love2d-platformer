local class = require "lib.middleclass"
local gamestate = require "lib.hump.gamestate"

-- Systems
local DrawSystem   = require "src.systems.draw"
local TimerSystem  = require "src.systems.timer"
local UpdateSystem = require "src.systems.update"

local BindKeyItem = require "src.menu.bindkeyitem"
local Menu = require "src.menu"
local PlayerInput = require "src.input.player"
local State = require "src.states.state"

local KeysMenuState = class("OptioneMenuState", State)
function KeysMenuState:initialize()
    State.initialize(self,
        TimerSystem:new(),
        UpdateSystem:new(),
        DrawSystem:new()
    )

    self.menu = Menu:new({
        BindKeyItem:new("Left", PlayerInput.config.controls.left, PlayerInput.config.joystick),
        BindKeyItem:new("Right", PlayerInput.config.controls.right, PlayerInput.config.joystick),
        BindKeyItem:new("Up", PlayerInput.config.controls.up, PlayerInput.config.joystick),
        BindKeyItem:new("Down", PlayerInput.config.controls.down, PlayerInput.config.joystick),
        BindKeyItem:new("Jump", PlayerInput.config.controls.jump, PlayerInput.config.joystick),
        BindKeyItem:new("Shoot", PlayerInput.config.controls.shoot, PlayerInput.config.joystick),
        {
            title = "Restore Defaults",
            caption = "Restore the default controls",
            confirm = function()
                PlayerInput.config.controls.left[1] = PlayerInput.config.defaults.left[1]
                PlayerInput.config.controls.right[1] = PlayerInput.config.defaults.right[1]
                PlayerInput.config.controls.up[1] = PlayerInput.config.defaults.up[1]
                PlayerInput.config.controls.down[1] = PlayerInput.config.defaults.down[1]
                PlayerInput.config.controls.jump[1] = PlayerInput.config.defaults.jump[1]
                PlayerInput.config.controls.shoot[1] = PlayerInput.config.defaults.shoot[1]

                gamestate.switch(KeysMenuState:new())
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
        y = 60,

        back = function()
            gamestate.pop()
        end
    })

    self.world:addEntity(self.menu)
end

return KeysMenuState
