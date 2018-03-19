local PositionSystem = require "src.systems.position"

describe("PositionSystem", function()
	local entity

	setup(function()
		entity = {}
		entity.position = {}
	end)

	before_each(function()
		entity.position.x = 1
		entity.position.y = 1
		entity.position.subpixelX = 0
		entity.position.subpixelY = 0
		entity.position.prevX = 0
		entity.position.prevY = 0
	end)

	describe("when given the x axis", function()
		local ps

		setup(function()
			ps = PositionSystem:new("x")
		end)

		it("ps.axis is set to x", function()
			assert.are.equal(ps.axis, "x")
		end)


		describe("PositionSystem:process", function()
			it("sets entity.position.x to an integer", function()
				entity.position.x = 2.5
				ps:process(entity, 0)
				assert.are.equal(entity.position.x, 2)
			end)
	
			it("sets entity.position.subpixelX", function()
				entity.position.x = 2.5
				ps:process(entity, 0)
				assert.are.equal(entity.position.subpixelX, 0.5)
			end)

			it("increments entity.position.x when entity.position.subpixelX >= 1", function()
				entity.position.x = 1.5
				ps:process(entity, 0)
				entity.position.x = 1.5
				ps:process(entity, 0)
				assert.are.equal(entity.position.x, 2)
			end)

			it("decrements entity.position.x when entity.position.subpixelX <= -1", function()
				entity.position.x = -1.5
				ps:process(entity, 0)
				entity.position.x = -1.5
				ps:process(entity, 0)
				assert.are.equal(entity.position.x, -2)
			end)

			it("sets prevX", function()
				entity.position.x = 2
				ps:process(entity, 0)
				assert.are.equal(entity.position.prevX, 2)
			end)

			it("doesn't modify y", function()
				entity.position.y = 2.5
				ps:process(entity, 0)
				assert.are.equal(entity.position.y, 2.5)
			end)
		end)
	end)
	
	describe("when given the y axis", function()
		local ps

		setup(function()
			ps = PositionSystem:new("y")
		end)

		it("ps.axis is set to y", function()
			assert.are.equal(ps.axis, "y")
		end)


		describe("PositionSystem:process", function()
			it("sets entity.position.y to an integer", function()
				entity.position.y = 2.5
				ps:process(entity, 0)
				assert.are.equal(entity.position.y, 2)
			end)
	
			it("sets entity.position.subpixelY", function()
				entity.position.y = 2.5
				ps:process(entity, 0)
				assert.are.equal(entity.position.subpixelY, 0.5)
			end)

			it("increments entity.position.y when entity.position.subpixelY >= 1", function()
				entity.position.y = 1.5
				ps:process(entity, 0)
				entity.position.y = 1.5
				ps:process(entity, 0)
				assert.are.equal(entity.position.y, 2)
			end)

			it("decrements entity.position.y when entity.position.subpixelY <= -1", function()
				entity.position.y = -1.5
				ps:process(entity, 0)
				entity.position.y = -1.5
				ps:process(entity, 0)
				assert.are.equal(entity.position.y, -2)
			end)

			it("sets prevY", function()
				local prevY = entity.position.y
				entity.position.y = 2
				ps:process(entity, 0)
				assert.are.equal(entity.position.prevY, 2)
			end)

			it("doesn't modify x", function()
				entity.position.x = 2.5
				ps:process(entity, 0)
				assert.are.equal(entity.position.x, 2.5)
			end)
		end)
	end)
end)
