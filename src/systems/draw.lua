local tiny = require "lib.tiny"

local DrawSystem = tiny.processingSystem()
DrawSystem.isDrawSystem = true
DrawSystem.filter = tiny.requireAll("draw")

function DrawSystem:process(e, dt)
    e:draw()
end

return DrawSystem
