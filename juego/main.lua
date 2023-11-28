-- Import the body of the snake from assets
snakeBodyImage = love.graphics.newImage('assets/snake_body.png')
snakeHeadImage = love.graphics.newImage('assets/snake_head.png')
snakeBodyImage = love.graphics.newImage('assets/snake_body.png')

-- Define screen size
local screen_width = 1200
local screen_height = 800
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
local fruit_radius = 15
local fruit_color = {1, 0, 0}

-- Define flag to indicate if arrow key is pressed
local left_pressed = false
local right_pressed = false

-- Define score variable
local score = 0

-- Define table to store snake segments
local segment_distance = 45
local snake_segments = {{x=snake_x, y=snake_y}}
local fruitImage = love.graphics.newImage('assets/fruit_image.png') -- Reemplaza 'fruit_image.png' con el nombre real de tu archivo de imagen de fruta
-- Define function to draw snake and fruit
local background = love.graphics.newImage('assets/sprite_libre2.png')  -- Reemplaza 'nombre_de_tu_fondo.png' con el nombre real de tu archivo de fondo
   
function draw()
    love.graphics.setColor(1, 1, 1)  
    love.graphics.draw(background, 0, 0)
    love.graphics.setColor(snake_color)
    for i, segment in ipairs(snake_segments) do
        local imageToDraw = (i == 1) and snakeHeadImage or snakeBodyImage
        love.graphics.draw(imageToDraw, segment.x, segment.y)
    end
    love.graphics.setColor(1, 0, 0) -- Cambia a color rojo para la fruta
    love.graphics.draw(fruitImage, fruit_x - fruit_radius, fruit_y - fruit_radius) -- Ajusta la posición para centrar la imagen
end



-- Define function to update position of snake and fruit
local function update(dt)
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
            table.insert(snake_segments, {x=snake_x, y=snake_y})
            fruit_x = math.random(screen_width)
            fruit_y = math.random(screen_height)
        end

        -- Check if snake has collided with walls
        if snake_x < snake_radius then
            -- snake_x = screen_width - snake_radius
            game_over = true
        elseif snake_x > screen_width - snake_radius then
            -- snake_x = snake_radius
            game_over = true
        end
        if snake_y < snake_radius then
            -- snake_y = screen_height - snake_radius
            game_over = true
        elseif snake_y > screen_height - snake_radius then
            -- snake_y = snake_radius
            game_over = true
        end

        if snake_x < 0 or snake_x > screen_width or snake_y < 0 or snake_y > screen_height then
            -- Game over, reset variables
            snake_x = screen_width / 2
            snake_y = screen_height / 2
            snake_segments = {{x=snake_x, y=snake_y}}
            score = 0
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
    if game_over then
        return
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
function love.draw()
    draw()
end

function love.update(dt)
    update(dt)
end

function love.keypressed(key)
    keypressed(key)
end

function love.keyreleased(key)
    keyreleased(key)
end

-- Define function to load game assets
function love.load()
    -- Adjust window size and title
    love.window.setMode(screen_width, screen_height)
end