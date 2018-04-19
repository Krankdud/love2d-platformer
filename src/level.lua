--- Loads Tiled maps
-- TODO: Documentation on layers, format, etc.

local bump = require "lib.bump"
local class = require "lib.middleclass"
local log = require "lib.log"
local sti = require "lib.sti"

local Camera = require "src.camera"
local Collision = require "src.util.collision"

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
        self:createEntity(object, gameState, world)
    end
end

--- Draws the tile layers
function Level:draw()
    love.graphics.setColor(1.0, 1.0, 1.0)
    self.map:drawTileLayer("collision")
end

function Level:createEntity(object, gameState, world)
    if object.name == "player" then
        local player = Player:new(gameState, object.x, object.y, world, self.collisionWorld)
        gameState.player = player
        Camera:setFollow(player)
        world:addEntity(player)
    else
        log.debug("Creating generic entity of type " .. object.name)
        local ent = {
            position = {x = object.x, y = object.y},
            aabb = {
                width = object.width,
                height = object.height,
                world = self.collisionWorld,
                type = object.name,
                filter = Collision.filter.ignoreAll
            }
        }
        self.collisionWorld:add(ent, object.x, object.y, object.width, object.height)
        world:addEntity(ent)
    end
end

return Level
