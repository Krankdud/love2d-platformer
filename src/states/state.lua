--- State is a base class for the game.
-- Contains a tiny.world and handles screen scaling.

local class = require "lib.middleclass"
local tiny = require "lib.tiny"

local config = require "src.config"
local graphs = require "src.graphs"

local function filterDrawSystem(_, s)
    -- if nil return false instead of nil
    return not not s.isDrawSystem
end

local function filterUpdateSystem(_, s)
    return not s.isDrawSystem and not s.isPreDrawSystem and not s.isPostDrawSystem
end

local function filterPreDrawSystem(_, s)
    -- if nil return false instead of nil
    return not not s.isPreDrawSystem
end

local function filterPostDrawSystem(_, s)
    -- if nil return false instead of nil
    return not not s.isPostDrawSystem
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
    self:preDraw()
    self:onDraw()
    self:postDraw()

    if config.debug.showGraphs then
        graphs:draw()
    end
end

function State:preDraw()
    self.world:update(0, filterPreDrawSystem)
end

function State:onDraw()
    self.world:update(0, filterDrawSystem)
end

function State:postDraw()
    self.world:update(0, filterPostDrawSystem)
end

return State
