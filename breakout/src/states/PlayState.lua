PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.paddle = params.paddle
    self.paused = false

    self.balls = params.balls
    for k, ball in pairs(self.balls) do
        ball.dx = math.random(-200,200)
        ball.dy = math.random(-50,-60)
    end

    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.level = params.level
    self.totalHealth = params.totalHealth

    self.powers = {}
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end
    self.paddle:update(dt)

    for i, ball in pairs(self.balls) do
        ball.lastX = ball.x
        ball.lastY = ball.y
        
        
        ball:update(dt)
        
        if ball:collides(self.paddle) then
            ball.y = self.paddle.y - ball.height
            ball.dy = -ball.dy
            
            if ball.x < self.paddle.x + (self.paddle.width/2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8*(self.paddle.x + self.paddle.width / 2 - ball.x))
            elseif ball.x > self.paddle.x + (self.paddle.width/2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end
        
            gSounds['paddle-hit']:play()
        end

        for k, brick in pairs(self.bricks) do
            if brick.inPlay and ball:collides(brick) then

                self.score = self.score + (brick.tier * 200 + brick.color * 25)

                brick:hit()

                if self:checkVictory() then
                    gSounds['victory']:play()
                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        balls = self.balls,
                        totalHealth = self.totalHealth
                    })
                end

                if brick.hasPower and not brick.inPlay then
                    local power = Power(brick.x, brick.y)
                    power.active = true
                    table.insert(self.powers, power)
                end

                if ball.x + 2 < brick.x and ball.dx > 0 then
                    ball.dx = -ball.dx
                    ball.x = brick.x - ball.width
                elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                    ball.dx = -ball.dx
                    ball.x = brick.x + 32
                elseif ball.y < brick.y then
                    ball.dy = -ball.dy
                    ball.y = brick.y - ball.height
                else
                    ball.dy = -ball.dy
                    ball.y = brick.y + brick.height
                end

                ball.dy = ball.dy * 1.02

                break
            end
        end

        if ball.y >= VIRTUAL_HEIGHT then
            table.remove(self.balls, i)
            gSounds['hurt']:play()
        end
    end

    if #self.balls <= 0 then
        self.health = self.health - 1
        if self.health == 0 then
            gStateMachine:change('game-over', {
                score = self.score
            })
        else 
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health, 
                score = self.score,
                level = self.level,
                totalHealth = self.totalHealth
            })
        end
    end

    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    for k, power in pairs(self.powers) do
        power:update(dt)
        if power.active and power:collides(self.paddle) then
            power.active = false

            if power.power == 4 then
                for i = 0, 2 do
                    local ball = Ball(math.random(7))
                    ball.x = self.paddle.x + (self.paddle.width / 2) - (ball.width / 2)
                    ball.y = self.paddle.y - ball.height
                    ball.dx = math.random(-200,200)
                    ball.dy = math.random(-50,-60)
                    table.insert(self.balls, ball)
                end
            elseif power.power == 7 or power.power == 9 then
                local ball = Ball(math.random(7))
                ball.x = self.paddle.x + (self.paddle.width / 2) - (ball.width / 2)
                ball.y = self.paddle.y - ball.height
                ball.dx = math.random(-200,200)
                ball.dy = math.random(-50,-60)
                table.insert(self.balls, ball)
            elseif power.power == 3 then
                if self.health >= self.totalHealth then
                    self.totalHealth = self.totalHealth + 1
                end
                self.health = self.health + 1
            elseif power.power == 5 then
                if self.paddle.size < 4 then
                    self.paddle.width = self.paddle.width + 32
                end
                self.paddle.size = math.min(4, self.paddle.size + 1)
            elseif power.power == 6 then
                if self.paddle.size > 1 then
                    self.paddle.width = self.paddle.width - 32
                end
                self.paddle.size = math.max(1, self.paddle.size - 1)
            end

        end 
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    self.paddle:render()

    for k, ball in pairs(self.balls) do
        ball:render()
    end
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    for k, power in pairs(self.powers) do
        power:render()
    end

    renderScore(self.score)
    renderHealth(self.health, self.totalHealth)

    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT/2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end
    end

    return true
end