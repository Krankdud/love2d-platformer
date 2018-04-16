--- Stores data about the current game session.

local bitser = require "lib.bitser"
local class = require "lib.middleclass"

local Game = class("Game")
function Game:initialize()
    self.level = 1
end

--- Saves the game.
function Game:save()
    local data = {
        level = self.level
    }

    bitser.dumpLoveFile("save.dat", data)
end

--- Loads the game.
function Game:load()
    local data = bitser.loadLoveFile("save.dat")

    self.level = data.level
end

--- Returns the filename of the current level without the extension.
-- @return Filename of current level
function Game:getCurrentLevel()
    local levelOrder = assets.levelorder
    return levelOrder[self.level]
end

return Game
