--- User configuration.

local inifile = require "lib.inifile"
local log = require "lib.log"

local PlayerInput = require "src.input.player"
local Resolution = require "src.config.resolution"

local config = {
    resolution = Resolution,
    framerate = -1,

    soundVolume = 100,
    musicVolume = 100
}

--- Saves the config as an ini file.
-- @param path File path. Defaults to "config.ini"
function config.save(path)
    path = path or "config.ini"

    local ini = {
        graphics = {
            resolution = config.resolution.currentResolution,
            fullscreen = config.resolution.fullscreen,
            vsync = config.resolution.vsync,
            framerate = config.framerate
        },
        audio = {
            soundvolume = config.soundVolume,
            musicvolume = config.musicVolume
        },
        controls = {
            left = PlayerInput.config.controls.left[1],
            right = PlayerInput.config.controls.right[1],
            up = PlayerInput.config.controls.up[1],
            down = PlayerInput.config.controls.down[1],
            jump = PlayerInput.config.controls.jump[1],
            shoot = PlayerInput.config.controls.shoot[1]
        }
    }

    inifile.save(path, ini)
    log.debug("Saved config to " .. path)
end

--- Loads the user configuration ini file.
-- @param path File path. Defaults to "config.ini"
-- @return Boolean if file was found and loaded.
function config.load(path)
    path = path or "config.ini"

    local info = love.filesystem.getInfo(path)

    if info == nil or info.type ~= "file" then
        return false
    end

    local ini = inifile.parse(path)

    config.resolution.fullscreen = ini.graphics.fullscreen
    config.resolution.vsync = ini.graphics.vsync
    config.resolution.currentResolution = ini.graphics.resolution

    config.framerate = ini.graphics.framerate
    config.soundVolume = ini.audio.soundvolume
    config.musicVolume = ini.audio.musicvolume

    PlayerInput.config.controls.left[1] = ini.controls.left
    PlayerInput.config.controls.right[1] = ini.controls.right
    PlayerInput.config.controls.up[1] = ini.controls.up
    PlayerInput.config.controls.down[1] = ini.controls.down
    PlayerInput.config.controls.jump[1] = ini.controls.jump
    PlayerInput.config.controls.shoot[1] = ini.controls.shoot

    log.debug("Loaded config from " .. path)

    return true
end

return config
