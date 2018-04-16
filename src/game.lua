--- Stores data about the current game session.

local class = require "lib.middleclass"

local Game = class("Game")
function Game:initialize()
    self.level = 1
end

--- Saves the game.
function Game:save()
end

--- Loads the game.
function Game:load()
end

--- Returns the filename of the current level without the extension.
-- @return Filename of current level
function Game:getCurrentLevel()
    local levelOrder = assets.levelorder
    return levelOrder[self.level]
end

return Game
