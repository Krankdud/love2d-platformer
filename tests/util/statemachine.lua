local StateMachine = require "src.util.statemachine"

describe("StateMachine", function()
	local sm
	local entity

	setup(function()
		entity = {}
		entity.enter = function(self) end
		entity.update = function(self) end
		entity.draw = function(self) end
	end)

	before_each(function()
		sm = StateMachine:new(entity, {
			enter = "enter",
			update = "update",
			draw = "draw"
		})
	end)

	it("addState adds a state to the machine", function()
		local state = {}
		sm:addState("id", state)
		assert.is.equal(sm.states["id"], state)
	end)

	describe("setState", function()
		before_each(function()
			sm:addState("id", { enter = "enter" })
		end)

		it("sets the current state", function()
			sm:setState("id")
			assert.is.equal(sm.currentId, "id")
		end)

		it("calls enter", function()
			local s = spy.on(entity, "enter")
			sm:setState("id")
			assert.spy(s).was_called()
		end)
	end)

	describe("update", function()
		before_each(function()
			entity.newUpdate = function(self) end
			entity.returnUpdate = function(self) 
				return "default"
			end

			sm:addState("new", {
				update = "newUpdate",
			})
			sm:addState("return", {
				update = "returnUpdate",
			})
			sm:addState("noUpdate", {})
		end)

		it("calls the default update method if currentId is nil", function()
			local s = spy.on(entity, "update")

			sm.currentId = nil
			sm:update()
			assert.spy(s).was_called()
		end)

		it("calls the default update method if the current state has no update method", function()
			local s = spy.on(entity, "update")

			sm.currentId = "noUpdate"
			sm:update()
			assert.spy(s).was_called()
		end)

		it("calls the correct update method for a state", function()
			local s = spy.on(entity, "newUpdate")

			sm.currentId = "new"
			sm:update()
			assert.spy(s).was_called()
		end)

		it("calls setState when a new state is returned", function()
			local s = spy.on(sm, "setState")

			sm.currentId = "return"
			sm:update()
			assert.spy(s).was_called_with(match.is.ref(sm), "default")
			assert.is.equal(sm.currentId, "default")
		end)
	end)

	describe("draw", function()
		before_each(function()
			entity.newDraw = function(self) end

			sm:addState("new", {
				draw = "newDraw",
			})
			sm:addState("noDraw", {})
		end)

		it("calls the default draw function if the current state is nil", function()
			local s = spy.on(entity, "draw")

			sm.currentId = nil
			sm:draw()
			assert.spy(s).was_called()
		end)

		it("calls the default draw method if the current state has no draw method", function()
			local s = spy.on(entity, "draw")

			sm.currentId = "noDraw"
			sm:draw()
			assert.spy(s).was_called()
		end)

		it("calls the correct draw method for a state", function()
			local s = spy.on(entity, "newDraw")

			sm.currentId = "new"
			sm:draw()
			assert.spy(s).was_called()
		end)
	end)
end)
