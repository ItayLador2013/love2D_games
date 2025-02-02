PlayState = Class{__includes=BaseState}

function PlayState:init()
    self.bird = Bird()
    self.pipes = {}
    self.lastY = - PIPE_HEIGHT + math.random(80) + 20
    self.spawnTimer = 0
    self.score = 0

end

function PlayState:update(dt)
    self.spawnTimer = self.spawnTimer + dt
    if self.spawnTimer > 3 then

        local y = math.max(-PIPE_HEIGHT + 10,
            math.min(self.lastY + math.random(-60,60), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        table.insert(self.pipes, PipePair(y))
        self.spawnTimer = 0
    end

    self.bird:update(dt)

    for k, pair in pairs(self.pipes) do
        pair:update(dt)

        if self.bird.x > pair.x + PIPE_WIDTH - 2 and pair.scored == false then
            self.score = self.score + 1
            pair.scored = true
        end

        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then 
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
        if pair.remove then
            table.remove(self.pipes, k)
        end
    end
end

function PlayState:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end

    self.bird:render()

    love.graphics.setFont(mediumFont)
    love.graphics.print('Score: ' .. tostring(self.score), 10, 10)

end

function PlayState:enter()
    scrolling = true
end
function PlayState:exit()
    scrolling = false
end