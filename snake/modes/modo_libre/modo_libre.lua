-- Import the body of the snake from assets
local love = require("love")

snakeBodyImage = love.graphics.newImage('modes/modo_libre/assets/snake_body.png')
snakeHeadImage = love.graphics.newImage('modes/modo_libre/assets/snake_head.png')
fruitImage = love.graphics.newImage('modes/modo_libre/assets/fruit_image.png')
background = love.graphics.newImage('modes/modo_libre/assets/sprite_libre2.png')
local configuracion = require('snake.modes.configuracion.configuracion')
local savegame = require('snake.modes.savegame')
Love.keyboard = require('love.keyboard')
local scores = require('snake.modes.scores.scores')
local M = {}
local constants = require('snake.modes.constants')
local game_area_height = GAME_AREA_HEIGHT
local game_area_width = GAME_AREA_WIDTH

-- Define font
local font = love.graphics.newFont(40)

local game_over = false
local snake_x = WINDOW_WIDTH / 2
local snake_y = WINDOW_HEIGHT / 2
local fruit_x = math.random(WINDOW_WIDTH)
local fruit_y = math.random(WINDOW_HEIGHT)

-- Define initial velocity of snake
local snake_speed = 3
local snake_angle = 0

-- Define radius and color of snake and fruit
local snake_radius = 25
local snake_color = {1, 1, 1}
local fruit_radius = 20
local fruit_color = {1, 0, 0}

-- Define flag to indicate if arrow key is pressed
local left_pressed = false
local right_pressed = false

-- Define score variable
local score = 0

-- Define obstacle variables
local OBSTACLE_RADIUS = 35
local OBSTACLE_APPARITION_FREQUENCY = 5

-- Define table to store snake segments
local segment_distance = 45
local snake_segments = {
    {x = snake_x, y = snake_y},
    {x = snake_x - segment_distance, y = snake_y}
}

-- Define table to store obstacles
local obstacles = {
    {x = 200, y = 300},
}

--pre:
--pos: reinicia las variables para "reiniciar" el juego
function reiniciarTodo()
    game_over = false
    snake_x = WINDOW_WIDTH / 2
    snake_y = WINDOW_HEIGHT / 2
    fruit_x, fruit_y = getRandomFruitPosition()
    snake_speed = 3
    snake_angle = 0
    left_pressed = false
    right_pressed = false
    score = 0

    snake_segments = {
        {x = snake_x, y = snake_y},
        {x = snake_x - segment_distance, y = snake_y}
    }

    obstacles = {
        {x = 200, y = 300},
    }
end

--pre:
--pos: si el gameState es "playing" dibuja toda la pantalla, la snake, los obstaculos y fruta sino dibuja la pantalla final
function draw()
    if not game_over then
        love.graphics.setColor(1, 1, 1)
        for i = 0, game_area_width - 1 do
            for j = 0, game_area_height - 1 do
                -- Alternate between white and green squares
                if (i + j) % 2 == 0 then
                    Love.graphics.setColor(227/255, 242/255, 200/255)
                else
                    Love.graphics.setColor(162/255, 208/255, 74/255)
                end

                love.graphics.rectangle('fill', i * TILE_SIZE, j * TILE_SIZE, TILE_SIZE, TILE_SIZE)
            end
        end
        love.graphics.setColor(snake_color)
        for i, segment in ipairs(snake_segments) do
            local imageToDraw = (i == 1) and snakeHeadImage or snakeBodyImage
            love.graphics.draw(imageToDraw, segment.x - snake_radius, segment.y - snake_radius)
        end
        love.graphics.setColor(1, 0, 0)
        love.graphics.draw(fruitImage, fruit_x - fruit_radius, fruit_y - fruit_radius)

        -- Draw obstacles
        love.graphics.setColor(0, 0, 0)
        for _, obstacle in ipairs(obstacles) do
            love.graphics.circle('fill', obstacle.x, obstacle.y, OBSTACLE_RADIUS)
        end

        love.graphics.print("Score: " .. score, 10, 10)
 
    end

    if game_over then
        FuncionesAuxiliares.mostrarPantallaFinal(score)
    end

end

-- pre:
-- pos: Maneja la entrada del teclado, reinicia el juego si es necesario, obtiene la dirección y mueve la serpiente
-- y actualiza la puntuación y la posición de la fruta

local pressed = false
local cleared = false

-- Define function to update position of snake and fruit
local function update(dt)
    if Love.keyboard.isDown('f10')  and  game_over then
        reiniciarTodo()
        pressed = false
        FuncionesAuxiliares.load()
    end

    if Love.keyboard.isDown('f11') and game_over then
        pressed = false
        FuncionesAuxiliares.load()
        love.event.quit("restart")
    end

    if Love.keyboard.isDown('f12') and game_over and not pressed then
        print("Se tocó f12. Debería guardarse el score.")
        if FuncionesAuxiliares.getTextLenght() > 0 then
            local text = FuncionesAuxiliares.getText()
            scores.writeCsv(text, score, "libre")
            pressed = not pressed
            FuncionesAuxiliares.load()
        end
    end

    if game_over then
        if not cleared then
            FuncionesAuxiliares.load()
            cleared = not cleared
        end
        return
    end

    if not game_over then
        -- Update position of snake based on velocity
        if Love.keyboard.isDown('left') then
            snake_angle = snake_angle - math.pi / 64
        elseif Love.keyboard.isDown('right') then
            snake_angle = snake_angle + math.pi / 64
        end
        snake_x = snake_x + snake_speed * math.cos(snake_angle)
        snake_y = snake_y + snake_speed * math.sin(snake_angle)

        -- Check if snake has collided with fruit
        local distance = math.sqrt((snake_x - fruit_x)^2 + (snake_y - fruit_y)^2)
        if distance < snake_radius + fruit_radius then
            -- Update score, add new segment to snake, and move fruit to new location
            score = score + math.random(5, 13)
            love.audio.play(sonido_comer)

            -- get the last segment of the snake
            local lastSegment = snake_segments[#snake_segments - 1]
            -- add a new segment to the snake
            table.insert(snake_segments, {x=lastSegment.x, y=lastSegment.y})
            updateObstacles()
            fruit_x, fruit_y = getRandomFruitPosition()

            -- Increment snake speed every 10 fruits eaten
            if score % 10 == 0 then
                snake_speed = snake_speed + 0.5
            end
        end

        local margin = 10

        -- Check if snake has collided with walls
        if snake_x < 0 - margin then
            game_over = true
            if not cleared then
                FuncionesAuxiliares.load()
                cleared = not cleared
            end
        elseif snake_x > WINDOW_WIDTH then
            game_over = true
            if not cleared then
                FuncionesAuxiliares.load()
                cleared = not cleared
            end
        end
        if snake_y < 0 - margin then
            game_over = true
            if not cleared then
                FuncionesAuxiliares.load()
                cleared = not cleared
            end
        elseif snake_y > WINDOW_HEIGHT then
            game_over = true
            if not cleared then
                FuncionesAuxiliares.load()
                cleared = not cleared
            end
        end

        -- Check if snake has collided with obstacles
        for _, obstacle in ipairs(obstacles) do
            local distance = math.sqrt((snake_x - obstacle.x)^2 + (snake_y - obstacle.y)^2)
            if distance < snake_radius + OBSTACLE_RADIUS then
                game_over = true
                if not cleared then
                    FuncionesAuxiliares.load()
                    cleared = not cleared
                end
            end
        end

        -- Check if snake has collided with itself
        for i = 5, #snake_segments do
            local segment = snake_segments[i]
            local distance = math.sqrt((snake_x - segment.x)^2 + (snake_y - segment.y)^2)
            if distance < snake_radius * 2 then
                game_over = true
                if not cleared then
                    FuncionesAuxiliares.load()
                    cleared = not cleared
                end
            end
        end

        -- Update positions of snake segments
        for i = #snake_segments, 2, -1 do
            local dx = snake_segments[i-1].x - snake_segments[i].x
            local dy = snake_segments[i-1].y - snake_segments[i].y
            local dist = math.sqrt(dx*dx + dy*dy)
            local factor = segment_distance / dist
            snake_segments[i].x = snake_segments[i-1].x - dx * factor
            snake_segments[i].y = snake_segments[i-1].y - dy * factor
        end

        snake_segments[1].x = snake_x
        snake_segments[1].y = snake_y
    end
end

-- pre: `key` es una cadena de texto que representa la tecla presionada
-- pos: Actualiza el estado de las variables `left_pressed` y `right_pressed` si la tecla es "left" o "right",
local function keypressed(key)
    if key == "left" then
        left_pressed = true
    elseif key == "right" then
        right_pressed = true
    end
end

-- pre: `key` es una cadena de texto que representa la tecla liberada
-- pos: Actualiza el estado de las variables `left_pressed` y `right_pressed` a falso si la tecla es "left" o "right"
local function keyreleased(key)
    if key == "left" then
        left_pressed = false
    elseif key == "right" then
        right_pressed = false
    end
end

-- pre: 
-- pos: Invoca la función 'draw' para realizar el dibujo del juego
function M.draw()
    draw()
end

-- pre: 
-- pos: Invoca la función 'update' para realizar el update del juego
function M.update(dt)
    update(dt)
end


-- pre: Recibe un parámetro 'key' que representa la tecla presionada.
-- pos: Invoca la función 'keypressed' pasando la tecla presionada como argumento
function love.keypressed(key)
    keypressed(key)
end

-- pre: Recibe un parámetro 'key' que representa la tecla liberada
-- pos: Invoca la función 'keypressed' pasando la tecla liberada como argumento
function love.keyreleased(key)
    keyreleased(key)
end

--pre: Se espera que las imágenes y recursos necesarios estén disponibles
-- Pos: La función inicializa el juego, el audio, cargando las imágenes necesarias, estableciendo el título y las dimensiones de la ventana, 
--inicializando las serpientes y la fruta, y configurando la dirección inicial de las serpientes.

-- Define function to load game assets
function M.load(loadGame)
    local config = configuracion.load()
    if config.sound == true then
        love.audio.play(musica_fondo)
    end
    if config.sound == false then
        love.audio.stop(musica_fondo)
    end

    FuncionesAuxiliares = require("snake.modes.modo_libre.pantalla_final")

    local snakeBodyImage = love.graphics.newImage('modes/modo_libre/assets/snake_body.png')
    local snakeHeadImage = love.graphics.newImage('modes/modo_libre/assets/snake_head.png')
    local fruitImage = love.graphics.newImage('modes/modo_libre/assets/fruit_image.png')
    local background = love.graphics.newImage('modes/modo_libre/assets/sprite_libre2.png')

    if config.fullScreen then
        Love.window.setMode(BIG_WINDOW_WIDTH, BIG_WINDOW_HEIGHT)
        game_area_height = BIG_GAME_AREA_HEIGHT
        game_area_width = BIG_GAME_AREA_WIDTH
        snake_x = BIG_WINDOW_WIDTH / 2
        snake_y = BIG_WINDOW_HEIGHT / 2
        fruit_x = math.random(BIG_WINDOW_WIDTH)
        fruit_y = math.random(BIG_WINDOW_HEIGHT)
    else
        Love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
        game_area_height = GAME_AREA_HEIGHT
        game_area_width = GAME_AREA_WIDTH     
        snake_x = WINDOW_WIDTH / 2
        snake_y = WINDOW_HEIGHT / 2
        fruit_x = math.random(WINDOW_WIDTH)
        fruit_y = math.random(WINDOW_HEIGHT)
    end

    local savedSnake = savegame.loadSnakeState('free_mode')
    if loadGame and savedSnake then
        snake_segments = savedSnake.snake
        print("head: " .. snake_segments[1].x .. ", " .. snake_segments[1].y)
        obstacles = savedSnake.obstacles
        score = savedSnake.score
        
        local head = snake_segments[1]
        local secondSegment = snake_segments[2]
        local dx = head.x - secondSegment.x
        local dy = head.y - secondSegment.y
        snake_angle = math.atan2(dy, dx)
        snake_x = head.x
        snake_y = head.y
    else
        snake_segments = {
            {x = snake_x, y = snake_y},
            {x = snake_x - segment_distance, y = snake_y}
        }
        obstacles = {
            {x = 200, y = 300, radius = 50},
        }
        score = 0
    end

    -- Check if snake spawns near an obstacle and reposition it if necessary
    for _, obstacle in ipairs(obstacles) do
        local distance = math.sqrt((snake_x - obstacle.x)^2 + (snake_y - obstacle.y)^2)
        if distance < snake_radius + OBSTACLE_RADIUS then
            snake_x, snake_y = getRandomSnakePosition()
        end
    end

    -- Check if fruit spawns on an obstacle and reposition it if necessary
    for _, obstacle in ipairs(obstacles) do
        local distance = math.sqrt((fruit_x - obstacle.x)^2 + (fruit_y - obstacle.y)^2)
        if distance < fruit_radius + OBSTACLE_RADIUS then
            fruit_x, fruit_y = getRandomFruitPosition()
        end
    end

end

--pre:
--pos: Genera y devuelve una posición aleatoria para de la serpiente, evitando colisiones con obstáculos
function getRandomSnakePosition()
    local x = math.random(WINDOW_WIDTH)
    local y = math.random(WINDOW_HEIGHT)
    for _, obstacle in ipairs(obstacles) do
        local distance = math.sqrt((x - obstacle.x)^2 + (y - obstacle.y)^2)
        if distance < snake_radius + OBSTACLE_RADIUS then
            return getRandomSnakePosition()
        end
    end
    return x, y
end

--pre: 
--pos: genera y devuelve una posicion aleatoria de la fruta, evitando colisiones con obstáculos
function getRandomFruitPosition()
    local x = math.random(WINDOW_WIDTH)
    local y = math.random(WINDOW_HEIGHT)
    for _, obstacle in ipairs(obstacles) do
        local distance = math.sqrt((x - obstacle.x)^2 + (y - obstacle.y)^2)
        if distance < fruit_radius + OBSTACLE_RADIUS then
            return getRandomFruitPosition()
        end
    end
    return x, y
end

-- pre: score tiene que ser numerico 0 o positivo
-- pos: Si el módulo de la puntuación actual entre 'OBSTACLE_APPARITION_FREQUENCY' es cero, se agrega un obstáculo aleatorio a la lista de obstáculos
function updateObstacles()
    if score % OBSTACLE_APPARITION_FREQUENCY == 0 then
        local obstacle_radius = OBSTACLE_RADIUS
        obstacle_max_x = WINDOW_WIDTH - obstacle_radius
        local obstacle_x = math.random(obstacle_max_x)
        if obstacle_x < obstacle_radius then
            obstacle_x = obstacle_radius
        end

        obstacle_max_y = WINDOW_HEIGHT - obstacle_radius
        local obstacle_y = math.random(obstacle_max_y)
        if obstacle_y < obstacle_radius then
            obstacle_y = obstacle_radius
        end
        table.insert(obstacles, {x = obstacle_x, y = obstacle_y})
    end
end

-- pre:
-- pos: Devuelve true si hay un juego guardado
function M.isSavedGame()
    return savegame.loadSnakeState('free_mode') ~= nil
end

-- pre: 
-- pos: Se guardan los datos del juego si la aplicacion se cierra
function M.quit()
    if game_over then
        return true
    end
    savegame.saveSnakeState(snake_segments, obstacles, score, 'free_mode')
end

return M