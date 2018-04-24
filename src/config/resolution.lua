--- Table containing a list of resolutions.
-- The current resolution can be obtained through Resolution.currentResolution.

local Resolution = {
    {
        width = 640,
        height = 360
    },
    {
        width = 960,
        height = 540
    },
    {
        width = 1280,
        height = 720
    },
    {
        width = 1920,
        height = 1080
    }
}

Resolution.currentResolution = 2
Resolution.fullscreen = false
Resolution.vsync = false

--- Increases the window resolution.
-- @return True if resolution changed.
function Resolution:increase()
    local newRes = math.min(#self, self.currentResolution + 1)
    return self:set(newRes)
end

--- Decreases the window resolution.
-- @return True if resolution changed.
function Resolution:decrease()
    local newRes = math.max(1, self.currentResolution - 1)
    return self:set(newRes)
end

--- Sets the window resolution.
-- @param res Index into the table of resolutions
-- @param force Forces the resolution to change
-- @return True if resolution changed.
function Resolution:set(res, force)
    assert(res >= 1, "Invalid resolution")
    assert(res <= #self, "Invalid resolution")
    if res ~= self.currentResolution or force then
        love.window.setMode(self[res].width, self[res].height, {
            vsync = self.vsync,
            fullscreen = self.fullscreen,
            fullscreentype = "desktop"
        })
        self.currentResolution = res
        return true
    end
    return false
end

--- Forcefully resizes the window to the current resolution.
-- Useful when fullscreen or vsync has changed.
-- @return True if resolution changed
function Resolution:reset()
    return self:set(self.currentResolution, true)
end

--- Returns the current resolution.
function Resolution:get()
    return self[self.currentResolution]
end

return Resolution
