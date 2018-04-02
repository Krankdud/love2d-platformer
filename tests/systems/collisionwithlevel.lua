local CollisionWithLevelSystem = require "src.systems.collisionwithlevel"

describe("CollisionWithLevelSystem", function()
    local entity

    setup(function()
        entity = {}
        entity.aabb = {}
        entity.velocity = {}
    end)

    before_each(function()
        entity.velocity.x = 1
        entity.velocity.y = 1
        entity.aabb.collisions = nil
    end)

    it("resets x velocity if there is a collision on the x axis", function()
        local collision = {
            other = { properties = {} },
            normal = { x = 1, y = 0 }
        }
        entity.aabb.collisions = { collision }
        CollisionWithLevelSystem:process(entity, 0)
        assert.is.equal(entity.velocity.x, 0)
    end)

    it("resets y velocity if there is a collision on the x axis", function()
        local collision = {
            other = { properties = {} },
            normal = { x = 0, y = 1 }
        }
        entity.aabb.collisions = { collision }
        CollisionWithLevelSystem:process(entity, 0)
        assert.is.equal(entity.velocity.y, 0)
    end)
end)
