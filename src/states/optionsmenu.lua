local class = require "lib.middleclass"
local gamestate = require "lib.hump.gamestate"

-- Systems
local DrawSystem   = require "src.systems.draw"
local UpdateSystem = require "src.systems.update"

local config = require "src.config"
local KeysMenuState = require "src.states.keysmenu"
local Menu = require "src.menu"
local ScreenScaler = require "src.screenscaler"
local State = require "src.states.state"

local OptionsMenuState = class("OptioneMenuState", State)
function OptionsMenuState:initialize()
    State.initialize(self,
        UpdateSystem:new(),
        DrawSystem:new()
    )

    local resolution = config.resolution:get()
    local fullscreen = "Off"
    if config.resolution.fullscreen then
        fullscreen = "On"
    end
    local vsync = "Off"
    if config.resolution.vsync then
        vsync = "On"
    end

    self.menu = Menu:new({
        {
            title = "Windowed Resolution: " .. resolution.width .. "x" .. resolution.height,
            caption = "Press [Left] or [Right] to change the resolution",
            left = function(item)
                if config.resolution:decrease() then
                    ScreenScaler:reinit()

                    local res = config.resolution:get()
                    item.title = "Windowed Resolution: " .. res.width .. "x" .. res.height
                end
            end,
            right = function(item)
                if config.resolution:increase() then
                    ScreenScaler:reinit()

                    local res = config.resolution:get()
                    item.title = "Windowed Resolution: " .. res.width .. "x" .. res.height
                end
            end
        },
        {
            title = "Fullscreen: " .. fullscreen,
            caption = "Toggle fullscreen mode",
            confirm = function(item)
                config.resolution.fullscreen = not config.resolution.fullscreen
                local text = "Off"
                if config.resolution.fullscreen then
                    text = "On"
                end

                config.resolution:reset()
                ScreenScaler:reinit()
                item.title = "Fullscreen: " .. text
            end
        },
        {
            title = "Vsync: " .. vsync,
            caption = "Toggle vsync",
            confirm = function(item)
                config.resolution.vsync = not config.resolution.vsync
                local text = "Off"
                if config.resolution.vsync then
                    text = "On"
                end

                config.resolution:reset()
                ScreenScaler:reinit()
                item.title = "Vsync: " .. text
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
