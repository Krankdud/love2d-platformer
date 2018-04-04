--- System that updates timers

local Timer = require "lib.hump.timer"
local tiny = require "lib.tiny"

local TimerSystem = tiny.system()

--- Updates Timers
-- @param dt Delta time
function TimerSystem:update(dt)
    Timer.update(dt)
end

return TimerSystem
