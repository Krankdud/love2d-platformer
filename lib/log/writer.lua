local outfile, flush = ...

local channel = love.thread.getChannel("__LOGGER__")
local fp = io.open(outfile, "a")

local line = 0
local msg = channel:demand()
while msg ~= "__EXIT__" do
  fp:write(msg)

  line = line + 1
  if line == flush then
    fp:flush()
    line = 0
  end

  msg = channel:demand()
end
fp:close()
