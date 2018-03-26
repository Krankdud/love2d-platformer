local math = math

local class = require "lib.middleclass"
local lume = require "lib.lume"

local buffer = require "src.buffer"
local input = require "src.input"

local Player = class("Player")
function Player:initialize(x, y, collisionWorld)
	self.position = {x = x, y = y}

	self.aabb = {width = 16, height = 16, world = collisionWorld}
	self.collideWithLevel = true

	self.acceleration = {x = 0, y = 0.5}
	self.velocity = {x = 0, y = 0}
	self.minVelocity = {x = -4, y = -4000}
	self.maxVelocity = {x = 4, y = 8}

	collisionWorld:add(self, self.position.x, self.position.y, self.aabb.width, self.aabb.height)

	self.checkJumpPressed = buffer(function() 
		return input:pressed("jump")
	end, 10)
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

	if self.checkJumpPressed(1) and self.aabb.onGround then
		self.velocity.y = -8
		self.aabb.onGround = false
	end
end

function Player:draw()
	love.graphics.setColor(255, 255, 0)
	love.graphics.rectangle("fill", self.position.x, self.position.y, self.aabb.width, self.aabb.height)
end

return Player
