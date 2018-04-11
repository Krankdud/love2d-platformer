local baton = require "lib.baton"

local input = baton.new({
    controls = {
        left = {"key:left"},
        right = {"key:right"},
        up = {"key:up"},
        down = {"key:down"},
        confirm = {"key:return"},
        back = {"key:escape"}
    },
    squareDeadzone = true
})

return input
