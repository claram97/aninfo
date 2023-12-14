-- Import the body of the snake from assets
local love = require("love")

snakeBodyImage = love.graphics.newImage('modes/modo_libre/assets/snake_body.png')
snakeHeadImage = love.graphics.newImage('modes/modo_libre/assets/snake_head.png')
fruitImage = love.graphics.newImage('modes/modo_libre/assets/fruit_image.png')
background = love.graphics.newImage('modes/modo_libre/assets/sprite_libre2.png')
FuncionesAuxiliares = require("snake.pantalla_final")
local configuracion = require('snake.modes.configuracion.configuracion')

local M = {}

-- Define screen size
local screen_width = 1200
local screen_height = 800

local WINDOW_WIDTH = 1200
local WINDOW_HEIGHT = 800

-- Define font
local font = love.graphics.newFont(40)

local game_over = false
-- Define initial position of snake and fruit
local snake_x = screen_width / 2
local snake_y = screen_height / 2
local fruit_x = math.random(screen_width)
local fruit_y = math.random(screen_height)

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
local OBSTACLE_MIN_RADIUS = 20
local OBSTACLE_MAX_RADIUS = 50
local OBSTACLE_APPARITION_FREQUENCY = 5


-- Define table to store snake segments
local segment_distance = 45
local snake_segments = {
    {x=snake_x, y=snake_y},
    {x=snake_x - segment_distance, y=snake_y}
}

-- Define table to store obstacles
local obstacles = {
    {x = 200, y = 300, radius = 50},
}

FuncionesAuxiliares = require("snake.modes.modo_libre.pantalla_final")
playerState = "playing"
local gameState = "playing"

function reiniciarTodo()
    -- Reiniciar todas las variables y estados a sus valores iniciales
    game_over = false
    snake_x = screen_width / 2
    snake_y = screen_height / 2
    fruit_x, fruit_y = getRandomFruitPosition()
    snake_speed = 3
    snake_angle = 0
    left_pressed = false
    right_pressed = false
    score = 0
    gameState = "playing"

    -- Reiniciar segmentos de la serpiente
    snake_segments = {
        {x = snake_x, y = snake_y},
        {x = snake_x - segment_distance, y = snake_y}
    }

    -- Reiniciar obstáculos
    obstacles = {
        {x = 200, y = 300, radius = 50},
    }
end

function draw()
    if playerState == "playing" then
        love.graphics.setColor(1, 1, 1)
        for i = 0, GAME_AREA_WIDTH - 1 do
            for j = 0, GAME_AREA_HEIGHT - 1 do
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
            love.graphics.circle('fill', obstacle.x, obstacle.y, obstacle.radius)
        end
    end

    if game_over then
        playerState = "not"
        FuncionesAuxiliares.mostrarPantallaFinal(score)

    end

end

-- Define function to update position of snake and fruit
local function update(dt)
    if Love.keyboard.isDown('m') and gameState == "not playing" then
        love.event.quit("restart")
    end

    if Love.keyboard.isDown('z')  and  gameState == "not playing" then
        gameState = "playing"
        reiniciarTodo()
        print(gameState)
    end
    
    if game_over then
        return
    end

    if not game_over then
        -- Update position of snake based on velocity
        if left_pressed then
            snake_angle = snake_angle - math.pi / 64
        elseif right_pressed then
            snake_angle = snake_angle + math.pi / 64
        end
        snake_x = snake_x + snake_speed * math.cos(snake_angle)
        snake_y = snake_y + snake_speed * math.sin(snake_angle)

        -- Check if snake has collided with fruit
        local distance = math.sqrt((snake_x - fruit_x)^2 + (snake_y - fruit_y)^2)
        if distance < snake_radius + fruit_radius then
            -- Update score, add new segment to snake, and move fruit to new location
            score = score + 1
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
            -- snake_x = screen_width - snake_radius + margin
            game_over = true
        elseif snake_x > screen_width then
            -- snake_x = snake_radius - margin
            game_over = true
        end
        if snake_y < 0 - margin then
            -- snake_y = screen_height - snake_radius + margin
            game_over = true
        elseif snake_y > screen_height then
            -- snake_y = snake_radius - margin
            game_over = true
        end

        -- Check if snake has collided with obstacles
        for _, obstacle in ipairs(obstacles) do
            local distance = math.sqrt((snake_x - obstacle.x)^2 + (snake_y - obstacle.y)^2)
            if distance < snake_radius + obstacle.radius then
                game_over = true
            end
        end

        -- Check if snake has collided with itself
        for i = 4, #snake_segments do
            local segment = snake_segments[i]
            local distance = math.sqrt((snake_x - segment.x)^2 + (snake_y - segment.y)^2)
            if distance < snake_radius * 2 then
                game_over = true
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

-- Define function to handle arrow key inputs and update velocity of snake
local function keypressed(key)
    if key == "left" then
        left_pressed = true
    elseif key == "right" then
        right_pressed = true
    end
end

local function keyreleased(key)
    if key == "left" then
        left_pressed = false
    elseif key == "right" then
        right_pressed = false
    end
end

-- Call update and draw functions in main loop
function M.draw()
    draw()
end

function M.update(dt)
    update(dt)
end

function love.keypressed(key)
    keypressed(key)
end

function love.keyreleased(key)
    keyreleased(key)
end

-- Define function to load game assets
function M.load()
    local config = configuracion.load()
    if config.sound == true then
        love.audio.play(musica_fondo)
    end
    if config.sound == false then
        love.audio.stop(musica_fondo)
    end

    local snakeBodyImage = love.graphics.newImage('modes/modo_libre/assets/snake_body.png')
    local snakeHeadImage = love.graphics.newImage('modes/modo_libre/assets/snake_head.png')
    local fruitImage = love.graphics.newImage('modes/modo_libre/assets/fruit_image.png')
    local background = love.graphics.newImage('modes/modo_libre/assets/sprite_libre2.png')

    -- Adjust window size and title
    love.window.setMode(screen_width, screen_height)

    -- Check if snake spawns near an obstacle and reposition it if necessary
    for _, obstacle in ipairs(obstacles) do
        local distance = math.sqrt((snake_x - obstacle.x)^2 + (snake_y - obstacle.y)^2)
        if distance < snake_radius + obstacle.radius then
            snake_x, snake_y = getRandomSnakePosition()
        end
    end

    -- Check if fruit spawns on an obstacle and reposition it if necessary
    for _, obstacle in ipairs(obstacles) do
        local distance = math.sqrt((fruit_x - obstacle.x)^2 + (fruit_y - obstacle.y)^2)
        if distance < fruit_radius + obstacle.radius then
            fruit_x, fruit_y = getRandomFruitPosition()
        end
    end

end

-- Define function to get a random position for the snake
function getRandomSnakePosition()
    local x = math.random(screen_width)
    local y = math.random(screen_height)
    for _, obstacle in ipairs(obstacles) do
        local distance = math.sqrt((x - obstacle.x)^2 + (y - obstacle.y)^2)
        if distance < snake_radius + obstacle.radius then
            return getRandomSnakePosition()
        end
    end
    return x, y
end

-- Define function to get a random position for the fruit
function getRandomFruitPosition()
    local x = math.random(screen_width)
    local y = math.random(screen_height)
    for _, obstacle in ipairs(obstacles) do
        local distance = math.sqrt((x - obstacle.x)^2 + (y - obstacle.y)^2)
        if distance < fruit_radius + obstacle.radius then
            return getRandomFruitPosition()
        end
    end
    return x, y
end

function updateObstacles()
    if score % OBSTACLE_APPARITION_FREQUENCY == 0 then
        local obstacle_radius = math.random(OBSTACLE_MAX_RADIUS)
        if obstacle_radius < OBSTACLE_MIN_RADIUS then
            obstacle_radius = OBSTACLE_MIN_RADIUS
        end
        obstacle_max_x = screen_width - obstacle_radius
        local obstacle_x = math.random(obstacle_max_x)
        if obstacle_x < obstacle_radius then
            obstacle_x = obstacle_radius
        end

        obstacle_max_y = screen_height - obstacle_radius
        local obstacle_y = math.random(obstacle_max_y)
        if obstacle_y < obstacle_radius then
            obstacle_y = obstacle_radius
        end
        table.insert(obstacles, {x = obstacle_x, y = obstacle_y, radius = obstacle_radius})
    end
end

return M