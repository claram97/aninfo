snakeHeadImageUp = love.graphics.newImage('assets/snake_head_up.png')
snakeHeadImageDown = love.graphics.newImage('assets/snake_head_down.png')
snakeHeadImageLeft = love.graphics.newImage('assets/snake_head_left.png')
snakeHeadImageRight = love.graphics.newImage('assets/snake_head_right.png')
snakeBodyImageUp = love.graphics.newImage('assets/snake_body_up.png')
snakeBodyImageDown = love.graphics.newImage('assets/snake_body_down.png')
snakeBodyImageLeft = love.graphics.newImage('assets/snake_body_left.png')
snakeBodyImageRight = love.graphics.newImage('assets/snake_body_right.png')

-- set window dimensions
WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 800

-- set tile dimensions
TILE_SIZE = 50

-- set game area dimensions
GAME_AREA_WIDTH = 24
GAME_AREA_HEIGHT = 16

-- set initial snake position
SNAKE_1_START_X = 4
SNAKE_1_START_Y = 4

SNAKE_2_START_X = 12
SNAKE_2_START_Y = 12

-- set initial snake length
SNAKE_START_LENGTH = 3

-- set initial snake direction
SNAKE_1_START_DIRECTION = 'left'
SNAKE_2_START_DIRECTION = 'right'

-- set initial fruit position
FRUIT_START_X = 1
FRUIT_START_Y = 1

-- load Love2D libraries
love.graphics = require('love.graphics')
love.timer = require('love.timer')
love.keyboard = require('love.keyboard')

-- initialize game variables
snake1 = {}
snake2 = {}
fruit = {}
gameOver = false
score1 = 0
score2 = 0

function love.load()
    -- set window title
    love.window.setTitle('Snake Game')

    -- set window dimensions
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

    -- set background color to a light gray
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5)

    -- set font for score display
    font = love.graphics.newFont(24)

    -- initialize snake 1
    for i = 1, SNAKE_START_LENGTH do
        table.insert(snake1, {x = SNAKE_1_START_X + i, y = SNAKE_1_START_Y})
    end

    -- initialize snake 2
    for i = 1, SNAKE_START_LENGTH do
        table.insert(snake2, {x = SNAKE_2_START_X - i, y = SNAKE_2_START_Y})
    end

    -- initialize fruit
    fruit.x = FRUIT_START_X
    fruit.y = FRUIT_START_Y

    -- set initial direction
    direction1 = SNAKE_1_START_DIRECTION
    direction2 = SNAKE_2_START_DIRECTION

    -- set timer for snake movement
    timer = love.timer.getTime()
end

function love.update(dt)
    -- check for game over
    if gameOver then
        return
    end

    -- check for input
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

    -- move snakes
    if love.timer.getTime() - timer > 0.1 then
        timer = love.timer.getTime()

        -- move snake 1
        -- move body
        for i = #snake1, 2, -1 do
            snake1[i].x = snake1[i - 1].x
            snake1[i].y = snake1[i - 1].y
        end

        -- move head
        if direction1 == 'up' then
            snake1[1].y = snake1[1].y - 1
        elseif direction1 == 'down' then
            snake1[1].y = snake1[1].y + 1
        elseif direction1 == 'left' then
            snake1[1].x = snake1[1].x - 1
        elseif direction1 == 'right' then
            snake1[1].x = snake1[1].x + 1
        end

        -- check for collision with wall
        if snake1[1].x < 0 or snake1[1].x >= GAME_AREA_WIDTH or snake1[1].y < 0 or snake1[1].y >= GAME_AREA_HEIGHT then
            gameOver = true
        end

        -- check for collision with self snake 1
        for i = 2, #snake1 do
            if snake1[1].x == snake1[i].x and snake1[1].y == snake1[i].y then
                gameOver = true
            end
        end

        -- check for collision with self snake 2
        for i = 2, #snake2 do
            if snake1[1].x == snake2[i].x and snake1[1].y == snake2[i].y then
                gameOver = true
            end
        end

        -- check for collision for the snake 1 head with the snake 2 body
        for i = 2, #snake2 do
            if snake1[1].x == snake2[i].x and snake1[1].y == snake2[i].y then
                gameOver = true
            end
        end

        -- check for collision for the snake 2 head with the snake 1 body
        for i = 2, #snake1 do
            if snake2[1].x == snake1[i].x and snake2[1].y == snake1[i].y then
                gameOver = true
            end
        end

    

        -- check for collision with fruit
        if snake1[1].x == fruit.x and snake1[1].y == fruit.y then
            -- add to score
            score1 = score1 + 1

            -- add to snake length
            table.insert(snake1, {x = snake1[#snake1].x, y = snake1[#snake1].y})

            -- move fruit to new location
            fruit.x = love.math.random(GAME_AREA_WIDTH - 1)
            fruit.y = love.math.random(GAME_AREA_HEIGHT - 1)
        end

        -- move snake 2
        -- move body
        for i = #snake2, 2, -1 do
            snake2[i].x = snake2[i - 1].x
            snake2[i].y = snake2[i - 1].y
        end

        -- move head
        if direction2 == 'up' then
            snake2[1].y = snake2[1].y - 1
        elseif direction2 == 'down' then
            snake2[1].y = snake2[1].y + 1
        elseif direction2 == 'left' then
            snake2[1].x = snake2[1].x - 1
        elseif direction2 == 'right' then
            snake2[1].x = snake2[1].x + 1
        end

        -- check for collision with wall
        if snake2[1].x < 0 or snake2[1].x >= GAME_AREA_WIDTH or snake2[1].y < 0 or snake2[1].y >= GAME_AREA_HEIGHT then
            gameOver = true
        end

        -- check for collision with self
        for i = 2, #snake2 do
            if snake2[1].x == snake2[i].x and snake2[1].y == snake2[i].y then
                gameOver = true
            end
        end

        -- check for collision with fruit
        if snake2[1].x == fruit.x and snake2[1].y == fruit.y then
            -- add to score
            score2 = score2 + 1

            -- add to snake length
            table.insert(snake2, {x = snake2[#snake2].x, y = snake2[#snake2].y})

            -- move fruit to new location
            fruit.x = love.math.random(GAME_AREA_WIDTH - 1)
            fruit.y = love.math.random(GAME_AREA_HEIGHT - 1)
        end
    end
end

function love.draw()
    -- draw game area

    love.graphics.setColor(0.82, 0.553, 0.275)
    love.graphics.rectangle('fill', 0, 0, GAME_AREA_WIDTH * TILE_SIZE, GAME_AREA_HEIGHT * TILE_SIZE)

    -- draw snake 1
    for i = 1, #snake1 do
        if i == 1 then
            -- draw snake head image
            love.graphics.setColor(1, 1, 1)
            if direction1 == 'up' then
                love.graphics.draw(snakeHeadImageUp, snake1[i].x * TILE_SIZE, snake1[i].y * TILE_SIZE, 0)
            elseif direction1 == 'down' then
                love.graphics.draw(snakeHeadImageDown, snake1[i].x * TILE_SIZE, snake1[i].y * TILE_SIZE, 0)
            elseif direction1 == 'left' then
                love.graphics.draw(snakeHeadImageLeft, snake1[i].x * TILE_SIZE, snake1[i].y * TILE_SIZE, 0)
            elseif direction1 == 'right' then
                love.graphics.draw(snakeHeadImageRight, snake1[i].x * TILE_SIZE, snake1[i].y * TILE_SIZE, 0)
            end
        else
            -- draw square
            love.graphics.setColor(4/255, 191/255, 69/255)
            love.graphics.rectangle('fill', snake1[i].x * TILE_SIZE, snake1[i].y * TILE_SIZE, TILE_SIZE, TILE_SIZE)

            -- draw snake body image
            love.graphics.setColor(1, 1, 1)
            local angle = 0
            if snake1[i].x < snake1[i-1].x then
                love.graphics.draw(snakeBodyImageRight, snake1[i].x * TILE_SIZE, snake1[i].y * TILE_SIZE, angle)
            elseif snake1[i].x > snake1[i-1].x then
                love.graphics.draw(snakeBodyImageLeft, snake1[i].x * TILE_SIZE, snake1[i].y * TILE_SIZE, angle)
            elseif snake1[i].y < snake1[i-1].y then
                love.graphics.draw(snakeBodyImageDown, snake1[i].x * TILE_SIZE, snake1[i].y * TILE_SIZE, angle)
            elseif snake1[i].y > snake1[i-1].y then
                love.graphics.draw(snakeBodyImageUp, snake1[i].x * TILE_SIZE, snake1[i].y * TILE_SIZE, angle)
            end
        end
    end

    -- draw snake 2
    for i = 1, #snake2 do
        if i == 1 then
            -- draw snake head image
            love.graphics.setColor(1, 1, 1)
            if direction2 == 'up' then
                love.graphics.draw(snakeHeadImageUp, snake2[i].x * TILE_SIZE, snake2[i].y * TILE_SIZE, 0)
            elseif direction2 == 'down' then
                love.graphics.draw(snakeHeadImageDown, snake2[i].x * TILE_SIZE, snake2[i].y * TILE_SIZE, 0)
            elseif direction2 == 'left' then
                love.graphics.draw(snakeHeadImageLeft, snake2[i].x * TILE_SIZE, snake2[i].y * TILE_SIZE, 0)
            elseif direction2 == 'right' then
                love.graphics.draw(snakeHeadImageRight, snake2[i].x * TILE_SIZE, snake2[i].y * TILE_SIZE, 0)
            end
        else
            -- draw square
            love.graphics.setColor(4/255, 191/255, 69/255)
            love.graphics.rectangle('fill', snake2[i].x * TILE_SIZE, snake2[i].y * TILE_SIZE, TILE_SIZE, TILE_SIZE)

            -- draw snake body image
            love.graphics.setColor(1, 1, 1)
            local angle = 0
            if snake2[i].x < snake2[i-1].x then
                love.graphics.draw(snakeBodyImageRight, snake2[i].x * TILE_SIZE, snake2[i].y * TILE_SIZE, angle)
            elseif snake2[i].x > snake2[i-1].x then
                love.graphics.draw(snakeBodyImageLeft, snake2[i].x * TILE_SIZE, snake2[i].y * TILE_SIZE, angle)
            elseif snake2[i].y < snake2[i-1].y then
                love.graphics.draw(snakeBodyImageDown, snake2[i].x * TILE_SIZE, snake2[i].y * TILE_SIZE, angle)
            elseif snake2[i].y > snake2[i-1].y then
                love.graphics.draw(snakeBodyImageUp, snake2[i].x * TILE_SIZE, snake2[i].y * TILE_SIZE, angle)
            end
        end
    end

    -- draw fruit
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', fruit.x * TILE_SIZE, fruit.y * TILE_SIZE, TILE_SIZE, TILE_SIZE)

    -- draw score
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(font)
    love.graphics.print('Player 1 Score: ' .. score1, 10, 10)
    love.graphics.print('Player 2 Score: ' .. score2, WINDOW_WIDTH - font:getWidth('Player 2 Score: ' .. score2) - 10, 10)

    -- draw game over message
    if gameOver then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(font)
        love.graphics.print('Game Over', WINDOW_WIDTH / 2 - font:getWidth('Game Over') / 2, WINDOW_HEIGHT / 2 - font:getHeight() / 2)
    end
end
