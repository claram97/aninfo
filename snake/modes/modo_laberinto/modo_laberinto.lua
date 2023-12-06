Love = require('love')
local M = {}
local gameState = "playing"
local level = 1
local fruitsToChangeWalls = {3, 6}  -- Number of fruits to collect before walls change
local wallsChanged = false
local gameOverHandled = false

local move = require('snake.modes.move')
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

local staticWall1X, staticWall1Y
local staticWall2X, staticWall2Y
local staticWall3X, staticWall3Y
local staticWall4X, staticWall4Y
local staticVerticalLine1X, staticVerticalLine1Y
local staticVerticalLine2X, staticVerticalLine2Y
local staticWalls = {}
local staticVerticalLines = {}

local FuncionesAuxiliares = require("snake.modes.modo_laberinto.pantalla_final")
-- load Love2D libraries
Love.graphics = require('love.graphics')
Love.timer = require('love.timer')
Love.keyboard = require('love.keyboard')

-- initialize game variables
snake = {}
fruit = {}
gameOver = false
score = 0

function M.load()
    snakeHeadImageUp = love.graphics.newImage('modes/modo_laberinto/assets/snake_head_up.png')
    snakeHeadImageDown = love.graphics.newImage('modes/modo_laberinto/assets/snake_head_down.png')
    snakeHeadImageLeft = love.graphics.newImage('modes/modo_laberinto/assets/snake_head_left.png')
    snakeHeadImageRight = love.graphics.newImage('modes/modo_laberinto/assets/snake_head_right.png')
    snakeBodyImageUp = love.graphics.newImage('modes/modo_laberinto/assets/snake_body_up.png')
    snakeBodyImageDown = love.graphics.newImage('modes/modo_laberinto/assets/snake_body_down.png')
    snakeBodyImageLeft = love.graphics.newImage('modes/modo_laberinto/assets/snake_body_left.png')
    snakeBodyImageRight = love.graphics.newImage('modes/modo_laberinto/assets/snake_body_right.png')
    fruitImage = love.graphics.newImage('modes/modo_laberinto/assets/fruit.png')
    backgroundImage = love.graphics.newImage('modes/modo_laberinto/assets/background.png')

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

    staticWall1X, staticWall1Y = get_random_position()
    staticWall2X, staticWall2Y = get_random_position()
    staticWall3X, staticWall3Y = get_random_position()
    staticWall4X, staticWall4Y = get_random_position()
    staticVerticalLine1X, staticVerticalLine1Y = get_random_position()
    staticVerticalLine2X, staticVerticalLine2Y = get_random_position()
    generateStaticWalls()
    generateStaticVerticalLines()

    -- initialize fruit
    fruit.x = FRUIT_START_X
    fruit.y = FRUIT_START_Y

    -- set initial direction
    direction = SNAKE_START_DIRECTION
    -- set timer for snake movement
    timer = love.timer.getTime()
end

function generateStaticVerticalLines()
    staticVerticalLines = {}  -- Reset the list

    for _ = 1, 2 do
        local x, y = get_random_position()
        table.insert(staticVerticalLines, {x = x, y = y})
    end
end

function generateStaticWalls()
    staticWalls = {}  -- Reset the list

    for _ = 1, 4 do
        local x, y = get_random_position()
        table.insert(staticWalls, {x = x, y = y})
    end
end

function change_level()
    if score == 3 or score == 6 then
        if not wallsChanged then
            level = level + 1
            wallsChanged = true  -- Set this to true only when the level changes
            generateStaticWalls()
            generateStaticVerticalLines()
        end
    else
        wallsChanged = false  -- Reset when the score is not 3 or 6
    end
end

function M.update(dt)
    -- check for game over

    if gameOver then
        -- check for space key press to restart the game
        if Love.keyboard.isDown('space') then
            -- reset game variables
            snake = {}
            fruit = {}
            gameOver = false
            score = 0

            -- initialize snake
            for i = 1, SNAKE_START_LENGTH do
                table.insert(snake, {x = SNAKE_START_X - i, y = SNAKE_START_Y})
            end

            -- initialize fruit
            fruit.x = FRUIT_START_X
            fruit.y = FRUIT_START_Y

            -- set initial direction
            direction = SNAKE_START_DIRECTION

            -- set timer for snake movement
            timer = love.timer.getTime()
        end
    return
    end

    move.get_direction(false)

    -- move snake
    local speed = 0.1 - 0.01 * (score - 1)
    speed = math.max(speed, 0.05)  -- Ensure the speed doesn't go below a certain threshold (e.g., 0.05)
    
    if Love.timer.getTime() - timer > speed then
        timer = Love.timer.getTime()
        move.move(snake)

        -- move body
        -- for i = #snake, 2, -1 do
        --     snake[i].x = snake[i - 1].x
        --     snake[i].y = snake[i - 1].y
        -- end

        -- -- move head
        -- if direction == 'up' then
        --     snake[1].y = snake[1].y - 1
        -- elseif direction == 'down' then
        --     snake[1].y = snake[1].y + 1
        -- elseif direction == 'left' then
        --     snake[1].x = snake[1].x - 1
        -- elseif direction == 'right' then
        --     snake[1].x = snake[1].x + 1
        -- end


        change_level()
       checkCollisionWithStaticWalls()
       checkCollisionWithStaticLines()

        -- check for collision with wall
        if snake[1].x < 1 or snake[1].x >= GAME_AREA_WIDTH-1 or snake[1].y < 1 or snake[1].y >= GAME_AREA_HEIGHT-1 then
            gameOver = true
        end

        -- check for collision with self
        for i = 2, #snake do
            if snake[1].x == snake[i].x and snake[1].y == snake[i].y then
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
            moveFruitToSafePosition()
        end
 
    end
end

function draw_border()
    for i = 0, GAME_AREA_WIDTH - 1 do
        for j = 0, GAME_AREA_HEIGHT - 1 do
            if i == 0 then
                love.graphics.setColor(0, 108/255, 44/255)
                love.graphics.rectangle('fill', i * TILE_SIZE, j * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            end
            if j == 0 then
                love.graphics.setColor(0, 108/255, 44/255)
                love.graphics.rectangle('fill', i * TILE_SIZE, j * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            end
            if i == GAME_AREA_WIDTH -1 then
                love.graphics.setColor(0, 108/255, 44/255)
                love.graphics.rectangle('fill', i * TILE_SIZE, j * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            end
            if j == GAME_AREA_HEIGHT -1 then
                love.graphics.setColor(0, 108/255, 44/255)
                love.graphics.rectangle('fill', i * TILE_SIZE, j * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            end
        end
    end
end


function moveFruitToSafePosition()
    local newFruitX, newFruitY

    repeat
        newFruitX, newFruitY = get_random_position()
    until not isPositionOnWall(newFruitX, newFruitY)

    fruit.x = newFruitX
    fruit.y = newFruitY
end


function isPositionOnWall(x, y)
    for _, wall in ipairs(staticWalls) do
        if x >= wall.x and x < wall.x + 4 and y == wall.y then
            return true
        end
    end

    for _, line in ipairs(staticVerticalLines) do
        if y >= line.y and y < line.y + 4 and x == line.x then
            return true
        end
    end

    return false
end

function draw_rectangle(start, finish)
    for i = (GAME_AREA_WIDTH / 2) - start, (GAME_AREA_WIDTH / 2) + finish do
        for j = (GAME_AREA_HEIGHT / 2) - start, (GAME_AREA_HEIGHT / 2) + finish do
            if i == (GAME_AREA_WIDTH / 2) - start then
                Love.graphics.setColor(0, 108/255, 44/255)
                Love.graphics.rectangle('fill', i * TILE_SIZE, j * TILE_SIZE, TILE_SIZE, TILE_SIZE) 
            end
            if i == (GAME_AREA_WIDTH / 2) + finish then
                Love.graphics.setColor(0, 108/255, 44/255)
                Love.graphics.rectangle('fill', i * TILE_SIZE, j * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            end
            if j == (GAME_AREA_HEIGHT / 2) - start then 
                Love.graphics.setColor(0, 108/255, 44/255)
                Love.graphics.rectangle('fill', i * TILE_SIZE, j * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            end
            if j == (GAME_AREA_HEIGHT / 2) + finish then
                Love.graphics.setColor(0, 108/255, 44/255)
                Love.graphics.rectangle('fill', i * TILE_SIZE, j * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            end
        end
    end
end

function draw_labyrinth()
    draw_border()
    draw_rectangle(3,3)
    
end

function draw_labyrinth_2()
    draw_border()
end

function draw_labyrinth_3()
    draw_border()
    draw_rectangle(5,5)
    draw_rectangle(2,2)
end

function draw_horizontal_line(start, finish, j)
    for i = start, finish do
        Love.graphics.setColor(0, 108/255, 44/255)
        Love.graphics.rectangle('fill', i * TILE_SIZE, j * TILE_SIZE, TILE_SIZE, TILE_SIZE)
    end
end

function draw_vertical_line(start, finish, j)
    for i = start, finish do
        Love.graphics.setColor(0, 108/255, 44/255)
        Love.graphics.rectangle('fill', j * TILE_SIZE, i * TILE_SIZE, TILE_SIZE, TILE_SIZE)
    end
end

function draw_labyrinth_4()
    draw_border()
    draw_vertical_line((GAME_AREA_HEIGHT / 2) - 2, (GAME_AREA_HEIGHT / 2) + 2, (GAME_AREA_WIDTH / 2) - 5)
    draw_vertical_line((GAME_AREA_HEIGHT / 2) - 2, (GAME_AREA_HEIGHT / 2) + 2, (GAME_AREA_WIDTH / 2) + 5)
    draw_horizontal_line((GAME_AREA_WIDTH / 2) - 2, (GAME_AREA_WIDTH / 2) + 2, (GAME_AREA_HEIGHT / 2) - 5)
    draw_horizontal_line((GAME_AREA_WIDTH / 2) - 2, (GAME_AREA_WIDTH / 2) + 2, (GAME_AREA_HEIGHT / 2) + 5)
end

function draw_labyrinth_4()
    draw_border()
    draw_vertical_line((GAME_AREA_HEIGHT / 2) - 2, (GAME_AREA_HEIGHT / 2) + 2, (GAME_AREA_WIDTH / 2) - 5)
    draw_vertical_line((GAME_AREA_HEIGHT / 2) - 2, (GAME_AREA_HEIGHT / 2) + 2, (GAME_AREA_WIDTH / 2) + 5)
    draw_horizontal_line((GAME_AREA_WIDTH / 2) - 2, (GAME_AREA_WIDTH / 2) + 2, (GAME_AREA_HEIGHT / 2) - 5)
    draw_horizontal_line((GAME_AREA_WIDTH / 2) - 2, (GAME_AREA_WIDTH / 2) + 2, (GAME_AREA_HEIGHT / 2) + 5)
end

function get_random_position()
    local x = Love.math.random(2, GAME_AREA_WIDTH - 2)
    local y = Love.math.random(2, GAME_AREA_HEIGHT - 2)
    return x, y
end

function draw_random_lines()
    draw_border()

    
end

function drawStaticWalls()
    Love.graphics.setColor(0, 108/255, 44/255)
    for _, wall in ipairs(staticWalls) do
        Love.graphics.rectangle('fill', wall.x * TILE_SIZE, wall.y * TILE_SIZE, TILE_SIZE * 4, TILE_SIZE)
    end
end

-- Function to draw static vertical lines
function drawStaticVerticalLines()
    Love.graphics.setColor(0, 108/255, 44/255)
    for _, line in ipairs(staticVerticalLines) do
        Love.graphics.rectangle('fill', line.x * TILE_SIZE, line.y * TILE_SIZE, TILE_SIZE, TILE_SIZE * 4)
    end
end

-- Check collision with static walls and lines
function checkCollisionWithStaticWalls()
    for _, wall in ipairs(staticWalls) do
        if snake[1].x >= wall.x and snake[1].x < wall.x + 4 and snake[1].y == wall.y then
            -- Collision with a static wall, trigger game over
            gameOver = true
        end
    end
end

function checkCollisionWithStaticLines()
    for _, line in ipairs(staticVerticalLines) do
        if snake[1].y >= line.y and snake[1].y < line.y + 4 and snake[1].x == line.x then
            -- Collision with a static vertical line, trigger game over
            gameOver = true
        end
    end
end

function M.draw()
    -- draw game area
    wallColor1 = {15/255, 202/255, 81/255}
    wallColor = {175/255, 1, 206/255} 
    if gameState == "playing" then
        if level == 1 then
            wallColor1 = {15/255, 202/255, 81/255}
            wallColor = {175/255, 1, 206/255} 
        elseif level == 2 then
            wallColor1 = {162/255, 208/255, 74/255}
            wallColor = {170/255, 216/255, 82/255} 
        elseif level == 3 then
            wallColor1 = {1, 1, 1}
            wallColor = {0, 185/255, 74/255}
        end
        
        Love.graphics.setBackgroundColor(1, 1, 1)  -- Set background color to white
        for i = 0, GAME_AREA_WIDTH - 1 do
            for j = 0, GAME_AREA_HEIGHT - 1 do
                -- Alternate between white and green squares
                if (i + j) % 2 == 0 then
                    Love.graphics.setColor(wallColor1)  -- White color
                else
                    Love.graphics.setColor(wallColor)
                end

                Love.graphics.rectangle('fill', i * TILE_SIZE, j * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            end
        end



        -- draw game area borders
        Love.graphics.setColor(0, 0, 0)
        Love.graphics.rectangle('line', 0, 0, GAME_AREA_WIDTH * TILE_SIZE, GAME_AREA_HEIGHT * TILE_SIZE)


        drawStaticWalls()
        drawStaticVerticalLines()
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
        -- love.graphics.setColor(1, 0, 0)
        -- love.graphics.rectangle('fill', fruit.x * TILE_SIZE, fruit.y * TILE_SIZE, TILE_SIZE, TILE_SIZE)

        -- draw score
        draw_border()
        Love.graphics.setColor(0,0,0)
        Love.graphics.setFont(font)
        Love.graphics.print('Score: ' .. score, 10, 10)
    end
    if gameOver then
        gameState = "not"
        FuncionesAuxiliares.mostrarPantallaFinal(score)

    end
end

return M