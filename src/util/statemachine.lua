--- State machine

local class = require "lib.middleclass"

local StateMachine = class("StateMachine")
--- Creates a state machine.
-- @param object Table containing the functions
-- @param default Table with the default function names. See addState.
function StateMachine:initialize(object, default)
    self.object = object
    self.states = {}

    self.states["default"] = default or {}

    self.currentId = "default"
end

--- Add a state to the machine.
-- A state is table which contains the keys of the functions of the object to be called.
-- Example:
--   state = {
--       enter = "enter",
--       update = "update",
--       draw = "draw"
--   }
-- "enter", "update", and "draw" are the keys in the object that give us the functions
-- that we want to call.
--
-- enter  - Called when switching to the state
-- update - Called during the game loop. Either returns the id of the state to switch to,
--          or doesn't return a value to stay at the same state.
-- draw   - Called during rendering
--
-- Note: The keys are used rather than the functions themselves so they can be easily
-- hotswapped using lurker.
-- @param id Id of the state
-- @param state Table
function StateMachine:addState(id, state)
    self.states[id] = state
end

--- Sets the state of the machine.
-- @param id Id of the state to switch to
function StateMachine:setState(id)
    self.currentId = id
    if self.states[id].enter ~= nil then
        self.object[self.states[id].enter](self.object)
    end
end

--- Gets the current state of the machine.
-- @return state Current state
function StateMachine:getState()
    return self.currentId
end

--- Calls the update function of the current state.
-- Also handles switching states if the update returns the name of a new state.
-- @param ... Additional arguments to pass to the update function
function StateMachine:update(...)
    local nextId
    local func
    if self.currentId == nil or self.states[self.currentId].update == nil then
        func = self.states["default"].update
    else
        func = self.states[self.currentId].update
    end

    if func ~= nil then
        nextId = self.object[func](self.object, ...)
    end

    if nextId ~= nil then
        self:setState(nextId)
    end
end

--- Calls the draw function of the current state.
-- @param ... Additional arguments to pass to the draw function
function StateMachine:draw(...)
    local func
    if self.currentId == nil or self.states[self.currentId].draw == nil then
        func = self.states["default"].draw
    else
        func = self.states[self.currentId].draw
    end

    if func ~= nil then
        self.object[func](self.object, ...)
    end
end

return StateMachine
