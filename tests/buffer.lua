local buffer = require "src.buffer"

describe("buffer", function()
	local b
	setup(function()
		b = buffer(function(cond) return cond end, 10)
	end)

	it("returns true immediately when the condition is true", function()
		assert.is_true(b(1, true))
	end)

	it("returns true after time has elapsed, but before the limit", function()
		b(1, true)
		assert.is_true(b(4, false))
	end)

	it("returns false after time has elapsed past the limit", function()
		b(1, true)
		assert.is_false(b(20, false))
	end)
end)
