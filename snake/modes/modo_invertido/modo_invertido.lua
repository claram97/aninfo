Love = require('love')
local M = {}
local move = require('snake.modes.move')
local configuracion = require('snake.modes.configuracion.configuracion')

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

-- load Love2D libraries
Love.graphics = require('love.graphics')
Love.timer = require('love.timer')
Love.keyboard = require('love.keyboard')

-- initialize game variables
snake = {}
fruit = {}
gameOver = false
score = 0
gameState = "playing"


function reiniciarJuego()
    -- Reinicia todas las variables del juego
    gameOver = false
    score = 0
    direction = SNAKE_START_DIRECTION
    snake = {}
    for i = 1, SNAKE_START_LENGTH do
        table.insert(snake, {x = SNAKE_START_X - i, y = SNAKE_START_Y})
    end
    fruit.x = FRUIT_START_X
    fruit.y = FRUIT_START_Y
end

function M.load()
    local config = configuracion.load()
    if config.sound == true then
        love.audio.play(musica_fondo)
    end
    if config.sound == false then
        love.audio.stop(musica_fondo)
    end

    FuncionesAuxiliares = require("snake.pantalla_final")

    snakeHeadImageUp = love.graphics.newImage('modes/modo_invertido/assets/snake_head_up.png')
    snakeHeadImageDown = love.graphics.newImage('modes/modo_invertido/assets/snake_head_down.png')
    snakeHeadImageLeft = love.graphics.newImage('modes/modo_invertido/assets/snake_head_left.png')
    snakeHeadImageRight = love.graphics.newImage('modes/modo_invertido/assets/snake_head_right.png')
    snakeBodyImageUp = love.graphics.newImage('modes/modo_invertido/assets/snake_body_up.png')
    snakeBodyImageDown = love.graphics.newImage('modes/modo_invertido/assets/snake_body_down.png')
    snakeBodyImageLeft = love.graphics.newImage('modes/modo_invertido/assets/snake_body_left.png')
    snakeBodyImageRight = love.graphics.newImage('modes/modo_invertido/assets/snake_body_right.png')
    fruitImage = love.graphics.newImage('modes/modo_invertido/assets/fruit.png')
    backgroundImage = love.graphics.newImage('modes/modo_invertido/assets/background.png')

    -- set window title
    love.window.setTitle('Snake Game')

    -- set window dimensions
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

    -- set background color to a light gray
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5)

    -- set font for score display
    font = love.graphics.newFont(24)

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

function checkEndMenuKeys()
    Love.keypressed = function(key)
        if key == 'f10' and gameOver then
            gameState = "playing"
            reiniciarJuego()
            FuncionesAuxiliares.load()
        elseif key == 'f11' and gameOver then
            FuncionesAuxiliares.load()
            love.event.quit("restart")
        elseif key == 'f12' and gameOver then
            print("Se tocó f12. Debería guardarse el score.")
            if FuncionesAuxiliares.getTextLenght() > 0 then
                local text = FuncionesAuxiliares.getText()
                scores.writeCsv(text, score, "clásico")
                FuncionesAuxiliares.load()
            end
        end
    end
end

function M.update(dt)
    if gameOver then
        checkEndMenuKeys()
    end

    move.get_direction(true, direction)
    -- move snake
    if love.timer.getTime() - timer > 0.1 then
        timer = love.timer.getTime()

        move.move(snake)


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

        -- check for collision with fruit
        if snake[1].x == fruit.x and snake[1].y == fruit.y then
            -- add to score
            score = score + math.random(5, 13)
            love.audio.play(sonido_comer)

            -- add to snake length
            table.insert(snake, {x = snake[#snake].x, y = snake[#snake].y})

            -- move fruit to new location
            fruit.x = love.math.random(GAME_AREA_WIDTH - 1)
            fruit.y = love.math.random(GAME_AREA_HEIGHT - 1)
        end
    end
end

function M.draw()
    -- draw game area
    if gameState == "playing" then
        love.graphics.setColor(1,1,1)
       
        love.graphics.setBackgroundColor(1, 1, 1)  -- Set background color to white

        for i = 0, GAME_AREA_WIDTH - 1 do
            for j = 0, GAME_AREA_HEIGHT - 1 do
                -- Alternate between white and green squares
                if (i + j) % 2 == 0 then
                    Love.graphics.setColor(0, 108/255, 44/255)
                else
                    Love.graphics.setColor(175/255, 1, 206/255)
                end

                love.graphics.rectangle('fill', i * TILE_SIZE, j * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            end
        end

        -- draw game area borders
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('line', 0, 0, GAME_AREA_WIDTH * TILE_SIZE, GAME_AREA_HEIGHT * TILE_SIZE)

        -- draw snake
        for i = 1, #snake do
            if i == 1 then
                -- draw snake head image
                love.graphics.setColor(1, 1, 1)
                if direction == 'up' then
                    love.graphics.draw(snakeHeadImageUp, snake[i].x * TILE_SIZE, snake[i].y * TILE_SIZE, 0)
                elseif direction == 'down' then
                    love.graphics.draw(snakeHeadImageDown, snake[i].x * TILE_SIZE, snake[i].y * TILE_SIZE, 0)
                elseif direction == 'left' then
                    love.graphics.draw(snakeHeadImageLeft, snake[i].x * TILE_SIZE, snake[i].y * TILE_SIZE, 0)
                elseif direction == 'right' then
                    love.graphics.draw(snakeHeadImageRight, snake[i].x * TILE_SIZE, snake[i].y * TILE_SIZE, 0)
                end


            else
                -- draw square
                love.graphics.setColor(0.82, 0.553, 0.275)
                love.graphics.rectangle('fill', snake[i].x * TILE_SIZE, snake[i].y * TILE_SIZE, TILE_SIZE, TILE_SIZE)

                -- draw snake body image
                love.graphics.setColor(1, 1, 1)
                local angle = 0
                if snake[i].x < snake[i-1].x then
                    love.graphics.draw(snakeBodyImageRight, snake[i].x * TILE_SIZE, snake[i].y * TILE_SIZE, angle)
                elseif snake[i].x > snake[i-1].x then
                    love.graphics.draw(snakeBodyImageRight, snake[i].x * TILE_SIZE, snake[i].y * TILE_SIZE, angle)
                elseif snake[i].y < snake[i-1].y then
                    love.graphics.draw(snakeBodyImageUp, snake[i].x * TILE_SIZE, snake[i].y * TILE_SIZE, angle)
                elseif snake[i].y > snake[i-1].y then
                    love.graphics.draw(snakeBodyImageDown, snake[i].x * TILE_SIZE, snake[i].y * TILE_SIZE, angle)
                end
            end
        end

        -- draw fruit
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(fruitImage, fruit.x * TILE_SIZE, fruit.y * TILE_SIZE, 0, TILE_SIZE/fruitImage:getWidth(), TILE_SIZE/fruitImage:getHeight())
       
        -- draw score
        love.graphics.setColor(0,0,0)
        love.graphics.setFont(font)
        love.graphics.print('Score: ' .. score, 10, 10)
    end
    -- draw game over message
    if gameOver then
        gameState = "not"
        FuncionesAuxiliares.mostrarPantallaFinal(score)
    end
end

return M