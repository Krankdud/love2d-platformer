local class = require "lib.middleclass"
local gamestate = require "lib.hump.gamestate"

-- Systems
local DrawSystem   = require "src.systems.draw"
local UpdateSystem = require "src.systems.update"

local config = require "src.config"
local KeysMenuState = require "src.states.keysmenu"
local Menu = require "src.menu"
local Resolution = require "src.config.resolution"
local ScreenScaler = require "src.screenscaler"
local State = require "src.states.state"

local OptionsMenuState = class("OptioneMenuState", State)
function OptionsMenuState:initialize()
    State.initialize(self,
        UpdateSystem:new(),
        DrawSystem:new()
    )

    local resolution = Resolution:get()
    self.menu = Menu:new({
        {
            title = "Resolution: " .. resolution.width .. "x" .. resolution.height,
            caption = "Press [Left] or [Right] to change the resolution",
            left = function(item)
                if Resolution:decrease() then
                    ScreenScaler:reinit()

                    local res = Resolution:get()
                    item.title = "Resolution: " .. res.width .. "x" .. res.height
                end
            end,
            right = function(item)
                if Resolution:increase() then
                    ScreenScaler:reinit()

                    local res = Resolution:get()
                    item.title = "Resolution: " .. res.width .. "x" .. res.height
                end
            end
        },
        {
            title = "Fullscreen: Off",
            caption = "Toggle fullscreen mode",
            confirm = function()
            end
        },
        {
            title = "Sound Volume: " .. config.soundVolume .. "%",
            caption = "Press [Left] or [Right] to adjust the sound volume",
            left = function(item)
                config.soundVolume = math.max(0, config.soundVolume - 10)
                item.title = "Sound Volume: " .. config.soundVolume .. "%"
            end,
            right = function(item)
                config.soundVolume = math.min(100, config.soundVolume + 10)
                item.title = "Sound Volume: " .. config.soundVolume .. "%"
            end
        },
        {
            title = "Music Volume: " .. config.musicVolume .. "%",
            caption = "Press [Left] or [Right] to adjust the music volume",
            left = function(item)
                config.musicVolume = math.max(0, config.musicVolume - 10)
                item.title = "Music Volume: " .. config.musicVolume .. "%"
            end,
            right = function(item)
                config.musicVolume = math.min(100, config.musicVolume + 10)
                item.title = "Music Volume: " .. config.musicVolume .. "%"
            end
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
        y = 60,
        back = function()
            gamestate.pop()
        end
    })

    self.world:addEntity(self.menu)
end

return OptionsMenuState
