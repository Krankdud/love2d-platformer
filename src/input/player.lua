local baton = require "lib.baton"

local input = baton.new({
    controls = {
        left = {"key:left"},
        right = {"key:right"},
        up = {"key:up"},
        down = {"key:down"},
        jump = {"key:z"},
        shoot = {"key:x"}
    },
    pairs = {
        movePair = {"left", "right", "up", "down"}
    },
    squareDeadzone = true
})

input.config.defaults = {
    left = {"key:left"},
    right = {"key:right"},
    up = {"key:up"},
    down = {"key:down"},
    jump = {"key:z"},
    shoot = {"key:x"}
}

return input
