ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.level = params.level
    self.balls = {}
    self.totalHealth = params.totalHealth

    table.insert(self.balls, Ball(math.random(7)))
end

function ServeState:update(dt)
    self.paddle:update(dt)
    for k, ball in pairs(self.balls) do
        ball.x = self.paddle.x + (self.paddle.width / 2) - (ball.width / 2)
        ball.y = self.paddle.y - ball.height
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health, 
            score = self.score,
            balls = self.balls,
            level = self.level,
            totalHealth = self.totalHealth
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function ServeState:render()
    self.paddle:render()
    for k, ball in pairs(self.balls) do
        ball:render()
    end

    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    renderHealth(self.health, self.totalHealth)
    renderScore(self.score)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('PRESS ENTER TO PLAY', 0, self.paddle.y - 50, VIRTUAL_WIDTH, 'center')

end