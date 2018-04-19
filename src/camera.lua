--- Camera
local lume = require "lib.lume"
local ScreenScaler = require "src.screenscaler"

local Camera = {}
--- Initializes the camera.
-- Currently just sets x and y to 0
function Camera:new()
    self.x = 0
    self.y = 0
end

--- Set which entity to follow.
-- The entity should have a position component. If there's an aabb component, the camera
-- will use that to center on the entity.
-- @param entity Entity to follow
function Camera:setFollow(entity)
    self.follow = entity
end

--- Updates the camera's position
function Camera:update()
    if self.follow ~= nil and self.follow.position ~= nil then
        local offsetX = 0
        local offsetY = 0

        if self.follow.aabb ~= nil then
            offsetX = self.follow.aabb.width / 2
            offsetY = self.follow.aabb.height / 2
        end

        self.x = -self.follow.position.x + ScreenScaler.width / 2 - offsetX
        self.y = -self.follow.position.y + ScreenScaler.height / 2 - offsetY
    end
end

--- Start using the camera.
-- Call before drawing anything that is effected by the camera.
function Camera:start()
    love.graphics.push()
    love.graphics.translate(lume.round(self.x), lume.round(self.y))
end

--- Finish using the camera.
-- Call after drawing everything that is effected by the camera.
function Camera:finish()
    love.graphics.pop()
end

return Camera
