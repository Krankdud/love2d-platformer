local class = require "lib.middleclass"
local cpml = require "lib.cpml"

local ScreenScaler = require "src.screenscaler"

local format = {
    {"VertexPosition", "float", 3},
    {"VertexTexCoord", "float", 2},
    {"VertexColor", "byte", 4}
}

-- Defines top and bottom plane
local vertices = {
    {-100, -1, 0, 0, 0},
    {-100, -1, -100, 0, 25},
    {100, -1, 0, 100, 0},
    {-100, -1, -100, 0, 25},
    {100, -1, 0, 1, 0},
    {100, -1, -100, 25, 25},

    {-100, 1, 0, 0, 0},
    {-100, 1, -100, 0, 25},
    {100, 1, 0, 100, 0},
    {-100, 1, -100, 0, 25},
    {100, 1, 0, 1, 0},
    {100, 1, -100, 25, 25}
}

local Sky = class("Sky")
function Sky:initialize(texture, fogDensity, fogColor, scrollX, scrollY)
    self.fogDensity = fogDensity or 0.5
    self.fogColor = fogColor or {0, 0, 0, 1}
    self.scrollX = scrollX or 0.5
    self.scrollY = scrollY or 0.5
    self.drawLayer = 0
    self.elapsed = 0

    self.canvas = love.graphics.newCanvas(ScreenScaler.width, ScreenScaler.height)

    self.mesh = love.graphics.newMesh(format, vertices, "triangles")
    self.mesh:setTexture(texture)

    self.projection = cpml.mat4.from_perspective(90, ScreenScaler.width / ScreenScaler.height, 0.1, 1000)

    self.shader = assets.shaders.sky
end

function Sky:update(dt)
    self.elapsed = self.elapsed + dt
end

function Sky:draw()
    love.graphics.push()
    love.graphics.origin()

    local oldCanvas = love.graphics.getCanvas()
    love.graphics.setCanvas({self.canvas, depth=true})
    love.graphics.setShader(self.shader)
    love.graphics.setDepthMode("lequal", true)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.clear(self.fogColor)

    self.shader:send("projection", "column", self.projection)
    self.shader:send("fogDensity", self.fogDensity)
    self.shader:send("fogColor", self.fogColor)
    self.shader:send("scroll", {self.scrollX, self.scrollY})
    self.shader:send("elapsed", self.elapsed)
    love.graphics.draw(self.mesh)

    love.graphics.setShader()
    love.graphics.setCanvas(oldCanvas)

    love.graphics.draw(self.canvas)

    love.graphics.pop()
end

return Sky
