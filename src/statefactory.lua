--- Factory for creating states.
-- The factory creates a state and adds a factory property to the new state
-- so new states can easily create other states.

local Factory = {}

--- Creates a state
-- @param state Type of state to create.
-- @param ... Additional arguments to pass to the new state.
function Factory.create(state, ...)
    local obj = require("src.states." .. state:lower())
    local newState = obj:new(...)
    newState.factory = Factory
    return newState
end

return Factory
