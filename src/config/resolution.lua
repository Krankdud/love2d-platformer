--- Table containing a list of resolutions.
-- The current resolution can be obtained through Resolution.currentResolution.

local Resolution = {
    {
        width = 320,
        height = 240
    },
    {
        width = 640,
        height = 480
    },
    {
        width = 800,
        height = 600
    },
    {
        width = 960,
        height = 720
    },
    {
        width = 1024,
        height = 768,
    },
    {
        width = 1280,
        height = 960
    },
    {
        width = 1440,
        height = 1080
    },
    {
        width = 1600,
        height = 1200
    }
}

Resolution.currentResolution = 2

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
-- @return True if resolution changed.
function Resolution:set(res)
    assert(res >= 1, "Invalid resolution")
    assert(res <= #self, "Invalid resolution")
    if res ~= self.currentResolution then
        love.window.setMode(self[res].width, self[res].height, { vsync = false })
        self.currentResolution = res
        return true
    end
    return false
end

--- Returns the current resolution.
function Resolution:get()
    return self[self.currentResolution]
end

return Resolution
