-- main.lua

-- Variables to store button positions
local button1X, button1Y = 100, 200
local button2X, button2Y = 100, 250
local button3X, button3Y = 100, 300
local button4X, button4Y = 100, 350
local button5X, button5Y = 100, 400

-- Variables to store button dimensions
local buttonWidth, buttonHeight = 200, 50

-- Colors
local backgroundColor = {0.95, 0.95, 0.9}
local buttonColor = {0.4, 0.4, 0.8}
local buttonHoverColor = {0.6, 0.6, 1}
local backgroundImage = love.graphics.newImage('assets/imagen-snake.png')

-- Variables to store button state (hovered or not)
local button1Hovered = false
local button2Hovered = false
local button3Hovered = false

-- variables to store fonts
local fontTitle = love.graphics.newFont(60)
local fontBody = love.graphics.newFont(30)

-- state
local gameState = "menu"

local one_player = require('snake.modes.modo_un_jugador.one_player')
local two_players = require('snake.modes.modo_dos_jugadores.two_players')
local free_mode = require('snake.modes.modo_libre.modo_libre')
local labyrinth = require('snake.modes.modo_laberinto.modo_laberinto')
local inverted = require('snake.modes.modo_invertido.modo_invertido')

function love.load()
    love.window.setTitle("Menu Example")
    love.window.setMode(1200, 800, {resizable=false})
end

function love.update(dt)
    -- Check if the mouse is over the buttons
    if gameState == "menu" then
        button1Hovered = isMouseOver(button1X, button1Y, buttonWidth, buttonHeight)
        button2Hovered = isMouseOver(button2X, button2Y, buttonWidth, buttonHeight)
        button3Hovered = isMouseOver(button3X, button3Y, buttonWidth, buttonHeight)
        button4Hovered = isMouseOver(button4X, button4Y, buttonWidth, buttonHeight)
        button5Hovered = isMouseOver(button5X, button5Y, buttonWidth, buttonHeight)
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
    end
end

function love.draw()

    if gameState == "menu" then
        -- Set background color
        love.graphics.setColor(1, 1, 1)

        love.graphics.draw(backgroundImage, 0, 0, 0, love.graphics.getWidth() / backgroundImage:getWidth(), love.graphics.getHeight() / backgroundImage:getHeight())
        love.graphics.setColor(backgroundColor, 0.5)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        -- Draw title
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(fontTitle)
        love.graphics.printf("La Viborita", 0, 70, love.graphics.getWidth(), "center")
        love.graphics.setFont(fontBody)

        -- Draw buttons
        drawButton(button1X, button1Y, "Button 1", button1Hovered)
        drawButton(button2X, button2Y, "Button 2", button2Hovered)
        drawButton(button3X, button3Y, "Button 3", button3Hovered)
        drawButton(button4X, button4Y, "Button 4", button4Hovered)
        drawButton(button5X, button5Y, "Button 5", button5Hovered)

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
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if gameState == "menu" then
            if isMouseOver(button1X, button1Y, buttonWidth, buttonHeight) then
                one_player.load()
                gameState = "one_player"
            elseif isMouseOver(button2X, button2Y, buttonWidth, buttonHeight) then
                two_players.load()
                gameState = "two_players"
            elseif isMouseOver(button3X, button3Y, buttonWidth, buttonHeight) then
                free_mode.load()
                gameState = "free_mode"
            elseif isMouseOver(button4X, button4Y, buttonWidth, buttonHeight) then
                labyrinth.load()
                gameState = "labyrinth"
            elseif isMouseOver(button5X, button5Y, buttonWidth, buttonHeight) then
                inverted.load()
                gameState = "inverted"
            end
        end
    end
end

function drawButton(x, y, text, hovered)
    -- Set button color based on hover state
    local color = buttonColor
    if hovered then
        color = buttonHoverColor
    end

    -- Draw button background
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", x, y, buttonWidth, buttonHeight)

    -- Draw button text
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(text, x, y + 20, buttonWidth, "center")
end

function isMouseOver(x, y, width, height)
    local mouseX, mouseY = love.mouse.getPosition()
    return mouseX >= x and mouseX <= x + width and mouseY >= y and mouseY <= y + height
end
