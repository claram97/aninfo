Love = require('love')
local M = {}
local move = require('snake.modes.move')
local configuracion = require('snake.modes.configuracion.configuracion')
local constants = require('snake.modes.constants')
local game_area_width = GAME_AREA_WIDTH
local game_area_height = GAME_AREA_HEIGHT
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

--pre:
--pos: reinicia las variables para que el juego se reinici
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

--pre: Se espera que las imágenes y recursos necesarios estén disponibles. El estado del juego puede cargarse si `loadGame` es verdadero.
-- Pos: La función inicializa el juego, cargando las imágenes necesarias, estableciendo el título y las dimensiones de la ventana, 
--inicializando las serpientes y la fruta, y configurando la dirección inicial de las serpientes.
function M.load(loadGame)
    local config = configuracion.load()
    if config.sound == true then
        love.audio.play(musica_fondo)
    end
    if config.sound == false then
        love.audio.stop(musica_fondo)
    end

    FuncionesAuxiliares = require("snake.pantalla_final")
    scores = require('snake.modes.scores.scores')

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
    if config.fullScreen then
        Love.window.setMode(BIG_WINDOW_WIDTH, BIG_WINDOW_HEIGHT)
        game_area_height = BIG_GAME_AREA_HEIGHT
        game_area_width = BIG_GAME_AREA_WIDTH
    else
        Love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
        game_area_height = GAME_AREA_HEIGHT
        game_area_width = GAME_AREA_WIDTH
    end

    -- set background color to a light gray
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5)

    -- set font for score display
    font = love.graphics.newFont(24)

    local savedSnake = savegame.loadSnakeState('inverted')
    if loadGame and savedSnake then
        snake = savedSnake.snake
        score = savedSnake.score
        fruit.x = FRUIT_START_X
        fruit.y = FRUIT_START_Y
    else
        -- initialize snake
        for i = 1, SNAKE_START_LENGTH do
            table.insert(snake, {x = SNAKE_START_X - i, y = SNAKE_START_Y})
        end
    
        -- initialize fruit
        fruit.x = FRUIT_START_X
        fruit.y = FRUIT_START_Y
    end

    -- infer direction from the first two snake pieces
    if snake[1].x == snake[2].x then
        if snake[1].y < snake[2].y then
            direction = 'up'
        else
            direction = 'down'
        end
    else
        if snake[1].x < snake[2].x then
            direction = 'left'
        else
            direction = 'right'
        end
    end

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
                scores.writeCsv(text, score, "invertido")
                FuncionesAuxiliares.load()
            end
        end
    end
end

-- pre:
-- pos: Maneja la entrada del teclado, reinicia el juego si es necesario, obtiene la dirección y mueve la serpiente
-- y actualiza la puntuación y la posición de la fruta
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
        if snake[1].x < 0 or snake[1].x >= game_area_width or snake[1].y < 0 or snake[1].y >= game_area_height then
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
            fruit.x = love.math.random(game_area_width - 1)
            fruit.y = love.math.random(game_area_height - 1)
        end
    end
end

--pre: El juego está en curso, snake es válido, direction es una cadena, fruitImage y fruit son válidos, TILE_SIZE es positivo, score es no negativo, y gameOver es un booleano.
--pos: Dibuja en la pantalla el área de juego, la serpiente, la fruta y la puntuación según el estado actual del juego
function M.draw()
    -- draw game area
    if gameState == "playing" then
        love.graphics.setColor(1,1,1)
       
        love.graphics.setBackgroundColor(1, 1, 1)  -- Set background color to white

        for i = 0, game_area_width - 1 do
            for j = 0, game_area_height - 1 do
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
        love.graphics.rectangle('line', 0, 0, game_area_width * TILE_SIZE, game_area_height * TILE_SIZE)

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

-- pre: El juego está en curso (gameState == "playing"), snake es una tabla válida, fruit es una posición válida, y score es un número no negativo
-- pos: Se guardan los datos del juego si la aplicacion se cierra
function M.quit()
    if gameOver then
        return
    end
    local obstacles = {}
    savegame.saveSnakeState(snake, obstacles, score, 'inverted')
end

function M.isSavedGame()
    return savegame.loadSnakeState('inverted') ~= nil
end

return M