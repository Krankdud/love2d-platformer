--- System that calls the update function of an entity

local class = require "lib.middleclass"
local tiny = require "lib.tiny"

local UpdateSystem = tiny.processingSystem(class("UpdateSystem"))
UpdateSystem.filter = tiny.requireAll("update")

--- Calls update on an entity.
-- @param e Entity
-- @param dt Delta time
function UpdateSystem:process(e, dt)
    e:update(dt)
end

return UpdateSystem

