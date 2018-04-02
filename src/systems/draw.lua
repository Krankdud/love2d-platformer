local tiny = require "lib.tiny"

local DrawSystem = tiny.processingSystem()
DrawSystem.isDrawSystem = true
DrawSystem.filter = tiny.requireAll("draw")

function DrawSystem:process(e)
    e:draw()
end

return DrawSystem
