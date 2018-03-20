local autobatch = require "lib.autobatch"
local debugGraph = require "lib.debugGraph"
local gamestate = require "lib.hump.gamestate"
local tick = require "lib.tick"

assets = require("lib.cargo").init("assets")
local input = require "src.input"

local LevelState = require "src.states.levelstate"

function love.load(arg)
	tick.rate = 1 / 60

	fpsGraph = debugGraph:new("fps", 0, 0)
	memGraph = debugGraph:new("mem", 0, 30)

	gamestate.registerEvents()
	gamestate.switch(LevelState:new())
end

function love.update(dt)
	require("lib.lurker").update()

	input:update()

	fpsGraph:update(dt)
	memGraph:update(dt)
end

function love.draw()
	love.graphics.setColor(255, 255, 255, 255)
	fpsGraph:draw()
	memGraph:draw()
end
