local math = math

local class = require "lib.middleclass"
local lume = require "lib.lume"

local input = require "src.input"

local Player = class("Player")
function Player:initialize(x, y, collisionWorld)
	self.position = {x = x, y = y}

	self.aabb = {width = 16, height = 16, world = collisionWorld}
	self.collideWithLevel = true

	self.acceleration = {x = 0, y = 0}
	self.velocity = {x = 0, y = 0}
	self.minVelocity = {x = -4, y = -4}
	self.maxVelocity = {x = 4, y = 4}

	collisionWorld:add(self, self.position.x, self.position.y, self.aabb.width, self.aabb.height)
end

function Player:onCollision(collision)
end

function Player:update(dt)
	local moveX, moveY = input:get("movePair")
	if moveX ~= 0 then
		self.acceleration.x = moveX
	else
		local deaccel
		if math.abs(self.velocity.x) > 1 then
			deaccel = 1
		else
			deaccel = math.abs(self.velocity.x)
		end

		self.acceleration.x = deaccel * -lume.sign(self.velocity.x)
	end

	if moveY ~= 0 then
		self.acceleration.y = moveY
	else
		local deaccel
		if math.abs(self.velocity.y) > 1 then
			deaccel = 1
		else
			deaccel = math.abs(self.velocity.y)
		end

		self.acceleration.y = deaccel * -lume.sign(self.velocity.y)
	end
end

function Player:draw()
	love.graphics.setColor(255, 255, 0)
	love.graphics.rectangle("fill", self.position.x, self.position.y, self.aabb.width, self.aabb.height)
end

return Player
