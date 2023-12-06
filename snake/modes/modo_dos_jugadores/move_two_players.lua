if love.keyboard.isDown('up') and direction1 ~= 'down' then
    direction1 = 'up'
elseif love.keyboard.isDown('down') and direction1 ~= 'up' then
    direction1 = 'down'
elseif love.keyboard.isDown('left') and direction1 ~= 'right' then
    direction1 = 'left'
elseif love.keyboard.isDown('right') and direction1 ~= 'left' then
    direction1 = 'right'
end

if love.keyboard.isDown('w') and direction2 ~= 'down' then
    direction2 = 'up'
elseif love.keyboard.isDown('s') and direction2 ~= 'up' then
    direction2 = 'down'
elseif love.keyboard.isDown('a') and direction2 ~= 'right' then
    direction2 = 'left'
elseif love.keyboard.isDown('d') and direction2 ~= 'left' then
    direction2 = 'right'
end