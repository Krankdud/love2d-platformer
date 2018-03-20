local ScreenScaler = require "src.screenscaler"

describe("ScreenScaler", function()
	setup(function()
		_G.love = {
			graphics = {
				getWidth = function() return 640 end,
				getHeight = function() return 480 end,

				newCanvas = function()
					return {
						setFilter = function() return end
					}
				end,
				setCanvas = function() end,

				clear = function() end,
				setColor = function() end,
				getBlendMode = function() return "alpha", "multiplied" end,
				setBlendMode = function() end,
				draw = function() end
			},
			mouse = {
				getX = function() return 32 end,
				getY = function() return 32 end
			}
		}
	end)

	describe(":init", function()
		it("creates a canvas with given width and height", function()
			spy.on(love.graphics, "newCanvas")

			ScreenScaler:init(320, 240)
			assert.spy(love.graphics.newCanvas).was.called_with(320, 240)
		end)

		it("sets the scale to maintain the aspect ratio", function()
			ScreenScaler:init(320, 120)
			assert.is.equal(ScreenScaler.scale.x, ScreenScaler.scale.y)
			assert.is.equal(ScreenScaler.scale.x, 2)
			assert.is.equal(ScreenScaler.scale.y, 2)
		end)

		it("doesn't maintain aspect ratio when keepAspectRatio is false", function()
			ScreenScaler:init(320, 120, false)
			assert.is_not.equal(ScreenScaler.scale.x, ScreenScaler.scale.y)
			assert.is.equal(ScreenScaler.scale.x, 2)
			assert.is.equal(ScreenScaler.scale.y, 4)
		end)

		it("position is at 0,0 if the aspect ratio matches the window", function()
			ScreenScaler:init(320, 240)
			assert.is.equal(ScreenScaler.position.x, 0)
			assert.is.equal(ScreenScaler.position.y, 0)
		end)

		it("position is at 0,0 if aspect ratio isn't maintained", function()
			ScreenScaler:init(320, 120, false)
			assert.is.equal(ScreenScaler.position.x, 0)
			assert.is.equal(ScreenScaler.position.y, 0)
		end)

		it("position.x is centered if the width isn't scaled as much as the height", function()
			ScreenScaler:init(240, 240)
			assert.is.equal(ScreenScaler.position.x, 80)
			assert.is.equal(ScreenScaler.position.y, 0)
		end)

		it("position.y is centered if the height isn't scaled as much as the width", function()
			ScreenScaler:init(320, 120)
			assert.is.equal(ScreenScaler.position.x, 0)
			assert.is.equal(ScreenScaler.position.y, 120)
		end)
	end)

	describe(":start", function()
		setup(function()
			ScreenScaler:init(320, 240)
		end)

		it("sets the canvas to the screen scaler's canvas", function()
			spy.on(love.graphics, "setCanvas")
			ScreenScaler:start()
			assert.spy(love.graphics.setCanvas).was.called_with(ScreenScaler.canvas)
		end)
	end)

	describe(":finish", function()
		setup(function()
			ScreenScaler:init(320, 240)
		end)

		it("sets the canvas to the default canvas", function()
			spy.on(love.graphics, "setCanvas")
			ScreenScaler:finish()
			assert.spy(love.graphics.setCanvas).was.called_with()
		end)
	end)

	describe(":draw", function()
		setup(function()
			ScreenScaler:init(320, 240)
		end)

		it("draws the canvas with the corrent parameters", function()
			spy.on(love.graphics, "draw")
			ScreenScaler:draw()
			assert.spy(love.graphics.draw).was.called_with(ScreenScaler.canvas, 0, 0, 0, 2, 2)
		end)
	end)

	describe(":getMouseX", function()
		setup(function()
			ScreenScaler:init(320, 240)
		end)

		it("converts x to correct ingame coordinate", function()
			assert.is.equal(ScreenScaler:getMouseX(), 16)
		end)
	end)

	describe(":getMouseY", function()
		setup(function()
			ScreenScaler:init(320, 240)
		end)

		it("converts y to correct ingame coordinate", function()
			assert.is.equal(ScreenScaler:getMouseY(), 16)
		end)
	end)
end)
