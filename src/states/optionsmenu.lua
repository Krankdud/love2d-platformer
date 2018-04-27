local math = math

local class = require "lib.middleclass"
local gamestate = require "lib.hump.gamestate"
local log = require "lib.log"

-- Systems
local DrawSystem               = require "src.systems.draw"
local ScreenScalerStartSystem  = require "src.systems.screenscalerstart"
local ScreenScalerFinishSystem = require "src.systems.screenscalerfinish"
local UpdateSystem             = require "src.systems.update"

local config = require "src.config"
local Menu = require "src.menu"
local ScreenScaler = require "src.screenscaler"
local State = require "src.states.state"

local framerates = {
    60,
    120,
    144,
    240,
    -1
}
local currentFramerate = 1

local OptionsMenuState = class("OptioneMenuState", State)
function OptionsMenuState:initialize(background)
    State.initialize(self,
        UpdateSystem:new(),
        ScreenScalerStartSystem:new(),
        DrawSystem:new(),
        ScreenScalerFinishSystem:new()
    )

    if background then
        self.world:addEntity({
            draw = function()
                love.graphics.setColor(1, 1, 1, 0.3)
                love.graphics.draw(background)
            end
        })
    end

    local resolution = config.resolution:get()

    local fullscreen = "Off"
    if config.resolution.fullscreen then
        fullscreen = "On"
    end

    local vsync = "Off"
    if config.resolution.vsync then
        vsync = "On"
    end

    local framerate = "" .. config.framerate
    if config.framerate == -1 then
        framerate = "Unlimited"
    end
    for i,v in ipairs(framerates) do
        if v == config.framerate then
            currentFramerate = i
        end
    end

    self.menu = Menu:new({
        {
            title = "Windowed Resolution: " .. resolution.width .. "x" .. resolution.height,
            caption = "Press [Left] or [Right] to change the resolution",
            left = function(item)
                if config.resolution:decrease() then
                    ScreenScaler:reinit()
                    config.save()

                    local res = config.resolution:get()
                    item.title = "Windowed Resolution: " .. res.width .. "x" .. res.height
                end
            end,
            right = function(item)
                if config.resolution:increase() then
                    ScreenScaler:reinit()
                    config.save()

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
                config.save()
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
                config.save()
                item.title = "Vsync: " .. text
            end
        },
        {
            title = "Framerate: " .. framerate,
            caption = "Press [Left] or [Right] to adjust the framerate",
            left = function(item)
                currentFramerate = math.max(1, currentFramerate - 1)
                config.framerate = framerates[currentFramerate]
                config.save()
                item.title = "Framerate: " .. config.framerate
            end,
            right = function(item)
                currentFramerate = math.min(#framerates, currentFramerate + 1)
                config.framerate = framerates[currentFramerate]
                config.save()
                if config.framerate > 0 then
                    item.title = "Framerate: " .. config.framerate
                else
                    item.title = "Framerate: Unlimited"
                end
            end
        },
        {
            title = "Sound Volume: " .. config.soundVolume .. "%",
            caption = "Press [Left] or [Right] to adjust the sound volume",
            left = function(item)
                config.soundVolume = math.max(0, config.soundVolume - 10)
                config.save()
                item.title = "Sound Volume: " .. config.soundVolume .. "%"
            end,
            right = function(item)
                config.soundVolume = math.min(100, config.soundVolume + 10)
                config.save()
                item.title = "Sound Volume: " .. config.soundVolume .. "%"
            end
        },
        {
            title = "Music Volume: " .. config.musicVolume .. "%",
            caption = "Press [Left] or [Right] to adjust the music volume",
            left = function(item)
                config.musicVolume = math.max(0, config.musicVolume - 10)
                config.save()
                item.title = "Music Volume: " .. config.musicVolume .. "%"
            end,
            right = function(item)
                config.musicVolume = math.min(100, config.musicVolume + 10)
                config.save()
                item.title = "Music Volume: " .. config.musicVolume .. "%"
            end
        },
        {
            title = "Key Bindings",
            caption = "Customize your controls",
            confirm = function()
                gamestate.push(self.factory.create("KeysMenu", background))
            end
        },
        {
            title = "Back",
            caption = "Return to the main menu",
            confirm = function()
                log.debug("draw:", self.draw, "love.draw", love.draw)
                gamestate.pop()
                log.debug("love.draw", love.draw)
            end
        }
    },
    {
        y = 120,
        back = function()
            gamestate.pop()
        end
    })

    self.world:addEntity(self.menu)
end

return OptionsMenuState
