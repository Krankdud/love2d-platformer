--- State is a base class for the game.
-- Contains a tiny.world and handles screen scaling.

local class = require "lib.middleclass"
local tiny = require "lib.tiny"

local config = require "src.config"
local graphs = require "src.graphs"
local screenScaler = require "src.screenscaler"

local function filterDrawSystem(_, s)
    -- if nil return false instead of nil
    return not not s.isDrawSystem
end

local function filterUpdateSystem(_, s)
    return not s.isDrawSystem
end

local State = class("State")
--- Initialize the state
-- @param ... Systems to include in the world
function State:initialize(...)
    self.world = tiny.world(...)
end

--- Called when leaving the state.
-- Clears the systems and entities from the state's world.
function State:leave()
    --[[
    self.world:clearSystems()
    self.world:clearEntities()
    self.world:refresh()
    ]]
end

--- Updates the state
-- @param dt Delta time
function State:update(dt)
    self.world:update(dt, filterUpdateSystem)
end

--- Draws the state
function State:draw()
    screenScaler:start()
    self.world:update(0, filterDrawSystem)
    screenScaler:finish()
    screenScaler:draw()

    if config.debug.showGraphs then
        graphs:draw()
    end
end

return State
