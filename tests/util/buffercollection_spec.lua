local BufferCollection = require "src.util.buffercollection"

describe("BufferCollection", function()
    local bc

    before_each(function()
        bc = BufferCollection:new()
    end)

    it(":add adds a buffer", function()
        bc:add("name", function() end, 10)
        assert.is_not.equal(bc.buffers["name"], nil)
        assert.is_not.equal(bc.results["name"], nil)
    end)

    it(":updateAll updates every buffer", function()
        bc:add("buf1", function() return true end, 10)
        bc:add("buf2", function() return true end, 10)
        bc:add("buf3", function() return true end, 10)

        assert.is_false(bc:get("buf1"))
        assert.is_false(bc:get("buf2"))
        assert.is_false(bc:get("buf3"))

        bc:updateAll(1)

        assert.is_true(bc:get("buf1"))
        assert.is_true(bc:get("buf2"))
        assert.is_true(bc:get("buf3"))
    end)

    it(":update only updates a single buffer", function()
        bc:add("buf1", function() return true end, 10)
        bc:add("buf2", function() return true end, 10)
        bc:add("buf3", function() return true end, 10)

        assert.is_false(bc:get("buf1"))
        assert.is_false(bc:get("buf2"))
        assert.is_false(bc:get("buf3"))

        bc:update("buf1", 1)

        assert.is_true(bc:get("buf1"))
        assert.is_false(bc:get("buf2"))
        assert.is_false(bc:get("buf3"))
    end)
end)
