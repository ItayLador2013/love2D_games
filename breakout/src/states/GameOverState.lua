GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.score = params.score 
    self.highScores = loadHighScores()
end

function GameOverState:update(dt)

    for i = 1, 10, 1 do
        if self.score > self.highScores[i].score then
            gStateMachine:change('enter-high-score', {
                score = self.score,
                highScores = self.highScores,
                scoreIndex = i
            })
            return
        end
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('start')
    end
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameOverState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Final Score: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter!', 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
end