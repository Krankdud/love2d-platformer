local math = math

local class = require "lib.middleclass"
local log = require "lib.log"
local lume = require "lib.lume"
local Timer = require "lib.hump.timer"

local BufferCollection = require "src.util.buffercollection"
local collision = require "src.util.collision"
local input = require "src.input.player"
local StateMachine = require "src.util.statemachine"

local PlayerBullet = require "src.entities.playerbullet"

local BONK_PENALTY = 0.3
local WALLJUMP_SPEED = 4

local Player = class("Player")
function Player:initialize(gameState, x, y, world, collisionWorld)
    self.gameState = gameState
    self.world = world

    self.position = {x = x, y = y}

    self.aabb = {width = 12, height = 12, world = collisionWorld}
    self.collideWithLevel = true

    self.acceleration = {x = 0, y = 0.3}
    self.velocity = {x = 0, y = 0}
    self.minVelocity = {x = -2.5, y = -4000}
    self.maxVelocity = {x = 2.5, y = 8}

    collisionWorld:add(self, self.position.x, self.position.y, self.aabb.width, self.aabb.height)

    self.buffers = BufferCollection:new()

    self.buffers:add("jump", function()
        return input:pressed("jump")
    end, 8)
    self.buffers:add("onGround", function()
        return self.aabb.onGround
    end, 6)
    self.buffers:add("nearLeftWall", function()
        return collision.isSolid(self.aabb.world, self, self.position.x - 4, self.position.y)
    end, 4)
    self.buffers:add("nearRightWall", function()
        return collision.isSolid(self.aabb.world, self, self.position.x + 4, self.position.y)
    end, 4)

    self.state = StateMachine:new(self, {
        enter = "defaultEnter",
        update = "defaultUpdate",
        draw = "defaultDraw"
    })
    self.state:addState("climb", {
        enter = "climbEnter",
        update = "climbUpdate"
    })
    self.state:addState("ceiling", {
        enter = "ceilingEnter",
        update = "ceilingUpdate"
    })
    self.state:addState("wallJump", {
        enter = "wallJumpEnter",
        update = "wallJumpUpdate"
    })
    self.state:addState("ceilingHang", {
        enter = "ceilingHangEnter"
    })
    self.state:addState("wallSlide", {
        enter = "wallSlideEnter",
        update = "wallSlideUpdate"
    })
    self.state:addState("dead", {
        enter = "deadEnter",
        update = "deadUpdate"
    })
    self.state:addState("intro", {
        update = "introUpdate"
    })
    self.state:setState("intro")

    self.direction = "right"
    self.climbDirection = 1
    self.canClimb = true
    self.wallSlideDirection = 0
end

function Player:onCollision(col)
    if self.state:getState() == "dead" then return end

    local other = col.other
    if other.aabb then
        if other.aabb.type == "exit" then
            self.gameState:exit()
        elseif other.aabb.type == "hurt" then
            self.state:setState("dead")
        end
    end
end

--- Called when the level intro is over.
function Player:introDone()
    self.state:setState("default")
end

function Player:update(dt)
    self.buffers:updateAll(1)
    self.state:update(dt)
end

function Player:draw()
    self.state:draw()
end

function Player:defaultUpdate()
    local moveX, moveY = input:get("movePair")
    if moveX ~= 0 then
        self.direction = moveX == 1 and "right" or "left"
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

    local onGround = self.buffers:get("onGround")
    local jumpPressed = self.buffers:get("jump")
    local nearLeftWall = self.buffers:get("nearLeftWall")
    local nearRightWall = self.buffers:get("nearRightWall")
    -- Jumping
    if jumpPressed and onGround and self.velocity.y >= 0 then
        self.velocity.y = -6
        self.aabb.onGround = false
        self.buffers:update("jump", 999)
        self.buffers:update("onGround", 999)
    end

    -- Walljumping
    if jumpPressed and not onGround and (nearLeftWall or nearRightWall) then
        local direction = 0
        if nearLeftWall then
            direction = 1
        elseif nearRightWall then
            direction = -1
        end
        self.velocity.x = WALLJUMP_SPEED * direction
        self.direction = direction == 1 and "right" or "left"
        self.buffers:update("jump", 999)
        return "wallJump"
    end

    if not input:down("jump") and self.velocity.y < 0 then
        self.velocity.y = self.velocity.y / 1.5
    end

    if input:pressed("shoot") then
        self:shoot()
    end

    if self.aabb.onCeiling then
        return "ceilingHang"
    end

    if self.velocity.y > 1 and collision.isSolid(self.aabb.world, self, self.position.x + moveX, self.position.y) then
        self.wallSlideDirection = moveX
        self.direction = -self.wallSlideDirection == 1 and "right" or "left"
        return "wallSlide"
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

    if input:pressed("shoot") then
        self:shoot()
    end

    if moveX ~= self.climbDirection or moveY ~= -1 then
        if moveX ~= 0 then
            self.direction = moveX == 1 and "right" or "left"
        else
            self.direction = self.oldDirection
        end

        return "default"
    end

    if not collision.isSolid(self.aabb.world, self, self.position.x + self.climbDirection, self.position.y) then
        self.direction = self.oldDirection
        return "default"
    end

    if self.aabb.onCeiling then
        self.canClimb = false
        Timer.after(BONK_PENALTY, function()
            self.canClimb = true
        end)
        self.direction = self.oldDirection
        return "ceilingHang"
    end

    if self.buffers:get("jump") then
        self.velocity.x = WALLJUMP_SPEED * -self.climbDirection
        self.buffers:update("jump", 999)
        self.direction = -self.climbDirection == 1 and "right" or "left"
        return "wallJump"
    end
end

function Player:climbEnter()
    self:defaultEnter()
    self.acceleration.x = 0
    self.acceleration.y = -1
    self.velocity.y = 0
    self.minVelocity.y = -3

    self.oldDirection = self.direction
    self.direction = "up"
end

function Player:ceilingUpdate()
    local moveX, moveY = input:get("movePair")

    if input:pressed("shoot") then
        self:shoot()
    end

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
    self:defaultEnter()
    self.acceleration.x = self.ceilingDirection
    self.acceleration.y = 0
end

function Player:wallJumpUpdate()
    local moveX, _ = input:get("movePair")
    if moveX ~= 0 then
        self.direction = moveX == 1 and "right" or "left"
    end

    if input:pressed("shoot") then
        self:shoot()
    end

    if not input:down("jump") and self.velocity.y < 0 then
        self.velocity.y = self.velocity.y / 1.5
    end

    if self.velocity.y < 0 and collision.isSolid(self.aabb.world, self, self.position.x, self.position.y + self.velocity.y) then
        return "default"
    end
end

function Player:wallJumpEnter()
    self:defaultEnter()
    self.maxVelocity.x = WALLJUMP_SPEED

    self.velocity.y = -6

    Timer.after(0.15, function()
        if self.state:getState() == "wallJump" then
            self.state:setState("default")
        end
    end)
end

function Player:ceilingHangEnter()
    self:defaultEnter()
    self.acceleration.y = 0
    self.velocity.y = 0

    Timer.after(0.1, function()
        if self.state:getState() == "ceilingHang" then
            self.state:setState("default")
        end
    end)
end

function Player:wallSlideEnter()
    self:defaultEnter()
    self.maxVelocity.y = 2.5
end

function Player:wallSlideUpdate()
    local moveX, moveY = input:get("movePair")

    if input:pressed("shoot") then
        self:shoot()
    end

    if self.buffers:get("jump") then
        self.velocity.x = WALLJUMP_SPEED * -self.wallSlideDirection
        self.buffers:update("jump", 999)
        return "wallJump"
    end

    if moveX ~= self.wallSlideDirection then
        return "default"
    elseif moveY == -1 and self.canClimb then
        return "climb"
    end

    if self.aabb.onGround then
        return "default"
    end

    if not collision.isSolid(self.aabb.world, self, self.position.x + self.wallSlideDirection, self.position.y) then
        return "default"
    end
end

function Player:deadEnter()
    self.acceleration.x = 0
    self.acceleration.y = 0
    self.velocity.x = 0
    self.velocity.y = 0

    self.gameState:playerDied()
end

function Player:deadUpdate()
end

function Player:introUpdate()
end

function Player:shoot()
    local x = self.position.x
    local y = self.position.y

    if self.direction == "right" then
        x = x + self.aabb.width
        y = y + 6
    elseif self.direction == "left" then
        x = x - 4
        y = y + 6
    elseif self.direction == "up" then
        x = x + 6
        y = y - 4
    end

    self.world:add(PlayerBullet:new(x, y, self.direction, self.velocity, self.world, self.aabb.world))
end

return Player
