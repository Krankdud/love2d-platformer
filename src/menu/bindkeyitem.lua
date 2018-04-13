--- BindKeyItem is a Menu item for rebinding keys.

local class = require "lib.middleclass"
local Timer = require "lib.hump.timer"

local BindKeyItem = class("BindKeyItem")
--- Create a BindKeyItem.
-- @param name Name of the control
-- @param control Baton control to modify
function BindKeyItem:initialize(name, control)
    self.title = name .. " - " .. control[1]
    self.caption = "Press [Enter] to change the key binding"

    self.name = name
    self.control = control
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
    love.keypressed = function(key, scancode, isrepeat)
        if key ~= "escape" then
            self.control[1] = "key:" .. key
        end
        self.title = self.name .. " - " .. self.control[1]
        self.caption = "Press [Enter] to change the key binding"

        -- Add a delay before giving control back to the menu,
        -- otherwise an action will fire on the menu as well
        Timer.after(0.1, function() self.isRebinding = false end)

        originalKeyPressed(key, scancode, isrepeat)
        love.keypressed = originalKeyPressed
    end
end

return BindKeyItem
