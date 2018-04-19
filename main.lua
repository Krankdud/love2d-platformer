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

local config = require "src.config"
local graphs = require "src.graphs"
local menuInput = require "src.input.menu"
local playerInput = require "src.input.player"
local screenScaler = require "src.screenscaler"

local StateFactory = require "src.statefactory"

function love.load()
    log.usecolor = false
    log.outfile = "plat-" .. os.time() .. ".log"
    log.createWriter()

    lurker.path = "src"

    config.load()
    config.resolution:reset()

    require "lib.autobatch"

    graphs:init()
    screenScaler:init(320, 240)

    gamestate.registerEvents()
    gamestate.switch(StateFactory.create("MainMenu"))
end

function love.run()
    if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    local dt = 0
    local accum = 0
    local rate = 1 / 60

    local nextTime = love.timer.getTime()

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

        if config.framerate > 0 and not config.resolution.vsync then
            nextTime = nextTime + 1 / config.framerate
            local curTime = love.timer.getTime()
            if nextTime < curTime then
                nextTime = curTime
            else
                love.timer.sleep(nextTime - curTime)
            end
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
    menuInput:update()
    playerInput:update()
end

local errhand = love.errorhandler
function love.errorhandler(msg)
    log.fatal(debug.traceback(msg, 3):gsub("\n[^\n]+$", ""))

    errhand(msg)
end

function love.exit()
    log.closeWriter()
    return false
end
