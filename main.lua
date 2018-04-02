local autobatch = require "lib.autobatch"
local gamestate = require "lib.hump.gamestate"
local log = require "lib.log"
local lurker = require "lib.lurker"
local tick = require "lib.tick"

assets = require("lib.cargo").init({
    dir = "assets",
    processors = {
        ['images/'] = function(image, filename)
            image:setFilter("nearest", "nearest")
        end
    }
})

local graphs = require "src.graphs"
local input = require "src.input"
local screenScaler = require "src.screenscaler"

local LevelState = require "src.states.levelstate"

function love.load(arg)
    tick.rate = 1 / 60

    log.usecolor = false
    log.outfile = "plat.log"
    log.createWriter()

    lurker.path = "src"

    graphs:init()
    screenScaler:init(320, 240)

    gamestate.registerEvents()
    gamestate.switch(LevelState:new())
end

function love.update(dt)
    lurker.update()

    graphs:update(dt)
    input:update()
end

function love.exit()
    log.closeWriter()
    return false
end
