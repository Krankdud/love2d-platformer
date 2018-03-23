local CollisionResolutionSystem = require "src.systems.collisionresolution"

describe("CollisionResolutionSystem", function()
	local entity

	setup(function()
		entity = {}
		entity.aabb = {}
	end)

	before_each(function()
		entity.aabb.collisions = nil
	end)

	describe("entity has an onCollision function", function()
		setup(function()
			entity.onCollision = function(entity, collision) end
		end)

		teardown(function()
			entity.onCollision = nil
		end)

		it("onCollision is called when collisions exist", function()
			local collision = {}
			entity.aabb.collisions = { collision }
			spy.on(entity, "onCollision")
			CollisionResolutionSystem:process(entity, 0)
			assert.spy(entity.onCollision).was_called_with(match._, collision)
		end)
	end)

	it("aabb.collisions is set to nil after resolving collisions", function()
		local collision = {}
		entity.aabb.collisions = { collision }
		CollisionResolutionSystem:process(entity, 0)
		assert.is.equal(entity.aabb.collisions, nil)
	end)
end)
