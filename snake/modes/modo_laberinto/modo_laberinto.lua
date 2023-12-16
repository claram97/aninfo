Love = require('love')
local M = {}
local level = 1
local fruitsToChangeWalls = {3, 6}  -- Number of fruits to collect before walls change
local wallsChanged = false
local gameOverHandled = false
local obstacles = {}
local move = require('snake.modes.move')
local configuracion = require('snake.modes.configuracion.configuracion')
savegame = require('snake.modes.savegame')
local constants = require('snake.modes.constants')

FIRST_LEVEL_END_SCORE = 50
SECOND_LEVEL_END_SCORE = 100

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

-- load Love2D libraries
Love.graphics = require('love.graphics')
Love.timer = require('love.timer')
Love.keyboard = require('love.keyboard')

-- initialize game variables
snake = {}
fruit = {}
gameOver = false
score = 0

--pre:
-- pos: Inicializa la ventana del juego con los parámetros especificados
function initializeWindow()
    -- set window title
    Love.window.setTitle('Snake Game')

    -- set window dimensions
    Love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

    -- set background color to a light gray
    Love.graphics.setBackgroundColor(0.5, 0.5, 0.5)

    -- set font for score display
    font = Love.graphics.newFont(24)
end

-- pre: 
-- pos: Inicializa las paredes estáticas y las líneas verticales en posiciones aleatorias
function initializeWalls()
    staticWall1X, staticWall1Y = get_random_position()
    staticWall2X, staticWall2Y = get_random_position()
    staticWall3X, staticWall3Y = get_random_position()
    staticWall4X, staticWall4Y = get_random_position()
    staticVerticalLine1X, staticVerticalLine1Y = get_random_position()
    staticVerticalLine2X, staticVerticalLine2Y = get_random_position()
    generateObstacles()
end

--pre: Se espera que las imágenes y recursos necesarios estén disponibles
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

    initializeWindow()
    local savedSnake = savegame.loadSnakeState('modo_laberinto')
    if savedSnake and loadGame then
        snake = savedSnake.snake
        score = savedSnake.score
        speed = 0.1 - (score * SPEED_INCREMENT)
        gameState = "playing"
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
        obstacles = savedSnake.obstacles
        timer = Love.timer.getTime()
        fruit.x = FRUIT_START_X
        fruit.y = FRUIT_START_Y
    else
        for i = 1, SNAKE_START_LENGTH do
            table.insert(snake, {x = SNAKE_START_X - i, y = SNAKE_START_Y})
        end
        direction = SNAKE_START_DIRECTION
    
        initializeWalls()
    
        fruit.x = FRUIT_START_X
        fruit.y = FRUIT_START_Y
    
        timer = love.timer.getTime()
    end

end

--pre:
--pos: genera nuevas paredes verticales y horizontales
function generateObstacles()
    obstacles = {}

    
    for _ = 1, 2 do
        local x, y = get_random_position_away_from_snake()
        table.insert(obstacles, {x = x, y = y})
        table.insert(obstacles, {x = x + 1, y = y})
        table.insert(obstacles, {x = x + 2, y = y})
        table.insert(obstacles, {x = x + 3, y = y})
    end

   
    for _ = 1, 2 do
        local x, y = get_random_position_away_from_snake()
        table.insert(obstacles, {x = x, y = y})
        table.insert(obstacles, {x = x, y = y + 1})
        table.insert(obstacles, {x = x, y = y + 2})
        table.insert(obstacles, {x = x, y = y + 3})
    end
end

--pre:
--pos: genera nuevas paredes y sube el nivel cuando el score alcanza ciertos parametros
function change_level()
    if score >= FIRST_LEVEL_END_SCORE and score < SECOND_LEVEL_END_SCORE and level == 1 then
        level = 2
        wallsChanged = true
        generateObstacles()
    elseif score >= SECOND_LEVEL_END_SCORE and level == 2 then
        level = 3
        wallsChanged = true
        generateObstacles()
    else
        wallsChanged = false
    end
end

--pre:
--pos:devuelve un booleano que significa si la fruta esta en la misma coordenada que una pared
function wallsOverlapWithFruit()
    for _, wall in ipairs(obstacles) do
        if wall.x >= fruit.x and wall.x < fruit.x + 4 and wall.y == fruit.y then
            return true
        end
    end
    
    return false
end

--pre:
--pos: reinicia las variables para "reiniciar" el juego
local function reloadGame()
    gameOver = false
    score = 0
    snake = {}
    M.load()
end

function checkEndMenuKeys()
    Love.keypressed = function(key)
        if key == 'f10' and gameOver then
            reloadGame()
            FuncionesAuxiliares.load()
        elseif key == 'f11' and gameOver then
            FuncionesAuxiliares.load()
            love.event.quit("restart")
        elseif key == 'f12' and gameOver then
            print("Se tocó f12. Debería guardarse el score.")
            if FuncionesAuxiliares.getTextLenght() > 0 then
                local text = FuncionesAuxiliares.getText()
                scores.writeCsv(text, score, "laberinto")
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
        return
    end

    move.get_direction(false)

    -- move snake
    local speed = 0.1 - 0.01 * (score - 1)
    speed = math.max(speed, 0.05)  -- Ensure the speed doesn't go below a certain threshold (e.g., 0.05)
    
    if Love.timer.getTime() - timer > speed then
        timer = Love.timer.getTime()
        move.move(snake)

        change_level()
        checkCollisionWithObstacles()
       

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

        if snake[1].x == fruit.x and snake[1].y == fruit.y then
            score = score + math.random(5, 13)
            love.audio.play(sonido_comer)

            table.insert(snake, {x = snake[#snake].x, y = snake[#snake].y})

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
--pre:
--pos: genera nuevas coordenadas hasta que no este cerca de la snake
function get_random_position_away_from_snake()
    local x, y
    repeat
        x, y = get_random_position()
    until not isPositionNearSnake(x, y)
    return x, y
end

--pre:
--pos: chequea si las coordenadas esta cerca de la snake
function isPositionNearSnake(x, y)
    for _, segment in ipairs(snake) do
        if math.abs(x - segment.x) < 4 and math.abs(y - segment.y) < 4 then
            return true
        end
    end
    return false
end

--pre:
--pos: mueve la fruta hacia una posicion nueva donde las coordenadas no coincidan con las paredes
function moveFruitToSafePosition()
    local newFruitX, newFruitY

    repeat
        newFruitX, newFruitY = get_random_position()
    until not isPositionOnWall(newFruitX, newFruitY)

    fruit.x = newFruitX
    fruit.y = newFruitY
end

--pre:
--pos: Retorna un booleano que: si los x e y coinciden con las coordenadas de una pared entonces es verdadero, sino falso
function isPositionOnWall(x, y)
    for _, wall in ipairs(obstacles) do
        if x == wall.x and y == wall.y then
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
    for _, wall in ipairs(obstacles) do
        Love.graphics.rectangle('fill', wall.x * TILE_SIZE, wall.y * TILE_SIZE, TILE_SIZE, TILE_SIZE)
    end
end


--pre:
--pos: chequea la colision de la serpiente con un obstaculo, si chocan gameOVer es verdadero, sino falso
function checkCollisionWithObstacles()
    for _, wall in ipairs(obstacles) do
        if snake[1].x == wall.x and snake[1].y == wall.y then
            -- Colisión con una pared estática, activa el fin del juego
            gameOver = true
        end
    end
end


--pre: El juego está en curso, snake es válido, direction es una cadena, fruitImage y fruit son válidos, TILE_SIZE es positivo, score es no negativo, y gameOver es un booleano.
--pos: Dibuja en la pantalla el área de juego, las paredes, la serpiente, la fruta y la puntuación según el estado actual del juego
function M.draw()
    -- draw game area
    wallColor1 = {15/255, 202/255, 81/255}
    wallColor = {175/255, 1, 206/255} 
    if not gameOver then
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
        draw_border()
        Love.graphics.setColor(0,0,0)
        Love.graphics.setFont(font)
        Love.graphics.print('Score: ' .. score, 10, 10)
    elseif gameOver then
        FuncionesAuxiliares.mostrarPantallaFinal(score)
    end
end

-- pre:
-- pos: Devuelve true si hay un juego guardado
function M.isSavedGame()
    return savegame.loadSnakeState('modo_laberinto') ~= nil
end

-- pre: 
-- pos: Se guardan los datos del juego si la aplicacion se cierra
function M.quit()
    if game_over then
        return true
    end
    savegame.saveSnakeState(snake_segments, obstacles, score, 'modo_laberinto')
end

return M