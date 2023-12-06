-- main.lua

-- Variables to store window dimensions
local setWidth = 1200
local setHeight = 800

-- Generate 2 columns to locate the buttons.
local columnWidth = setWidth / 2

-- Variables to store button dimensions
local buttonWidth, buttonHeight = 200, 50

-- Variables to store button positions
local button1X, button1Y = columnWidth - 150, setHeight / 3
local button2X, button2Y = columnWidth - 150, setHeight / 2
local button3X, button3Y = columnWidth + 150, setHeight / 3
local button4X, button4Y = columnWidth + 150, setHeight / 2
local button5X, button5Y = columnWidth, (setHeight / 2) + 100
local button6X, button6Y = columnWidth, button5Y + 100

local buttonLoadX, buttonLoadY = setWidth/2, setHeight/3
local buttonStartX, buttonStartY = setWidth/2, setHeight/2

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

function love.load()
    love.window.setTitle("La Viborita")
    love.window.setMode(setWidth, setHeight, {resizable=false})
end

function love.update(dt)
    -- Check if the mouse is over the buttons
    if gameState == "menu" then
        button1Hovered = isMouseOver(button1X, button1Y, buttonWidth, buttonHeight)
        button2Hovered = isMouseOver(button2X, button2Y, buttonWidth, buttonHeight)
        button3Hovered = isMouseOver(button3X, button3Y, buttonWidth, buttonHeight)
        button4Hovered = isMouseOver(button4X, button4Y, buttonWidth, buttonHeight)
        button5Hovered = isMouseOver(button5X, button5Y, buttonWidth, buttonHeight)
        button6Hovered = isMouseOver(button6X, button6Y, buttonWidth, buttonHeight)
    elseif gameState == "loading_one_player" then
        onePlayerButton1Hovered = isMouseOver(button1X, button1Y, buttonWidth, buttonHeight)
        onePlayerButton2Hovered = isMouseOver(button2X, button2Y, buttonWidth, buttonHeight)
    elseif gameState == "loading_free_mode" then
        onePlayerButton1Hovered = isMouseOver(button1X, button1Y, buttonWidth, buttonHeight)
        onePlayerButton2Hovered = isMouseOver(button2X, button2Y, buttonWidth, buttonHeight)
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
    end
end

function love.draw()
    if gameState == "menu" then
        -- Set background color
        love.graphics.setColor(1, 1, 1)

        love.graphics.draw(backgroundImage, 0, 0, 0, setWidth / backgroundImage:getWidth(), setHeight / backgroundImage:getHeight())
        love.graphics.setColor(backgroundColor)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        -- Draw title
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(fontTitle)
        love.graphics.printf("La Viborita", 0, setHeight / 6, love.graphics.getWidth(), "center")
        love.graphics.setFont(fontBody)

        -- Draw buttons
        drawButton(button1X, button1Y, "Clásico", button1Hovered, buttonColor)
        drawButton(button2X, button2Y, "2 Jugadores", button2Hovered, buttonColor)
        drawButton(button3X, button3Y, "Libre", button3Hovered, buttonColor)
        drawButton(button4X, button4Y, "Laberinto", button4Hovered, buttonColor)
        drawButton(button5X, button5Y, "Invertido", button5Hovered, buttonColor)
        drawButton(button6X, button6Y, "Configuración", button6Hovered, buttonConfigColor)

    elseif gameState == "loading_one_player" or "loading_free_mode" then
        -- Set background color
        love.graphics.setColor(1, 1, 1)

        love.graphics.draw(backgroundImage, 0, 0, 0, setWidth / backgroundImage:getWidth(), setHeight / backgroundImage:getHeight())
        love.graphics.setColor(backgroundColor)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        -- Draw title
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(fontTitle)
        love.graphics.printf("¿Queres continuar tu ultima partida?", 0, setHeight / 6, love.graphics.getWidth(), "center")
        love.graphics.setFont(fontBody)

        -- Draw buttons
        drawButton(buttonLoadX, buttonLoadY, "Yes", onePlayerButton1Hovered, buttonColor)
        drawButton(buttonStartX, buttonStartY, "No", onePlayerButton2Hovered, buttonColor)
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
    end
end

function love.mousepressed(x, y, button, istouch, presses)
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
                two_players.load()
                gameState = "two_players"
            elseif isMouseOver(button3X, button3Y, buttonWidth, buttonHeight) then
                if free_mode.isSavedGame() then
                    gameState = "loading_free_mode"
                else
                    free_mode.load(false)
                    gameState = "free_mode"
                end
            elseif isMouseOver(button4X, button4Y, buttonWidth, buttonHeight) then
                labyrinth.load()
                gameState = "labyrinth"
            elseif isMouseOver(button5X, button5Y, buttonWidth, buttonHeight) then
                inverted.load()
                gameState = "inverted"
            elseif isMouseOver(button6X, button6Y, buttonWidth, buttonHeight) then
                configuracion.load()
                gameState = "configuracion"
            end
        elseif gameState == "configuracion" then
            configuracion.mousepressed(x, y, button, istouch, presses)
        elseif gameState == "loading_one_player" then
            if isMouseOver(button1X, button1Y, buttonWidth, buttonHeight) then
                one_player.load(true)
                gameState = "one_player"
            elseif isMouseOver(button2X, button2Y, buttonWidth, buttonHeight) then
                one_player.load(false)
                gameState = "one_player"
            end
        elseif gameState == "loading_free_mode" then
            if isMouseOver(buttonLoadX, buttonLoadY, buttonWidth, buttonHeight) then
                free_mode.load(true)
                gameState = "free_mode"
            elseif isMouseOver(buttonStartX, buttonStartY, buttonWidth, buttonHeight) then
                free_mode.load(false)
                gameState = "free_mode"
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
    return mouseX >= x and mouseX <= x + width and mouseY >= y and mouseY <= y + height
end

function love.quit()
    if gameState == "one_player" then
        one_player.quit()
    elseif gameState == "two_players" then
        two_players.quit()
    elseif gameState == "free_mode" then
        free_mode.quit()
    elseif gameState == "labyrinth" then
        labyrinth.quit()
    elseif gameState == "inverted" then
        inverted.quit()
    end
end