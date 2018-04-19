local class = require "lib.middleclass"
local Timer = require "lib.hump.timer"

local Bullet = require "src.entities.bullet"
local Collision = require "src.util.collision"

local math = math

local PlayerBullet = class("PlayerBullet", Bullet)
function PlayerBullet:initialize(x, y, direction, playerVelocity, world, collisionWorld)
    Bullet.initialize(self, x, y, 4, 4, world, collisionWorld)

    self.aabb.type = "bullet"
    self.aabb.filter = Collision.filter.default

    if direction == "right" then
        self.velocity.x = math.max(4, 4 + playerVelocity.x)
        self.velocity.y = 0
    elseif direction == "left" then
        self.velocity.x = math.min(-4, -4 + playerVelocity.x)
        self.velocity.y = 0
    elseif direction == "up" then
        self.velocity.x = 0
        self.velocity.y = math.min(-4, -4 + playerVelocity.y)
    end

    Timer.after(0.4, function()
        self:remove()
    end)
end

return PlayerBullet
