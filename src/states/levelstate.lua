local class = require "lib.middleclass"

local State = require "src.states.state"

local LevelState = class("LevelState", State)
function LevelState:initialize()
	State.initialize(self)
end

return LevelState
