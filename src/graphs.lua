local debugGraph = require "lib.debugGraph"

local Graphs = {}

--- Initializes the debug graphs
function Graphs:init()
    self.fpsGraph = debugGraph:new("fps", 0, 0)
    self.memGraph = debugGraph:new("mem", 0, 30)

    self.visible = true
end

--- Updates the debug graphs
-- @param dt Delta time
function Graphs:update(dt)
    self.fpsGraph:update(dt)
    self.memGraph:update(dt)
end

--- Draws the debug graphs
function Graphs:draw()
    if not self.visible then return end

    love.graphics.setColor(0, 0, 0, 128)
    love.graphics.rectangle("fill", 0, 0, 96, 64)

    love.graphics.setColor(255, 255, 255, 255)
    self.fpsGraph:draw()
    self.memGraph:draw()
end

--- Show the graphs when drawing
function Graphs:show()
    self.visible = true
end

--- Hide the graphs when drawing
function Graphs:hide()
    self.visible = false
end

--- Toggle the visibility of the graphs
function Graphs:toggle()
    self.visible = not self.visible
end

return Graphs
