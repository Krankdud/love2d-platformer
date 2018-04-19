local class = require "lib.middleclass"
local lume = require "lib.lume"

local ScreenScaler = require "src.screenscaler"

local Fade = class("FadeEntity")
function Fade:initialize(startColor, endColor, time, callback)
    self.color = lume.clone(startColor)
    self.startColor = startColor
    self.endColor = endColor

    self.elapsed = 0
    self.time = time

    self.callback = callback
end

function Fade:update(dt)
    for i=1, #self.color do
        self.color[i] = lume.lerp(self.startColor[i], self.endColor[i], self.elapsed / self.time)
    end
    self.elapsed = self.elapsed + dt

    if self.elapsed > self.time and not self.called then
        self.callback()
        self.called = true
    end
end

function Fade:drawOnTop()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", 0, 0, ScreenScaler.width, ScreenScaler.height)
end

return Fade
