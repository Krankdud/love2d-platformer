local class = require "lib.middleclass"
local gamestate = require "lib.hump.gamestate"

local Game = require "src.game"
local Menu = require "src.menu"
local State = require "src.states.state"

-- Systems
local DrawSystem               = require "src.systems.draw"
local ScreenScalerStartSystem  = require "src.systems.screenscalerstart"
local ScreenScalerFinishSystem = require "src.systems.screenscalerfinish"
local UpdateSystem             = require "src.systems.update"

local MainMenuState = class("MainMenuState", State)
function MainMenuState:initialize()
    State.initialize(self,
        UpdateSystem:new(),
        ScreenScalerStartSystem:new(),
        DrawSystem:new(),
        ScreenScalerFinishSystem:new()
    )

    self.menu = Menu:new({
        {
            title = "New Game",
            caption = "Start a new game",
            confirm = function()
                local game = Game:new()
                game:save()
                gamestate.switch(self.factory.create("LevelIntro", game))
            end
        },
        {
            title = "Continue",
            caption = "Continue your previous game",
            confirm = function()
                local info = love.filesystem.getInfo("save.dat")
                if info then
                    local game = Game:new()
                    game:load()
                    gamestate.switch(self.factory.create("LevelIntro", game))
                end
            end
        },
        {
            title = "Options",
            caption = "Change resolution, volume, or controls",
            confirm = function()
                gamestate.push(self.factory.create("OptionsMenu"))
            end
        },
        {
            title = "Exit",
            caption = "Exit the game",
            confirm = function()
                love.event.quit()
            end
        }
    },
    {
        y = 240
    })

    self.world:addEntity(self.menu)
end

return MainMenuState
