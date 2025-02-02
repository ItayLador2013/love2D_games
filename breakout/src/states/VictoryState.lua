VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
    self.level = params.level
    self.score = params.score
    self.paddle = params.paddle
    self.health = params.health
    self.balls = params.balls
    self.totalHealth = params.totalHealth
end

function VictoryState:update(dt)
    self.paddle:update(dt)
    self.paddle:render()
    for k, ball in pairs(self.balls) do
        ball.x = self.paddle.x + (self.paddle.width/2) - (ball.width/2)
        ball.y = self.paddle.y - ball.height
    end
    
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            level = self.level + 1,
            bricks = LevelMaker.createMap(self.level + 1),
            paddle = self.paddle,
            health = self.health,
            score = self.score,
            balls = self.balls,
            totalHealth = self.totalHealth
        })
    end
end

function VictoryState:render()
    self.paddle:render()
    for k, ball in pairs(self.balls) do
        ball:render()
    end

    renderHealth(self.health, self.totalHealth)
    renderScore(self.score)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level) .. " complete!", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to serve!', 0, VIRTUAL_HEIGHT/1.5, VIRTUAL_WIDTH, 'center')
end
