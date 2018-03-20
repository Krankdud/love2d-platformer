local tiny = require "lib.tiny"

local UpdateSystem = tiny.processingSystem()
UpdateSystem.filter = tiny.requireAll("update")

function UpdateSystem:process(e, dt)
	e:update(dt)
end

return UpdateSystem

