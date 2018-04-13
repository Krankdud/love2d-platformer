local baton = require "lib.baton"

local input = baton.new({
    controls = {
        left = {"key:left"},
        right = {"key:right"},
        up = {"key:up"},
        down = {"key:down"},
        jump = {"key:z"},
        shoot = {"key:x"},
        pause = {"key:escape"}
    },
    pairs = {
        movePair = {"left", "right", "up", "down"}
    },
    squareDeadzone = true,
    deadzone = 0.5,
    joystick = love.joystick.getJoysticks()[1]
})

input.config.defaults = {
    left = {"key:left"},
    right = {"key:right"},
    up = {"key:up"},
    down = {"key:down"},
    jump = {"key:z"},
    shoot = {"key:x"},
    pause = {"key:escape"}
}

return input
