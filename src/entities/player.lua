local math = math

local class = require "lib.middleclass"
local log = require "lib.log"
local lume = require "lib.lume"
local Timer = require "lib.hump.timer"

local buffer = require "src.util.buffer"
local collision = require "src.util.collision"
local input = require "src.input"
local StateMachine = require "src.util.statemachine"

local BONK_PENALTY = 0.3

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
    self.bufferNearLeftWall = buffer(function()
        return collision.isSolid(self.aabb.world, self, self.position.x - 4, self.position.y)
    end, 4)
    self.bufferNearRightWall = buffer(function()
        return collision.isSolid(self.aabb.world, self, self.position.x + 4, self.position.y)
    end, 4)

    self.stateMachine = StateMachine:new(self, {
        enter = "defaultEnter",
        update = "defaultUpdate",
        draw = "defaultDraw"
    })
    self.stateMachine:addState("climb", {
        enter = "climbEnter",
        update = "climbUpdate"
    })
    self.stateMachine:addState("ceiling", {
        enter = "ceilingEnter",
        update = "ceilingUpdate"
    })
    self.stateMachine:addState("wallJump", {
        enter = "wallJumpEnter",
        update = "wallJumpUpdate"
    })
    self.stateMachine:addState("ceilingHang", {
        enter = "ceilingHangEnter"
    })

    self.climbDirection = 1
    self.canClimb = true
end

function Player:update(dt)
    self.stateMachine:update(dt)
end

function Player:draw()
    self.stateMachine:draw()
end

function Player:defaultUpdate()
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

    if moveX ~= 0 and moveY == -1 and self.canClimb then
        if collision.isSolid(self.aabb.world, self, self.position.x + moveX, self.position.y) then
            self.climbDirection = moveX
            return "climb"
        elseif collision.isSolid(self.aabb.world, self, self.position.x, self.position.y - 1) then
            self.ceilingDirection = moveX
            self.aabb.onCeiling = false
            return "ceiling"
        end
    end

    -- Handle buffers
    local onGround = self.bufferOnGround(1)
    local jumpPressed = self.bufferJumpPressed(1)
    local nearLeftWall = self.bufferNearLeftWall(1)
    local nearRightWall = self.bufferNearRightWall(1)
    -- Jumping
    if jumpPressed and onGround and self.velocity.y >= 0 then
        self.velocity.y = -6
        self.aabb.onGround = false
        self.bufferJumpPressed(999)
        self.bufferOnGround(999)
    end

    -- Walljumping
    if jumpPressed and not onGround and (nearLeftWall or nearRightWall) then
        local direction = 0
        if nearLeftWall then
            direction = 1
        elseif nearRightWall then
            direction = -1
        end
        self.velocity.x = 2.5 * direction
        self.bufferJumpPressed(999)
        return "wallJump"
    end

    if not input:down("jump") and self.velocity.y < 0 then
        self.velocity.y = self.velocity.y / 1.5
    end

    if self.aabb.onCeiling then
        return "ceilingHang"
    end
end

function Player:defaultDraw()
    love.graphics.setColor(1.0, 1.0, 0.0)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.aabb.width, self.aabb.height)
end

function Player:defaultEnter()
    log.debug("switching player state to default")
    self.acceleration.x = 0
    self.acceleration.y = 0.3
    self.minVelocity.x = -2.5
    self.minVelocity.y = -4000
    self.maxVelocity.x = 2.5
    self.maxVelocity.y = 8
end

function Player:climbUpdate()
    local moveX, moveY = input:get("movePair")

    if moveX ~= self.climbDirection or moveY ~= -1 then
        return "default"
    end

    if not collision.isSolid(self.aabb.world, self, self.position.x + self.climbDirection, self.position.y) then
        return "default"
    end

    if collision.isSolid(self.aabb.world, self, self.position.x, self.position.y - 1) then
        self.canClimb = false
        Timer.after(BONK_PENALTY, function()
            self.canClimb = true
        end)
        return "default"
    end

    if self.bufferJumpPressed(1) then
        self.velocity.x = 2.5 * -self.climbDirection
        self.bufferJumpPressed(999)
        return "wallJump"
    end
end

function Player:climbEnter()
    log.debug("switching player state to climb")
    self.acceleration.x = 0
    self.acceleration.y = -1
    self.velocity.y = 0
    self.minVelocity.y = -3
end

function Player:ceilingUpdate()
    local moveX, moveY = input:get("movePair")

    if moveX ~= self.ceilingDirection or moveY ~= -1 then
        return "default"
    end

    if not collision.isSolid(self.aabb.world, self, self.position.x, self.position.y - 1) then
        return "default"
    end

    if collision.isSolid(self.aabb.world, self, self.position.x + self.ceilingDirection, self.position.y) then
        self.canClimb = false
        Timer.after(BONK_PENALTY, function()
            self.canClimb = true
        end)
        return "default"
    end
end

function Player:ceilingEnter()
    log.debug("switching player state to ceiling")
    self.acceleration.x = self.ceilingDirection
    self.acceleration.y = 0
    self.minVelocity.x = -2.5
    self.minVelocity.y = -4000
    self.maxVelocity.x = 2.5
    self.maxVelocity.y = 8
end

function Player:wallJumpUpdate()
    if not input:down("jump") and self.velocity.y < 0 then
        self.velocity.y = self.velocity.y / 1.5
    end

    if self.velocity.y < 0 and collision.isSolid(self.aabb.world, self, self.position.x, self.position.y + self.velocity.y) then
        return "default"
    end
end

function Player:wallJumpEnter()
    log.debug("switching player state to walljump")
    self.acceleration.x = 0
    self.acceleration.y = 0.3
    self.minVelocity.x = -2.5
    self.minVelocity.y = -4000
    self.maxVelocity.x = 2.5
    self.maxVelocity.y = 8

    self.velocity.y = -6

    Timer.after(0.15, function()
        if self.stateMachine:getState() == "wallJump" then
            self.stateMachine:setState("default")
        end
    end)
end

function Player:ceilingHangEnter()
    log.debug("switching player state to ceilingHang")
    self.acceleration.x = 0
    self.acceleration.y = 0
    self.minVelocity.x = -2.5
    self.minVelocity.y = -4000
    self.maxVelocity.x = 2.5
    self.maxVelocity.y = 8
    self.velocity.y = 0

    Timer.after(0.2, function()
        if self.stateMachine:getState() == "ceilingHang" then
            self.stateMachine:setState("default")
        end
    end)
end

return Player
