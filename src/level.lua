--- Loads Tiled maps
-- TODO: Documentation on layers, format, etc.

local bump = require "lib.bump"
local class = require "lib.middleclass"
local log = require "lib.log"
local sti = require "lib.sti"

local Camera = require "src.camera"

-- Entities
local Player = require "src.entities.player"

local Level = class("Level")
--- Creates a level from a Tiled map.
-- Tiled map needs to have a collision layer and an entities layer.
-- @param path Path to the level
-- @param gameState Game state that the level is in
-- @param world tiny.world instance to add entities to
function Level:initialize(path, gameState, world)
    log.debug("Creating level from '" .. path .. "'")
    self.map = sti(path, { "bump" })

    self.collisionWorld = bump.newWorld()
    self.map:bump_init(self.collisionWorld)

    local entities = self.map.layers["entities"]
    for _,object in ipairs(entities.objects) do
        if object.name == "player" then
            local player = Player:new(gameState, object.x, object.y, world, self.collisionWorld)
            Camera:setFollow(player)
            world:addEntity(player)
        elseif object.name == "exit" then
            local exit = {
                position = {x = object.x, y = object.y},
                aabb = {
                    width = object.width,
                    height = object.height,
                    world = self.collisionWorld,
                    type = "exit"
                }
            }
            self.collisionWorld:add(exit, object.x, object.y, object.width, object.height)
            world:addEntity(exit)
        end
    end
end

--- Draws the tile layers
function Level:draw()
    love.graphics.setColor(1.0, 1.0, 1.0)
    self.map:drawTileLayer("collision")
end

return Level
