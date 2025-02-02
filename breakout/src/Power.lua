Power = Class{__includes = BaseState}


function Power:init(x, y)
    self.height = 16
    self.width = 16
    self.x = x + self.width/2
    self.y = y
    self.power = math.random(3,9)
    self.dy = 70
    self.active = false
end

function Power:update(dt)
    if self.active then
        self.y = self.y + self.dy * dt
    end
end

function Power:collides(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    return true
end

function Power:render()
    if self.active then
        love.graphics.draw(gTextures['main'], gFrames['powers'][self.power], self.x, self.y)
    end
end