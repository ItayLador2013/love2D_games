Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')
PIPE_SPEED = 60
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y
    self.orientation = orientation
    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT

    self.dx = PIPE_SCROLL
end

function Pipe:update(dt)

end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, 
    (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
    0, -- rotation
    1, -- X Scale
    self.orientation == 'top' and -1 or 1 -- Y scale
    )
end