local autobatch = require "lib.autobatch"
local gamestate = require "lib.hump.gamestate"
local tick = require "lib.tick"

assets = require("lib.cargo").init("assets")

local graphs = require "src.graphs"
local input = require "src.input"
local screenScaler = require "src.screenscaler"

local LevelState = require "src.states.levelstate"

function love.load(arg)
	tick.rate = 1 / 60

	graphs:init()
	screenScaler:init(320, 240)

	gamestate.registerEvents()
	gamestate.switch(LevelState:new())
end

function love.update(dt)
	require("lib.lurker").update()

	graphs:update(dt)
	input:update()
end
