--- System that calls the update function of an entity

local tiny = require "lib.tiny"

local UpdateSystem = tiny.processingSystem()
UpdateSystem.filter = tiny.requireAll("update")

--- Calls update on an entity.
-- @param e Entity
-- @param dt Delta time
function UpdateSystem:process(e, dt)
    e:update(dt)
end

return UpdateSystem

