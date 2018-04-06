--- Collection of simple buffers.
-- Buffers in these collections only take dt as an argument.

local class = require "lib.middleclass"

local buffer = require "src.util.buffer"

local BufferCollection = class("BufferCollection")
--- Initializes the collection.
function BufferCollection:initialize()
    self.buffers = {}
    self.results = {}
end

--- Add a buffer to the collection.
-- If the buffer already exists, it will be overwritten by the new buffer.
-- @param name Name of the buffer
-- @param fn Function to buffer
-- @param time The amount of time before the buffer returns false
function BufferCollection:add(name, fn, time)
    self.buffers[name] = buffer(fn, time)
    self.results[name] = false
end

--- Updates all of the buffers in the collection.
-- @param dt Delta time
function BufferCollection:updateAll(dt)
    for name, fn in pairs(self.buffers) do
        self.results[name] = fn(dt)
    end
end

--- Updates a single buffer in the collection.
-- @param name Name of the buffer
-- @param dt Delta time
function BufferCollection:update(name, dt)
    self.results[name] = self.buffers[name](dt)
end

--- Obtain the result of a buffer.
-- @param name Name of the buffer to retrieve.
-- @return Boolean
function BufferCollection:get(name)
    return self.results[name]
end

return BufferCollection
