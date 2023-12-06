local M = {}

function M.get_direction(invertido)
    if invertido then
        if Love.keyboard.isDown('up') and direction ~= 'up' then
            direction = 'down'
        elseif Love.keyboard.isDown('down') and direction ~= 'down' then
            direction = 'up'
        elseif Love.keyboard.isDown('left') and direction ~= 'left' then
            direction = 'right'
        elseif Love.keyboard.isDown('right') and direction ~= 'right' then
            direction = 'left'
        end

        if Love.keyboard.isDown('w') and direction ~= 'up' then
            direction = 'down'
        elseif Love.keyboard.isDown('s') and direction ~= 'down' then
            direction = 'up'
        elseif Love.keyboard.isDown('a') and direction ~= 'left' then
            direction = 'right'
        elseif Love.keyboard.isDown('d') and direction ~= 'right' then
            direction = 'left'
        end
    else
        if Love.keyboard.isDown('up') and direction ~= 'down' then
            direction = 'up'
        elseif Love.keyboard.isDown('down') and direction ~= 'up' then
            direction = 'down'
        elseif Love.keyboard.isDown('left') and direction ~= 'right' then
            direction = 'left'
        elseif Love.keyboard.isDown('right') and direction ~= 'left' then
            direction = 'right'
        end

        if Love.keyboard.isDown('w') and direction ~= 'down' then
            direction = 'up'
        elseif Love.keyboard.isDown('s') and direction ~= 'up' then
            direction = 'down'
        elseif Love.keyboard.isDown('a') and direction ~= 'right' then
            direction = 'left'
        elseif Love.keyboard.isDown('d') and direction ~= 'left' then
            direction = 'right'
        end
    end
end

function M.move(snake)
    for i = #snake, 2, -1 do
        snake[i].x = snake[i - 1].x
        snake[i].y = snake[i - 1].y
    end

    if direction == 'up' then
        snake[1].y = snake[1].y - 1
    elseif direction == 'down' then
        snake[1].y = snake[1].y + 1
    elseif direction == 'left' then
        snake[1].x = snake[1].x - 1
    elseif direction == 'right' then
        snake[1].x = snake[1].x + 1
    end
end

return M