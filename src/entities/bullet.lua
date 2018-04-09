local class = require "lib.middleclass"

local Bullet = class("Bullet")
function Bullet:initialize(x, y, width, height, world, collisionWorld)
    self.world = world

    self.position = {x = x, y = y}
    self.velocity = {x = 4, y = 0}

    self.aabb = {width = width, height = height, world = collisionWorld}
    self.collideWithLevel = true

    collisionWorld:add(self, self.position.x, self.position.y, self.aabb.width, self.aabb.height)
end

function Bullet:remove()
    self.world:remove(self)
end

function Bullet:update()
    if self.aabb.onLevel then
        self:remove()
    end
end

function Bullet:draw()
    love.graphics.setColor(1.0, 1.0, 1.0)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.aabb.width, self.aabb.height)
end

return Bullet
