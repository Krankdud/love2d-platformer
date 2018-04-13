--- Menu is for... well.. menus.
-- The menu contains items which are plain Lua tables.
-- The item table is expected to look like this:
-- {
--     (string) title
--         Name of the item.
--     (string) caption   [optional]
--         Caption displayed at the bottom of the screen.
--     (function) confirm [optional]
--         Function to call when the user presses on the menu item.
--     (function) left    [optional]
--         Function to call when the user presses left on the menu item.
--     (function) right   [optional]
--         Function to call when the user presses right on the menu item.
--     (function) update  [optional]
--         Called every frame. Can return true to suppress the menu from
--         handling other inputs.
--     (function) draw    [optional]
--         Called when drawing. The parameters passed to this function are
--         the current y coordinate and a boolean that determines if this
--         item is currently highlighted. The next y position is expected
--         to be returned from this function.
-- }

local class = require "lib.middleclass"
local lume = require "lib.lume"

local playerInput = require "src.input.player"
local menuInput = require "src.input.menu"
local screenScaler = require "src.screenscaler"

local table = table

local Menu = class("Menu")
--- Creates a menu.
-- @param items A list of menu items
-- @param options Additional options for the menu
function Menu:initialize(items, options)
    self.index = 1
    self.items = items or {}

    self.x = 0
    self.y = 0

    if options then
        lume.extend(self, options)
    end
end

--- Appends an item to the menu
-- @param item Menu item to append
function Menu:add(item)
    table.insert(self.items, item)
end

--- Updates the menu.
-- Let's the current menu item handle updating if it wants to, otherwise it handles everything.
function Menu:update()
    if #self.items == 0 then return end

    local currentItem = self.items[self.index]
    -- If the item is handling all updating, ignore everything else
    if currentItem.update and currentItem:update() then
        return
    end

    if currentItem.confirm and (playerInput:pressed("jump") or menuInput:pressed("confirm")) then
        currentItem:confirm()
    end

    if self.back and (playerInput:pressed("shoot") or menuInput:pressed("back")) then
        self:back()
    end

    if currentItem.left and (playerInput:pressed("left") or menuInput:pressed("left")) then
        currentItem:left()
    end

    if currentItem.right and (playerInput:pressed("right") or menuInput:pressed("right")) then
        currentItem:right()
    end

    if playerInput:pressed("up") or menuInput:pressed("up") then
        self.index = self.index - 1
        if self.index == 0 then
            self.index = #self.items
        end
    end

    if playerInput:pressed("down") or menuInput:pressed("down") then
        self.index = self.index + 1
        if self.index > #self.items then
            self.index = 1
        end
    end
end

--- Draws the menu.
-- By default it draws each item centered, grey if not highlighted, and white if highlighted.
-- The caption is also drawn if it exists.
function Menu:draw()
    local font = assets.fonts.monogram(16)
    local y = self.y

    love.graphics.setFont(font)
    for i = 1, #self.items do
        local item = self.items[i]

        if item.draw then
            y = item:draw(y, i == self.index)
        else
            if i == self.index then
                love.graphics.setColor(1.0, 1.0, 1.0)
            else
                love.graphics.setColor(0.5, 0.5, 0.5)
            end
            love.graphics.printf(item.title, self.x, y, screenScaler.width, "center")
            y = y + font:getHeight()
        end
    end

    local currentItem = self.items[self.index]
    if currentItem.caption then
        love.graphics.setColor(1.0, 1.0, 1.0)
        love.graphics.printf(currentItem.caption, 0, screenScaler.height - font:getHeight(), screenScaler.width, "center")
    end
end

return Menu
