Love = require('love')

snakeHeadImageUp = Love.graphics.newImage('assets/snake_head_up.png')
snakeHeadImageDown = Love.graphics.newImage('assets/snake_head_down.png')
snakeHeadImageLeft = Love.graphics.newImage('assets/snake_head_left.png')
snakeHeadImageRight = Love.graphics.newImage('assets/snake_head_right.png')
snakeBodyImageUp = Love.graphics.newImage('assets/snake_body_up.png')
snakeBodyImageDown = Love.graphics.newImage('assets/snake_body_down.png')
snakeBodyImageLeft = Love.graphics.newImage('assets/snake_body_left.png')
snakeBodyImageRight = Love.graphics.newImage('assets/snake_body_right.png')
fruitImage = Love.graphics.newImage('assets/fruit.png')
backgroundImage = Love.graphics.newImage('assets/background.png')

-- set window dimensions
WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 800

-- set tile dimensions
TILE_SIZE = 50

-- set game area dimensions
GAME_AREA_WIDTH = 24
GAME_AREA_HEIGHT = 16

-- set initial snake position
SNAKE_START_X = 12
SNAKE_START_Y = 8

-- set initial snake length
SNAKE_START_LENGTH = 3

-- set initial snake direction
SNAKE_START_DIRECTION = 'right'

-- set initial fruit position
FRUIT_START_X = 1
FRUIT_START_Y = 1

SPEED_INCREMENT = 0.001

-- load Love2D libraries
Love.graphics = require('love.graphics')
Love.timer = require('love.timer')
Love.keyboard = require('love.keyboard')

-- initialize game variables
snake = {}
fruit = {}
gameOver = false
score = 0
speed = 0.1

-- initialize obstacles
obstacles = {}
obstacleCount = 0

-- function to place a fruit in a random location without obstacles
function placeFruit()
    local fruitX = Love.math.random(GAME_AREA_WIDTH - 1)
    local fruitY = Love.math.random(GAME_AREA_HEIGHT - 1)

    -- check for collision with snake
    for i = 1, #snake do
        if fruitX == snake[i].x and fruitY == snake[i].y then
            return placeFruit()
        end
    end

    -- check for collision with obstacles
    for i = 1, #obstacles do
        if fruitX == obstacles[i].x and fruitY == obstacles[i].y then
            return placeFruit()
        end
    end

    -- place fruit
    fruit.x = fruitX
    fruit.y = fruitY
end

-- function to place an obstacle in a random location without fruit or snake every certain amount of fruit eaten
function placeObstacle()
    local obstacleX = Love.math.random(GAME_AREA_WIDTH - 1)
    local obstacleY = Love.math.random(GAME_AREA_HEIGHT - 1)

    -- check for collision with fruit
    if obstacleX == fruit.x and obstacleY == fruit.y then
        return placeObstacle()
    end

    -- check for collision with snake
    for i = 1, #snake do
        if obstacleX == snake[i].x and obstacleY == snake[i].y then
            return placeObstacle()
        end
    end

    -- place obstacle
    local obstacle = {x = obstacleX, y = obstacleY}
    table.insert(obstacles, obstacle)
end

function Love.load()
    -- set window title
    Love.window.setTitle('Snake Game')

    -- set window dimensions
    Love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

    -- set background color to a light gray
    Love.graphics.setBackgroundColor(0.5, 0.5, 0.5)

    -- set font for score display
    font = Love.graphics.newFont(24)

    -- initialize snake
    for i = 1, SNAKE_START_LENGTH do
        table.insert(snake, {x = SNAKE_START_X - i, y = SNAKE_START_Y})
    end

    -- initialize fruit
    fruit.x = FRUIT_START_X
    fruit.y = FRUIT_START_Y

    -- initialize obstacles
    for i = 1, obstacleCount do
        local obstacle = {x = Love.math.random(GAME_AREA_WIDTH - 1), y = Love.math.random(GAME_AREA_HEIGHT - 1)}
        table.insert(obstacles, obstacle)
    end

    -- set initial direction
    direction = SNAKE_START_DIRECTION

    -- set timer for snake movement
    timer = Love.timer.getTime()
end

function Love.update(dt)
    -- check for game over
    if gameOver then
        return
    end

    -- check for input
    if Love.keyboard.isDown('up') and direction ~= 'down' then
        direction = 'up'
    elseif Love.keyboard.isDown('down') and direction ~= 'up' then
        direction = 'down'
    elseif Love.keyboard.isDown('left') and direction ~= 'right' then
        direction = 'left'
    elseif Love.keyboard.isDown('right') and direction ~= 'left' then
        direction = 'right'
    end

    -- move snake
    if Love.timer.getTime() - timer > speed then
        timer = Love.timer.getTime()

        -- move body
        for i = #snake, 2, -1 do
            snake[i].x = snake[i - 1].x
            snake[i].y = snake[i - 1].y
        end

        -- move head
        if direction == 'up' then
            snake[1].y = snake[1].y - 1
        elseif direction == 'down' then
            snake[1].y = snake[1].y + 1
        elseif direction == 'left' then
            snake[1].x = snake[1].x - 1
        elseif direction == 'right' then
            snake[1].x = snake[1].x + 1
        end

        -- check for collision with wall
        if snake[1].x < 0 or snake[1].x >= GAME_AREA_WIDTH or snake[1].y < 0 or snake[1].y >= GAME_AREA_HEIGHT then
            gameOver = true
        end

        -- check for collision with self
        for i = 2, #snake do
            if snake[1].x == snake[i].x and snake[1].y == snake[i].y then
                gameOver = true
            end
        end

        -- check for collision with obstacles
        for i = 1, #obstacles do
            if snake[1].x == obstacles[i].x and snake[1].y == obstacles[i].y then
                gameOver = true
            end
        end

        -- check for collision with fruit
        if snake[1].x == fruit.x and snake[1].y == fruit.y then
            -- add to score
            score = score + 1

            -- add to snake length
            table.insert(snake, {x = snake[#snake].x, y = snake[#snake].y})

            -- move fruit to new location
            placeFruit()

            -- add obstacle every certain amount of fruit eaten
            if score % 10 == 0 then
                placeObstacle()
            end

            -- increase speed
            speed = math.max(speed - SPEED_INCREMENT, 0.05)
        end
    end
end

function Love.draw()
    -- draw game area
    Love.graphics.setColor(1, 1, 1)
    for i = 0, GAME_AREA_WIDTH - 1 do
        for j = 0, GAME_AREA_HEIGHT - 1 do
            -- Alternate between white and green squares
            if (i + j) % 2 == 0 then
                Love.graphics.setColor(1, 1, 1)  -- White color
            else
                Love.graphics.setColor(0, 1, 0)  -- Green color
            end

            Love.graphics.rectangle('fill', i * TILE_SIZE, j * TILE_SIZE, TILE_SIZE, TILE_SIZE)
        end
    end

    -- draw game area borders
    Love.graphics.setColor(0, 0, 0)
    Love.graphics.rectangle('line', 0, 0, GAME_AREA_WIDTH * TILE_SIZE, GAME_AREA_HEIGHT * TILE_SIZE)

    -- draw obstacles
    for i = 1, #obstacles do
        Love.graphics.setColor(0, 0, 0)
        Love.graphics.rectangle('fill', obstacles[i].x * TILE_SIZE, obstacles[i].y * TILE_SIZE, TILE_SIZE, TILE_SIZE)
    end

    -- draw snake
    for i = 1, #snake do
        if i == 1 then
            -- draw snake head image
            Love.graphics.setColor(1, 1, 1)
            if direction == 'up' then
                Love.graphics.draw(snakeHeadImageUp, snake[i].x * TILE_SIZE, snake[i].y * TILE_SIZE, 0)
            elseif direction == 'down' then
                Love.graphics.draw(snakeHeadImageDown, snake[i].x * TILE_SIZE, snake[i].y * TILE_SIZE, 0)
            elseif direction == 'left' then
                Love.graphics.draw(snakeHeadImageLeft, snake[i].x * TILE_SIZE, snake[i].y * TILE_SIZE, 0)
            elseif direction == 'right' then
                Love.graphics.draw(snakeHeadImageRight, snake[i].x * TILE_SIZE, snake[i].y * TILE_SIZE, 0)
            end
        else
            -- draw square
            Love.graphics.setColor(0.82, 0.553, 0.275)
            Love.graphics.rectangle('fill', snake[i].x * TILE_SIZE, snake[i].y * TILE_SIZE, TILE_SIZE, TILE_SIZE)

            -- draw snake body image
            Love.graphics.setColor(1, 1, 1)
            local angle = 0
            if snake[i].x < snake[i-1].x then
                Love.graphics.draw(snakeBodyImageRight, snake[i].x * TILE_SIZE, snake[i].y * TILE_SIZE, angle)
            elseif snake[i].x > snake[i-1].x then
                Love.graphics.draw(snakeBodyImageRight, snake[i].x * TILE_SIZE, snake[i].y * TILE_SIZE, angle)
            elseif snake[i].y < snake[i-1].y then
                Love.graphics.draw(snakeBodyImageUp, snake[i].x * TILE_SIZE, snake[i].y * TILE_SIZE, angle)
            elseif snake[i].y > snake[i-1].y then
                Love.graphics.draw(snakeBodyImageDown, snake[i].x * TILE_SIZE, snake[i].y * TILE_SIZE, angle)
            end
        end
    end

    -- draw fruit
    Love.graphics.setColor(1, 1, 1)
    Love.graphics.draw(fruitImage, fruit.x * TILE_SIZE, fruit.y * TILE_SIZE, 0, TILE_SIZE/fruitImage:getWidth(), TILE_SIZE/fruitImage:getHeight())

    -- draw score
    Love.graphics.setColor(0, 0, 0)
    Love.graphics.setFont(font)
    Love.graphics.print('Score: ' .. score, 10, 10)

    -- show debug information
    Love.graphics.print('FPS: ' .. Love.timer.getFPS(), 10, 40)
    Love.graphics.print('Speed: ' .. speed, 10, 70)
    Love.graphics.print('Direction: ' .. direction, 10, 100)

    -- draw game over message
    if gameOver then
        -- draw background rectangle
        Love.graphics.setColor(0.5, 0.5, 0.5, 0.8)
        Love.graphics.rectangle('fill', WINDOW_WIDTH / 2 - 150, WINDOW_HEIGHT / 2 - 75, 300, 150)

        -- draw game over text
        Love.graphics.setColor(0, 0, 0)
        Love.graphics.setFont(font)
        Love.graphics.printf('Game Over', WINDOW_WIDTH / 2 - 150, WINDOW_HEIGHT / 2 - 50, 300, 'center')

        -- draw final score
        Love.graphics.printf('Final Score: ' .. score, WINDOW_WIDTH / 2 - 150, WINDOW_HEIGHT / 2, 300, 'center')
    end
end
