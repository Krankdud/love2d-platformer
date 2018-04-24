--- User configuration.

local inifile = require "lib.inifile"
local log = require "lib.log"

local PlayerInput = require "src.input.player"
local Resolution = require "src.config.resolution"

local config = {
    resolution = Resolution,
    framerate = -1,

    soundVolume = 100,
    musicVolume = 100,

    debug = {
        showAABB = false,
        showGraphs = true,
        showTracker = true
    }
}

--- Safely gets a property. Returns the default if the property doesn't exist
local function getProperty(default, ini, ...)
    local args = {...}
    local t = ini
    for i=1, #args do
        local key = args[i]
        if t[key] ~= nil then
            t = t[key]
        else
            log.warn("Could not read value for ", ...)
            return default
        end
    end

    if t ~= nil then
        return t
    end
    return default
end

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
        },
        debug = {
            aabb = config.debug.showAABB,
            graphs = config.debug.showGraphs,
            tracker = config.debug.showTracker
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
        log.warn("Config file at", path, "could not be found")
        return false
    end

    local ini = inifile.parse(path)

    config.resolution.fullscreen = getProperty(config.resolution.fullscreen, ini, "graphics", "fullscreen")
    config.resolution.vsync = getProperty(config.resolution.vsync, ini, "graphics", "vsync")
    config.resolution.currentResolution = getProperty(config.resolution.currentResolution, ini, "graphics", "resolution")

    config.framerate = getProperty(config.framerate, ini, "graphics", "framerate")
    config.soundVolume = getProperty(config.soundVolume, ini, "audio", "soundvolume")
    config.musicVolume = getProperty(config.musicVolume, ini, "audio", "musicvolume")

    PlayerInput.config.controls.left[1] = getProperty(PlayerInput.config.controls.left[1], ini, "controls", "left")
    PlayerInput.config.controls.right[1] = getProperty(PlayerInput.config.controls.right[1], ini, "controls", "right")
    PlayerInput.config.controls.up[1] = getProperty(PlayerInput.config.controls.up[1], ini, "controls", "up")
    PlayerInput.config.controls.down[1] = getProperty(PlayerInput.config.controls.down[1], ini, "controls", "down")
    PlayerInput.config.controls.jump[1] = getProperty(PlayerInput.config.controls.jump[1], ini, "controls", "jump")
    PlayerInput.config.controls.shoot[1] = getProperty(PlayerInput.config.controls.shoot[1], ini, "controls", "shoot")

    config.debug.showAABB = getProperty(config.debug.showAABB, ini, "debug", "aabb")
    config.debug.showGraphs = getProperty(config.debug.showGraphs, ini, "debug", "graphs")
    config.debug.showTracker = getProperty(config.debug.showTracker, ini, "debug", "tracker")

    log.debug("Loaded config from " .. path)

    return true
end

return config
