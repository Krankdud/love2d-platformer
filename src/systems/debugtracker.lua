local class = require "lib.middleclass"
local tiny = require "lib.tiny"

local config = require "src.config"
local Tracker = require "src.debug.tracker"

local DebugTrackerSystem = tiny.system(class("DebugTrackerSystem"))
DebugTrackerSystem.isPostDrawSystem = true

function DebugTrackerSystem:update()
    if not config.debug.showTracker then return end

    Tracker:update()
    love.graphics.setFont(assets.fonts.monogram(16))
    Tracker:draw(0, 80)
end

return DebugTrackerSystem
