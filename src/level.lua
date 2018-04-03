--- Loads Tiled maps
-- TODO: Documentation on layers, format, etc.

local bump = require "lib.bump"
local class = require "lib.middleclass"
local sti = require "lib.sti"

-- Entities
local Player = require "src.entities.player"

local Level = class("Level")
--- Creates a level from a Tiled map.
-- Tiled map needs to have a collision layer and an entities layer.
-- @param path Path to the level
-- @param world tiny.world instance to add entities to
function Level:initialize(path, world)
    self.map = sti(path, { "bump" })

    self.collisionWorld = bump.newWorld()
    self.map:bump_init(self.collisionWorld)

    local entities = self.map.layers["entities"]
    for _,object in ipairs(entities.objects) do
        if object.name == "player" then
            world:addEntity(Player:new(object.x, object.y, self.collisionWorld))
        end
    end
end

--- Draws the tile layers
function Level:draw()
    love.graphics.setColor(1.0, 1.0, 1.0)
    self.map:drawTileLayer("collision")
end

return Level
