--- Returns a wrapper function that will return true until an elapsed amount of time has passed
-- Useful for adding a buffer to inputs.
-- @param fn Function that will be buffered. The function should return true or false
-- @param time The amount of time before the buffer should return false
-- @return A function that takes delta time as an argument and returns true or false
--         if the condition has been met within the buffer time
local function buffer(fn, time)
    local elapsed = time
    return function(dt, ...)
        if fn(...) then
            elapsed = 0
        end

        if elapsed <= time then
            elapsed = elapsed + dt
        end

        return elapsed <= time
    end
end

return buffer
