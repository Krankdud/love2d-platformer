--- Debug tracker.
-- Displays a list of values on the screen.

local string = string
local table = table

local Tracker = {}
Tracker.items = {}
Tracker.lines = {}

--- Append adds a value to be tracked.
-- @param name Name of the value
-- @param fn Function that when executed, returns the value to be displayed
function Tracker:append(name, fn)
    table.insert(self.items, {name = name, fn = fn})
end

--- Removes all items from the tracker.
function Tracker:clear()
    self.items = {}
    self.lines = {}
end

--- Updates each item in the tracker.
function Tracker:update()
    for i = 1, #self.items do
        local item = self.items[i]
        local value = item.fn()
        if type(value) == "number" then
            self.lines[i] = string.format("%s = %.03f", item.name, value)
        elseif type(value) == "string" then
            self.lines[i] = string.format("%s = %s", item.name, value)
        elseif type(value) == "boolean" then
            local bool = value and "true" or "false"
            self.lines[i] = string.format("%s = %s", item.name, bool)
        end
    end
end

--- Draws the list of items.
-- @param x X coordinate. Defaults to 0
-- @param y Y coordinate. Defaults to 0
function Tracker:draw(x, y)
    x = x or 0
    y = y or 0

    local font = love.graphics.getFont()
    local text = table.concat(self.lines, "\n")

    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", x, y, font:getWidth(text), #self.lines * font:getHeight())

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(text, x, y)
end

return Tracker
