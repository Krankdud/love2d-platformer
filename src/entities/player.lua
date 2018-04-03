local math = math

local class = require "lib.middleclass"
local log = require "lib.log"
local lume = require "lib.lume"
local Timer = require "lib.hump.timer"

local buffer = require "src.util.buffer"
local collision = require "src.util.collision"
local input = require "src.input"
local StateMachine = require "src.util.statemachine"

local Player = class("Player")
function Player:initialize(x, y, collisionWorld)
    self.position = {x = x, y = y}

    self.aabb = {width = 16, height = 16, world = collisionWorld}
    self.collideWithLevel = true

    self.acceleration = {x = 0, y = 0.3}
    self.velocity = {x = 0, y = 0}
    self.minVelocity = {x = -2.5, y = -4000}
    self.maxVelocity = {x = 2.5, y = 8}

    collisionWorld:add(self, self.position.x, self.position.y, self.aabb.width, self.aabb.height)

    self.bufferJumpPressed = buffer(function()
        return input:pressed("jump")
    end, 8)
    self.bufferOnGround = buffer(function()
        return self.aabb.onGround
    end, 8)

    self.stateMachine = StateMachine:new(self, {
        enter = "defaultEnter",
        update = "defaultUpdate",
        draw = "defaultDraw"
    })
    self.stateMachine:addState("climb", {
        enter = "climbEnter",
        update = "climbUpdate"
    })
    self.stateMachine:addState("wallJump", {
        enter = "wallJumpEnter",
        update = "wallJumpUpdate"
    })
end

function Player:update(dt)
    self.stateMachine:update(dt)
end

function Player:draw()
    self.stateMachine:draw()
end

function Player:defaultUpdate()
    if self.velocity.y ~= 0 then
        self.aabb.onGround = false
    end

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

    if moveX ~= 0 and moveY == -1 and collision.isSolid(self.aabb.world, self, self.position.x + moveX, self.position.y) then
        log.debug("switching state to climb")
        return "climb"
    end

    local onGround = self.bufferOnGround(1)
    if self.bufferJumpPressed(1) and onGround and self.velocity.y >= 0 then
        self.velocity.y = -6
        self.aabb.onGround = false
        self.bufferJumpPressed(999)
    end

    if not input:down("jump") and self.velocity.y < 0 then
        self.velocity.y = self.velocity.y / 1.5
    end
end

function Player:defaultDraw()
    love.graphics.setColor(1.0, 1.0, 0.0)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.aabb.width, self.aabb.height)
end

function Player:defaultEnter()
    self.acceleration.x = 0
    self.acceleration.y = 0.3
    self.minVelocity.x = -2.5
    self.minVelocity.y = -4000
    self.maxVelocity.x = 2.5
    self.maxVelocity.y = 8
end

function Player:climbUpdate()
    local moveX, moveY = input:get("movePair")

    if moveY ~= -1 then
        log.debug("switching state to default")
        return "default"
    end

    if not collision.isSolid(self.aabb.world, self, self.position.x + moveX, self.position.y) then
        log.debug("switching state to default")
        return "default"
    end

    if self.bufferJumpPressed(1) then
        self.velocity.x = 2.5 * -moveX
        self.bufferJumpPressed(999)
        return "wallJump"
    end
end

function Player:climbEnter()
    self.acceleration.x = 0
    self.acceleration.y = -1
    self.velocity.y = 0
    self.minVelocity.y = -3
end

function Player:wallJumpUpdate()
    if not input:down("jump") and self.velocity.y < 0 then
        self.velocity.y = self.velocity.y / 1.5
    end
end

function Player:wallJumpEnter()
    self.acceleration.x = 0
    self.acceleration.y = 0.3
    self.minVelocity.x = -2.5
    self.minVelocity.y = -4000
    self.maxVelocity.x = 2.5
    self.maxVelocity.y = 8

    self.velocity.y = -6

    Timer.after(0.15, function() self.stateMachine:setState("default") end)
end

return Player
