--- Factory for creating states.
-- The factory creates a state and adds a factory property to the new state
-- so new states can easily create other states.

local KeysMenu = require "src.states.keysmenu"
local Level = require "src.states.level"
local MainMenu = require "src.states.mainmenu"
local OptionsMenu = require "src.states.optionsmenu"
local PauseMenu = require "src.states.pausemenu"

local Factory = {}

--- Creates a state
-- @param state Type of state to create.
-- @param ... Additional arguments to pass to the new state.
function Factory.create(state, ...)
    local newState
    if state == "KeysMenu" then
        newState = KeysMenu:new(...)
    elseif state == "Level" then
        newState = Level:new(...)
    elseif state == "MainMenu" then
        newState = MainMenu:new(...)
    elseif state == "OptionsMenu" then
        newState = OptionsMenu:new(...)
    elseif state == "PauseMenu" then
        newState = PauseMenu:new(...)
    end

    newState.factory = Factory
    return newState
end

return Factory
