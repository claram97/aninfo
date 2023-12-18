-- Generate 2 columns to locate the buttons.
local constants = require('snake.modes.constants')

width = WINDOW_WIDTH
height = WINDOW_HEIGHT

local columnWidth = width / 2

-- Variables to store button dimensions
local buttonWidth, buttonHeight = 200, 50

-- Nuevos valores proporcionales a la pantalla
local button1X, button1Y = width * 0.35, height * 0.3333
local button2X, button2Y = width * 0.35, height * 0.5
local button3X, button3Y = width * 0.65, height * 0.3333
local button4X, button4Y = width * 0.65, height * 0.5
local button5X, button5Y = width * 0.5, (height * 0.5) + 100
local button6X, button6Y = width * 0.65, button5Y + 100
local button7X, button7Y = width * 0.35, button5Y + 100

local buttonLoadX, buttonLoadY = width/2, height/3
local buttonStartX, buttonStartY = width/2, height/2

-- Colors
local backgroundColor = {0.95, 0.95, 0.9, 0.5}
local buttonColor = {0.4, 0.4, 0.8}
local buttonConfigColor = {0.2, 0.7, 0.2}
local buttonHoverColor = {0.6, 0.6, 1}
local backgroundImage = love.graphics.newImage('assets/imagen-snake.png')

-- Variables to store button state (hovered or not)
local button1Hovered = false
local button2Hovered = false
local button3Hovered = false

-- Variables to store the load game button state
local onePlayerButton1Hovered = false
local onePlayerButton2Hovered = false

-- variables to store fonts
local fontTitle = love.graphics.newFont(60)
local fontBody = love.graphics.newFont(25)

-- state
local gameState = "menu"

local one_player = require('snake.modes.modo_un_jugador.one_player')
local two_players = require('snake.modes.modo_dos_jugadores.two_players')
local free_mode = require('snake.modes.modo_libre.modo_libre')
local labyrinth = require('snake.modes.modo_laberinto.modo_laberinto')
local inverted = require('snake.modes.modo_invertido.modo_invertido')
local configuracion = require('snake.modes.configuracion.configuracion')
local scores = require('snake.modes.scores.scores')
local pantallaPausa = require('snake.pantalla_pausa')

local ticks = 1/60
local acumulador = 0

function love.load()
    love.window.setTitle("La Viborita")
    musica_fondo = love.audio.newSource("musica.mp3", "stream")
    sonido_comer = love.audio.newSource("valentin.mp3", "static")
    musica_fondo:setLooping(true) 
    musica_fondo:play()
    local config = configuracion.load()
    if config.sound == true then
        love.audio.play(musica_fondo)
    end
    if config.sound == false then
        love.audio.stop(musica_fondo)
    end

    if config.fullScreen then
        love.window.setMode(BIG_WINDOW_WIDTH, BIG_WINDOW_HEIGHT, {fullscreen = false})
        width = BIG_WINDOW_WIDTH
        height = BIG_WINDOW_HEIGHT
        button1X, button1Y = width * 0.35 + 25, height * 0.3333
        button2X, button2Y = width * 0.35 + 25, height * 0.5
        button3X, button3Y = width * 0.65 + 25, height * 0.3333
        button4X, button4Y = width * 0.65 + 25, height * 0.5
        button5X, button5Y = width * 0.5 + 25, (height * 0.5) + 100
        button6X, button6Y = width * 0.65 + 25, button5Y + 100
        button7X, button7Y = width * 0.35 + 25, button5Y + 100
    else
        love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen = false})
        width = WINDOW_WIDTH
        height = WINDOW_HEIGHT
    end

    -- Define the toggle pause key for the P key
    love.keypressed = function(key)
        if key == "." then
            togglePause()
        end
    end
end

function love.update(dt)
    acumulador = acumulador + dt
    if acumulador >= ticks then
        update()
        acumulador = acumulador - ticks
    end
end

function update()
    -- Check if the mouse is over the buttons
    if gameState == "menu" then
        button1Hovered = isMouseOver(button1X, button1Y, buttonWidth, buttonHeight)
        button2Hovered = isMouseOver(button2X, button2Y, buttonWidth, buttonHeight)
        button3Hovered = isMouseOver(button3X, button3Y, buttonWidth, buttonHeight)
        button4Hovered = isMouseOver(button4X, button4Y, buttonWidth, buttonHeight)
        button5Hovered = isMouseOver(button5X, button5Y, buttonWidth, buttonHeight)
        button6Hovered = isMouseOver(button6X, button6Y, buttonWidth, buttonHeight)
        button7Hovered = isMouseOver(button7X, button7Y, buttonWidth, buttonHeight)
    elseif gameState == "loading_one_player" or gameState == "loading_two_players" or gameState == "loading_free_mode" or gameState == "loading_labyrinth_mode" or gameState == "loading_inverted_mode" then
        local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
        if screenWidth == WINDOW_WIDTH then
            onePlayerButton1Hovered = isMouseOver(screenWidth * 0.5, screenHeight * 0.35, buttonWidth, buttonHeight)
            onePlayerButton2Hovered = isMouseOver(screenWidth * 0.5, screenHeight * 0.45, buttonWidth, buttonHeight)
        else
            onePlayerButton1Hovered = isMouseOver(screenWidth * 0.5, screenHeight * 0.40, buttonWidth, buttonHeight)
            onePlayerButton2Hovered = isMouseOver(screenWidth * 0.5, screenHeight * 0.50, buttonWidth, buttonHeight)
        end
    elseif gameState == "one_player" then
        one_player.update()
    elseif gameState == "two_players" then
        two_players.update()
    elseif gameState == "free_mode" then
        free_mode.update()
    elseif gameState == "labyrinth" then
        labyrinth.update()
    elseif gameState == "inverted" then
        inverted.update()
    elseif gameState == "configuracion" then
        configuracion.update()
    elseif gameState == "scores" then
        scores.update()
    elseif gameState == "paused" then
        --
    end
end

local last_mode = "menu"
function togglePause() 
    if gameState == "menu" then
        return
    end

    if gameState == "paused" then
        gameState = last_mode
    else
        last_mode = gameState
        gameState = "paused"
    end
end

function drawLoadingSavedGame()
    -- Set background color
    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(backgroundImage, 0, 0, 0, width / backgroundImage:getWidth(), height / backgroundImage:getHeight())
    love.graphics.setColor(backgroundColor)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    -- Draw title
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(fontTitle)
    love.graphics.printf("¿Queres continuar tu ultima partida?", 0, height / 6, love.graphics.getWidth(), "center")
    love.graphics.setFont(fontBody)

    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    if screenWidth == WINDOW_WIDTH then
        drawButton(screenWidth * 0.5, screenHeight * 0.35 , "Yes", onePlayerButton1Hovered, buttonColor)
        drawButton(screenWidth * 0.5, screenHeight * 0.45, "No", onePlayerButton2Hovered, buttonColor)
    else
        drawButton(screenWidth * 0.5, screenHeight * 0.40 , "Yes", onePlayerButton1Hovered, buttonColor)
        drawButton(screenWidth * 0.5, screenHeight * 0.50, "No", onePlayerButton2Hovered, buttonColor)
    end    
end

function love.draw()
    if gameState == "menu" then
        -- Set background color
        love.graphics.setColor(1, 1, 1)

        love.graphics.draw(backgroundImage, 0, 0, 0, width / backgroundImage:getWidth(), height / backgroundImage:getHeight())
        love.graphics.setColor(backgroundColor)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        -- Draw title
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(fontTitle)
        love.graphics.printf("La Viborita", 0, height / 6, love.graphics.getWidth(), "center")
        love.graphics.setFont(fontBody)

        -- Draw buttons
        drawButton(button1X, button1Y, "Clásico", button1Hovered, buttonColor)
        drawButton(button2X, button2Y, "2 Jugadores", button2Hovered, buttonColor)
        drawButton(button3X, button3Y, "Libre", button3Hovered, buttonColor)
        drawButton(button4X, button4Y, "Laberinto", button4Hovered, buttonColor)
        drawButton(button5X, button5Y, "Invertido", button5Hovered, buttonColor)
        drawButton(button6X, button6Y, "Configuración", button6Hovered, buttonConfigColor)
        drawButton(button7X, button7Y, "High scores", button7Hovered, buttonConfigColor)

    elseif gameState == "loading_one_player" then
        drawLoadingSavedGame()
    elseif gameState == "loading_two_players" then
        drawLoadingSavedGame()
    elseif gameState == "loading_free_mode" then
        drawLoadingSavedGame()
    elseif gameState == "loading_labyrinth_mode" then
        drawLoadingSavedGame()
    elseif gameState == "loading_inverted_mode" then
        drawLoadingSavedGame()    
    elseif gameState == "one_player" then
        one_player.draw()
    elseif gameState == "two_players" then
        two_players.draw()
    elseif gameState == "free_mode" then
        free_mode.draw()
    elseif gameState == "labyrinth" then
        labyrinth.draw()
    elseif gameState == "inverted" then
        inverted.draw()
    elseif gameState == "configuracion" then
        configuracion.draw()
    elseif gameState == "scores" then
        scores.draw()
    elseif gameState == "paused" then
        pantallaPausa.draw()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    if button == 1 then
        if gameState == "menu" then
            if isMouseOver(button1X, button1Y, buttonWidth, buttonHeight) then
                if one_player.isSavedGame() then
                    gameState = "loading_one_player"
                else
                    one_player.load(false)
                    gameState = "one_player"
                end
            elseif isMouseOver(button2X, button2Y, buttonWidth, buttonHeight) then
                if two_players.isSavedGame() then
                    gameState = "loading_two_players"
                else
                    two_players.load(false)
                    gameState = "two_players"
                end
            elseif isMouseOver(button3X, button3Y, buttonWidth, buttonHeight) then
                if free_mode.isSavedGame() then
                    gameState = "loading_free_mode"
                else
                    free_mode.load(false)
                    gameState = "free_mode"
                end
            elseif isMouseOver(button4X, button4Y, buttonWidth, buttonHeight) then
                if labyrinth.isSavedGame() then
                    gameState = "loading_labyrinth_mode"
                else
                    labyrinth.load(false)
                    gameState = "labyrinth"
                end
            elseif isMouseOver(button5X, button5Y, buttonWidth, buttonHeight) then
                if inverted.isSavedGame() then
                    gameState = "loading_inverted_mode"
                else
                    inverted.load(false)
                    gameState = "inverted"
                end
            elseif isMouseOver(button6X, button6Y, buttonWidth, buttonHeight) then
                configuracion.load()
                gameState = "configuracion"
            elseif isMouseOver(button7X, button7Y, buttonWidth, buttonHeight) then
                scores.load()
                gameState = "scores"
            end
        elseif gameState == "configuracion" then
            configuracion.mousepressed(x, y, button, istouch, presses)
        elseif gameState == "loading_one_player" then
            local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
            if screenWidth == WINDOW_WIDTH then
                if isMouseOver(screenWidth * 0.5, screenHeight * 0.35, buttonWidth, buttonHeight) then
                    one_player.load(true)
                    gameState = "one_player"
                elseif isMouseOver(screenWidth * 0.5, screenHeight * 0.45, buttonWidth, buttonHeight) then
                    one_player.load(false)
                    gameState = "one_player"
                end
            else
                if isMouseOver(screenWidth * 0.5, screenHeight * 0.40, buttonWidth, buttonHeight) then
                    one_player.load(true)
                    gameState = "one_player"
                elseif isMouseOver(screenWidth * 0.5, screenHeight * 0.50, buttonWidth, buttonHeight) then
                    one_player.load(false)
                    gameState = "one_player"
                end
            end
        elseif gameState == "loading_two_players" then
            local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
            if screenWidth == WINDOW_WIDTH then
                if isMouseOver(screenWidth * 0.5, screenHeight * 0.35, buttonWidth, buttonHeight) then
                    one_player.load(true)
                    gameState = "one_player"
                elseif isMouseOver(screenWidth * 0.5, screenHeight * 0.45, buttonWidth, buttonHeight) then
                    one_player.load(false)
                    gameState = "one_player"
                end
            else
                if isMouseOver(screenWidth * 0.5, screenHeight * 0.40, buttonWidth, buttonHeight) then
                    one_player.load(true)
                    gameState = "one_player"
                elseif isMouseOver(screenWidth * 0.5, screenHeight * 0.50, buttonWidth, buttonHeight) then
                    one_player.load(false)
                    gameState = "one_player"
                end
            end
        elseif gameState == "loading_free_mode" then
            local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
            if screenWidth == WINDOW_WIDTH then
                if isMouseOver(screenWidth * 0.5, screenHeight * 0.35, buttonWidth, buttonHeight) then
                    one_player.load(true)
                    gameState = "one_player"
                elseif isMouseOver(screenWidth * 0.5, screenHeight * 0.45, buttonWidth, buttonHeight) then
                    one_player.load(false)
                    gameState = "one_player"
                end
            else
                if isMouseOver(screenWidth * 0.5, screenHeight * 0.40, buttonWidth, buttonHeight) then
                    one_player.load(true)
                    gameState = "one_player"
                elseif isMouseOver(screenWidth * 0.5, screenHeight * 0.50, buttonWidth, buttonHeight) then
                    one_player.load(false)
                    gameState = "one_player"
                end
            end
        elseif gameState == "loading_labyrinth_mode" then
            local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
            if screenWidth == WINDOW_WIDTH then
                if isMouseOver(screenWidth * 0.5, screenHeight * 0.35, buttonWidth, buttonHeight) then
                    one_player.load(true)
                    gameState = "one_player"
                elseif isMouseOver(screenWidth * 0.5, screenHeight * 0.45, buttonWidth, buttonHeight) then
                    one_player.load(false)
                    gameState = "one_player"
                end
            else
                if isMouseOver(screenWidth * 0.5, screenHeight * 0.40, buttonWidth, buttonHeight) then
                    one_player.load(true)
                    gameState = "one_player"
                elseif isMouseOver(screenWidth * 0.5, screenHeight * 0.50, buttonWidth, buttonHeight) then
                    one_player.load(false)
                    gameState = "one_player"
                end
            end
        elseif gameState == "loading_inverted_mode" then
            local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
            if screenWidth == WINDOW_WIDTH then
                if isMouseOver(screenWidth * 0.5, screenHeight * 0.35, buttonWidth, buttonHeight) then
                    one_player.load(true)
                    gameState = "one_player"
                elseif isMouseOver(screenWidth * 0.5, screenHeight * 0.45, buttonWidth, buttonHeight) then
                    one_player.load(false)
                    gameState = "one_player"
                end
            else
                if isMouseOver(screenWidth * 0.5, screenHeight * 0.40, buttonWidth, buttonHeight) then
                    one_player.load(true)
                    gameState = "one_player"
                elseif isMouseOver(screenWidth * 0.5, screenHeight * 0.50, buttonWidth, buttonHeight) then
                    one_player.load(false)
                    gameState = "one_player"
                end
            end
        elseif gameState == "scores" then
            if scores.mousepressed(x, y, button, istouch, presses) then
                gameState = "menu"
            end
        end

    end
end

function drawButton(x, y, text, hovered, color)
    -- Set button color based on hover state
    if hovered then
        color = buttonHoverColor
    end

    -- Draw button background
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", x - buttonWidth / 2, y, buttonWidth, buttonHeight, 15, 15)

    -- Draw button text
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(text, x - buttonWidth / 2, y + 10, buttonWidth, "center")
end

function isMouseOver(x, y, width, height)
    local mouseX, mouseY = love.mouse.getPosition()
    return mouseX >= x - buttonWidth / 2 and mouseX <= x + buttonWidth / 2 and mouseY >= y and mouseY <= y + buttonHeight
end

function love.quit()
    if gameState == "one_player" then
        one_player.quit()
    elseif gameState == "two_players" then
        two_players.quit()
    elseif gameState == "free_mode" then
        free_mode.quit()
    elseif gameState == "inverted" then
        inverted.quit()
    elseif gameState == "labyrinth" then
        labyrinth.quit()
    elseif gameState == "paused" then
        if last_mode == "one_player" then
            one_player.quit()
        elseif last_mode == "two_players" then
            two_players.quit()
        elseif last_mode == "free_mode" then
            free_mode.quit()
        elseif last_mode == "inverted" then
            inverted.quit()
        elseif last_mode == "labyrinth" then
            labyrinth.quit()
        end
    end
end