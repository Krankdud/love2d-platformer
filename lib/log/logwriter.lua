local outfile = ...

local channel = love.thread.getChannel("__LOGGER__")
local fp = io.open(outfile, "a")

local msg = channel:demand()
while msg ~= "__EXIT__" do
  fp:write(msg)
  msg = channel:demand()
end
fp:close()
