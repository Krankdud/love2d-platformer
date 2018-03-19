local LimitVelocitySystem = require "src.systems.limitvelocity"

describe("LimitVelocitySystem", function()
	local entity

	setup(function()
		entity = {}
		entity.velocity = {}
	end)

	before_each(function()
		entity.velocity.x = 0
		entity.velocity.y = 0
	end)

	describe("processes an entity", function()
		describe("minVelocity component is present", function()
			setup(function()
				entity.minVelocity = {}
				entity.minVelocity.x = -1
				entity.minVelocity.y = -1
			end)

			teardown(function()
				entity.minVelocity = nil
			end)

			it("sets velocity to the minimum if velocity is under the minimum", function()
				entity.velocity.x = -10
				entity.velocity.y = -10
				LimitVelocitySystem:process(entity, 0)
				assert.is.equal(entity.velocity.x, -1)
				assert.is.equal(entity.velocity.y, -1)
			end)

			it("doesn't set velocity to minimum if velocity is above the minimum", function()
				entity.velocity.x = 10
				entity.velocity.y = 10
				LimitVelocitySystem:process(entity, 0)
				assert.is.equal(entity.velocity.x, 10)
				assert.is.equal(entity.velocity.y, 10)
			end)
		end)

		describe("maxVelocity component is present", function()
			setup(function()
				entity.maxVelocity = {}
				entity.maxVelocity.x = 1
				entity.maxVelocity.y = 1
			end)

			teardown(function()
				entity.maxVelocity = nil
			end)

			it("sets velocity to the maximum if velocity is above the maximum", function()
				entity.velocity.x = 10
				entity.velocity.y = 10
				LimitVelocitySystem:process(entity, 0)
				assert.is.equal(entity.velocity.x, 1)
				assert.is.equal(entity.velocity.y, 1)
			end)

			it("doesn't set velocity to maximum if velocity is under the maximum", function()
				entity.velocity.x = -10
				entity.velocity.y = -10
				LimitVelocitySystem:process(entity, 0)
				assert.is.equal(entity.velocity.x, -10)
				assert.is.equal(entity.velocity.y, -10)
			end)
		end)
	end)
end)
