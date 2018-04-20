--- System that shows hitboxes for debugging purposes.

local class = require "lib.middleclass"
local tiny = require "lib.tiny"

local config = require "src.config"

local DebugAABBSystem = tiny.processingSystem(class("DebugAABBSystem"))
DebugAABBSystem.isDrawSystem = true
DebugAABBSystem.filter = tiny.requireAll("position", "aabb")

local processingSystemUpdate = DebugAABBSystem.update
function DebugAABBSystem:update(system, dt)
    if not config.debug.showAABB then return end

    processingSystemUpdate(self, system, dt)
end

function DebugAABBSystem:process(e)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.rectangle("fill", e.position.x, e.position.y, e.aabb.width, 1)
    love.graphics.rectangle("fill", e.position.x, e.position.y, 1, e.aabb.height)
    love.graphics.rectangle("fill", e.position.x, e.position.y + e.aabb.height - 1, e.aabb.width, 1)
    love.graphics.rectangle("fill", e.position.x + e.aabb.width - 1, e.position.y, 1, e.aabb.height)

    if e.aabb.type then
        love.graphics.setFont(assets.fonts.monogram(16))
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(e.aabb.type, e.position.x, e.position.y)
    end
end

return DebugAABBSystem
