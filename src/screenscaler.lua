--- ScreenScaler controls scaling the game from a low resolution to a higher resolution using a canvas.
-- This does not attempt to force scaling by an integer, so the window resolution would need to be an integer
-- multiple of the game's resolution if you want to scale by an integer.

local log = require "lib.log"

local ScreenScaler = {}

--- Initializes the ScreenScaler.
-- This creates a canvas with the given width and height that will be used to draw everything that needs to
-- be scaled. The canvas will be scaled to the width and height of the screen.
-- @param width Width of the canvas
-- @param height Height of the canvas
-- @param keepAspectRatio Ensure that the ratio between width and height of the canvas remain 1:1. Defaults to true.
function ScreenScaler:init(width, height, keepAspectRatio)
    if keepAspectRatio == nil then
        keepAspectRatio = true
    end

    self.width = width
    self.height = height

    self.scale = {x = love.graphics.getWidth() / self.width, y = love.graphics.getHeight() / self.height}

    if keepAspectRatio and self.scale.x ~= self.scale.y then
        if self.scale.x < self.scale.y then
            self.scale.y = self.scale.x
        else
            self.scale.x = self.scale.y
        end
    end
    log.debug("scale: {" .. self.scale.x .. ", " .. self.scale.y .. "}")

    self.position = {}
    self.position.x = love.graphics.getWidth() / 2 - self.width / 2 * self.scale.x
    self.position.y = love.graphics.getHeight() / 2 - self.height / 2 * self.scale.y

    self.canvas = love.graphics.newCanvas(width, height)
    self.canvas:setFilter("nearest", "nearest", 1)
end

--- Call before making any draw calls that you want to be scaled.
function ScreenScaler:start()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
end

--- Call after making all draw calls that you want to be scaled.
function ScreenScaler:finish()
    love.graphics.setCanvas()
end

--- Draw the canvas.
-- If keepAspectRatio was true when initializing the screen scaler, the canvas will be centered
-- if the aspect ratio of the canvas is different from the aspect ratio of the window.
function ScreenScaler:draw()
    local prevMode, prevAlphaMode = love.graphics.getBlendMode()

    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setColor(1.0, 1.0, 1.0)
    love.graphics.draw(self.canvas, self.position.x, self.position.y, 0, self.scale.x, self.scale.y)
    love.graphics.setBlendMode(prevMode, prevAlphaMode)
end

--- Get the position of the mouse and adjust it to fit the scaled contents of the screen
-- @return x Adjusted mouse X position
-- @return y Adjusted mouse Y position
function ScreenScaler:getMousePosition()
    return self:getMouseX(), self:getMouseY()
end

--- Get the X position of the mouse and adjust it to fit the scaled contents of the screen
-- @return x Adjusted mouse X position
function ScreenScaler:getMouseX()
    return love.mouse.getX() / self.scale.x
end

--- Get the Y position of the mouse and adjust it to fit the scaled contents of the screen
-- @return y Adjusted mouse Y position
function ScreenScaler:getMouseY()
    return love.mouse.getY() / self.scale.y
end

return ScreenScaler
