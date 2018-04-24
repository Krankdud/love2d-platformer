local class = require "lib.middleclass"
local tiny = require "lib.tiny"

local ScreenScaler = require "src.screenscaler"

local ScreenScalerStart = tiny.system(class("ScreenScalerStartSystem"))
ScreenScalerStart.isDrawSystem = true

function ScreenScalerStart:update()
    ScreenScaler:start()
end

return ScreenScalerStart
