local IntegrateAxisSystem = require "src.systems.integrateaxis"

describe("IntegrateAxisSystem", function()
	local entity
	local ias

	setup(function()
		entity = {}
		entity.position = {}
		entity.velocity = {}
		ias = IntegrateAxisSystem:new("x", "position", "velocity")
	end)

	before_each(function()
		entity.position.x = 0
		entity.velocity.x = 0
	end)

	describe("when given x, position, and velocity as parameters", function()
		it("axis, integral, and differential are properly set", function()
			assert.is.equal(ias.axis, "x")
			assert.is.equal(ias.integral, "position")
			assert.is.equal(ias.differential, "velocity")
		end)

		it("accepts entity with components", function()
			assert.is_true(ias:filter(entity))
		end)

		it("rejects entity without all components", function()
			local e = {}
			assert.is_not_true(ias:filter(e))
			e.position = {}
			assert.is_not_true(ias:filter(e))
		end)

		it("adds velocity to position", function()
			assert.is_true(ias:filter(entity))
			entity.velocity.x = 4
			ias:process(entity, 0)
			assert.is.equal(entity.position.x, 4)
		end)
	end)
end)
