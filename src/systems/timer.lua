--- System that updates timers

local class = require "lib.middleclass"
local Timer = require "lib.hump.timer"
local tiny = require "lib.tiny"

local TimerSystem = tiny.system(class("TimerSystem"))

--- Updates Timers
-- @param dt Delta time
function TimerSystem:update(dt)
    Timer.update(dt)
end

return TimerSystem
