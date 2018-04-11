local class = require "lib.middleclass"
local lume = require "lib.lume"

local playerInput = require "src.input.player"
local menuInput = require "src.input.menu"

local table = table

local Menu = class("Menu")
function Menu:initialize(items, options)
    self.index = 1
    self.items = items or {}

    self.x = 0
    self.y = 0

    if options then
        lume.extend(self, options)
    end
end

function Menu:add(item)
    table.insert(self.items, item)
end

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

function Menu:draw()
    local font = assets.fonts.monogram(16)

    love.graphics.setFont(font)
    for i = 1, #self.items do
        local item = self.items[i]
        local selector = " "
        if i == self.index then
            selector = ">"
        end
        love.graphics.print(selector .. item.title, self.x, self.y + font:getHeight() * (i - 1))
    end

    local currentItem = self.items[self.index]
    if currentItem.caption then
        love.graphics.print(currentItem.caption, 0, 240 - font:getHeight())
    end
end

return Menu
