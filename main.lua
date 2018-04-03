require "lib.autobatch"
local gamestate = require "lib.hump.gamestate"
local log = require "lib.log"
local lurker = require "lib.lurker"

assets = require("lib.cargo").init({
    dir = "assets",
    processors = {
        ['images/'] = function(image)
            image:setFilter("nearest", "nearest")
        end
    }
})

local graphs = require "src.graphs"
local input = require "src.input"
local screenScaler = require "src.screenscaler"

local LevelState = require "src.states.levelstate"

function love.load()
    log.usecolor = false
    log.outfile = "plat.log"
    log.createWriter()

    lurker.path = "src"

    graphs:init()
    screenScaler:init(320, 240)

    gamestate.registerEvents()
    gamestate.switch(LevelState:new())
end

function love.run()
    if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    local dt = 0
    local accum = 0
    local rate = 1 / 60

    -- Main loop time.
    return function()
        -- Update dt, as we'll be passing it to update
        dt = love.timer.step()
        accum = accum + dt

        while accum >= rate do
            accum = accum - rate

            -- Process events.
            if love.event then
                love.event.pump()
                for name, a,b,c,d,e,f in love.event.poll() do
                    if name == "quit" then
                        if not love.quit or not love.quit() then
                            return a or 0
                        end
                    end
                    love.handlers[name](a,b,c,d,e,f)
                end
            end

            -- Call update and draw
            if love.update then love.update(rate) end
        end

        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()
            love.graphics.clear(love.graphics.getBackgroundColor())

            if love.draw then love.draw() end

            love.graphics.present()
        end

        if love.timer then love.timer.sleep(0.001) end
    end
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
