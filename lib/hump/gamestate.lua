--[[
Copyright (c) 2010-2013 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--

local function __NULL__() end

 -- default gamestate produces error on every callback
local state_init = setmetatable({leave = __NULL__},
        {__index = function() error("Gamestate not initialized. Use Gamestate.init()") end})
local stack = {state_init}
local initialized_states = setmetatable({}, {__mode = "k"})

local GS = {}
function GS.new(t) return t or {} end -- constructor - deprecated!

local function change_state(stack_offset, to, ...)
    local pre = stack[#stack]

    -- initialize only on first call
    ;(initialized_states[to] or to.init or __NULL__)(to)
    initialized_states[to] = __NULL__

    stack[#stack+stack_offset] = to
    return (to.enter or __NULL__)(to, pre, ...)
end

function GS.init(to, ...)
    change_state(0, to, ...)
end

function GS.switch(to, ...)
    assert(to, "Missing argument: Gamestate to switch to")
    assert(to ~= GS, "Can't call switch with colon operator")

    local varargs = {...}
    local from = stack[#stack]
    from.update = function(_, dt)
        (from.leave or __NULL__)(from)
        change_state(0, to, unpack(varargs))
        to:update(dt)
    end
end

function GS.push(to, ...)
    assert(to, "Missing argument: Gamestate to switch to")
    assert(to ~= GS, "Can't call push with colon operator")

    local varargs = {...}
    local from = stack[#stack]
    local oldUpdate = from.update
    from.update = function(_, dt)
        change_state(1, to, unpack(varargs))
        from.update = oldUpdate
        to:update(dt)
    end
end

function GS.pop(...)
    assert(#stack > 1, "No more states to pop!")

    local varargs = {...}
    local pre, to = stack[#stack], stack[#stack-1]

    pre.update = function(_, dt)
        stack[#stack] = nil
        ;(pre.leave or __NULL__)(pre)
        ;(to.resume or __NULL__)(to, pre, unpack(varargs))
        to:update(dt)
    end
end

function GS.current()
    return stack[#stack]
end

-- fetch event callbacks from love.handlers
local all_callbacks = { 'draw', 'errhand', 'update' }
for k in pairs(love.handlers) do
    all_callbacks[#all_callbacks+1] = k
end

function GS.registerEvents(callbacks)
    local registry = {}
    callbacks = callbacks or all_callbacks
    for _, f in ipairs(callbacks) do
        registry[f] = love[f] or __NULL__
        love[f] = function(...)
            registry[f](...)
            return GS[f](...)
        end
    end
end

-- forward any undefined functions
setmetatable(GS, {__index = function(_, func)
    return function(...)
        return (stack[#stack][func] or __NULL__)(stack[#stack], ...)
    end
end})

return GS
