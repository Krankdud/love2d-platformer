local class = require "lib.middleclass"
local tiny = require "lib.tiny"

local ScreenScaler = require "src.screenscaler"

local ScreenScalerFinish = tiny.system(class("ScreenScalerFinishSystem"))
ScreenScalerFinish.isPostDrawSystem = true

function ScreenScalerFinish:update()
    ScreenScaler:finish()
    ScreenScaler:draw()
end

return ScreenScalerFinish
