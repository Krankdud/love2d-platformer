--- BindKeyItem is a Menu item for rebinding keys.

local class = require "lib.middleclass"
local Timer = require "lib.hump.timer"

local BindKeyItem = class("BindKeyItem")
--- Create a BindKeyItem.
-- @param name Name of the control
-- @param control Baton control to modify
-- @param joystick Joystick to check
function BindKeyItem:initialize(name, control, joystick)
    self.title = name .. " - " .. control[1]
    self.caption = "Press [Enter] to change the key binding"

    self.name = name
    self.control = control
    self.joystick = joystick
    self.isRebinding = false
end

--- Prevents menu from updating when the user is rebinding a key.
function BindKeyItem:update()
    return self.isRebinding
end

--- Confirm changes the caption and hooks onto the love.keypressed event.
function BindKeyItem:confirm()
    self.caption = "Press any key or press [Escape] to cancel"

    self.isRebinding = true
    self:hook()
end

--- Hook for the love.keypressed event.
-- Waits for the next input and changes the key binding on that input.
-- Afterwards it restores the original love.keypressed event.
function BindKeyItem:hook()
    local originalKeyPressed = love.keypressed
    local originalGamepadAxis = love.gamepadaxis
    local originalGamepadPressed = love.gamepadpressed

    love.keypressed = function(key, scancode, isrepeat)
        local control = self.control[1]
        if key ~= "escape" then
            control = "key:" .. key
        end
        self:setControl(control)

        originalKeyPressed(key, scancode, isrepeat)

        love.keypressed = originalKeyPressed
        love.gamepadaxis = originalGamepadAxis
        love.gamepadpressed = originalGamepadPressed
    end

    love.gamepadaxis = function(joystick, axis, value)
        if joystick == self.joystick and math.abs(value) > 0.8 then
            local control = "axis:" .. axis
            if value > 0 then
                control = control .. "+"
            else
                control = control .. "-"
            end

            self:setControl(control)

            love.keypressed = originalKeyPressed
            love.gamepadaxis = originalGamepadAxis
            love.gamepadpressed = originalGamepadPressed
        end

        originalGamepadAxis(joystick, axis, value)
    end

    love.gamepadpressed = function(joystick, button)
        if joystick == self.joystick then
            self:setControl("button:" .. button)

            love.keypressed = originalKeyPressed
            love.gamepadaxis = originalGamepadAxis
            love.gamepadpressed = originalGamepadPressed
        end

        originalGamepadPressed(joystick, button)
    end
end

function BindKeyItem:setControl(control)
    self.control[1] = control
    self.title = self.name .. " - " .. self.control[1]
    self.caption = "Press [Enter] to change the key binding"

    -- Add a delay before giving control back to the menu,
    -- otherwise an action will fire on the menu as well
    Timer.after(0.1, function() self.isRebinding = false end)
end

return BindKeyItem
