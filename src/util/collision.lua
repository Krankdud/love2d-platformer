--- Utility functions for helping with collision detection

local function filterTilemap(_, other)
    if other.properties ~= nil then
        return "slide"
    end
    return nil
end


local Collision = {}

--- Check if there will be a collision with a solid tile at a location
-- @param world bump world
-- @param item item that is looking for a collision
-- @param x x position where the item is checking
-- @param y y position where the item is checking
function Collision.isSolid(world, item, x, y)
    local _, _, _, len = world:check(item, x, y, filterTilemap)
    return len > 0
end

return Collision
