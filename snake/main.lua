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
local button6X, button6Y = columnWidth + 150, button5Y + 100
local button7X, button7Y = columnWidth - 150, button5Y + 100

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
local scores = require('snake.modes.scores.scores')

local ticks = 1/60
local acumulador = 0

--pre: los archivos de musica tienen que existir en la carpeta, setWidth, setHeight son valores numéricos definidos
-- pos: Configura la ventana del juego, carga archivos de audio, y ajusta la configuracion de sonido
function love.load()
    love.window.setTitle("La Viborita")
    love.window.setMode(setWidth, setHeight, {resizable=false})
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
end

--pre: dt, acumulador y ticks tiene que estar definido
--pos: Actualiza el estado del juego acumulando tiempo y llamando a la función update cuando es necesario
function love.update(dt)
    acumulador = acumulador + dt
    if acumulador >= ticks then
        update()
        acumulador = acumulador - ticks
    end
end

--pre: 
-- pos: Actualiza el estado del juego según el estado actual y la posición del mouse.
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
    elseif gameState == "loading_one_player" then
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
    elseif gameState == "scores" then
        scores.update()
    end
end

--pre: 
-- pos: Dibuja elementos para la pantalla de carga de partida guardada en la ventana de Love2D.
function drawLoadingSavedGame()
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
end

--pre: 
--pos: Dibuja elementos en la ventana segun el estado actual del juego.
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
    end
end

-- pre: x, y, button, istouch y presses son valores numericos
-- pos: Actualiza el estado del juego segun la posicion del mouse y el estado actual del juego.
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
                -- if labyrinth.isSavedGame() then
                --     gameState = "loading_labyrinth_mode"
                -- else
                --     labyrinth.load(false)
                --     gameState = "labyrinth"
                -- end
                --Acá no sé dónde poner labyrinth y dónde modo_laberinto
                labyrinth.load()
                gameState = "labyrinth"
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
            if isMouseOver(button1X, button1Y, buttonWidth, buttonHeight) then
                one_player.load(true)
                gameState = "one_player"
            elseif isMouseOver(button2X, button2Y, buttonWidth, buttonHeight) then
                one_player.load(false)
                gameState = "one_player"
            end
        elseif gameState == "loading_two_players" then
            if isMouseOver(button1X, button1Y, buttonWidth, buttonHeight) then
                two_players.load(true)
                gameState = "two_players"
            elseif isMouseOver(button2X, button2Y, buttonWidth, buttonHeight) then
                two_players.load(false)
                gameState = "two_players"
            end
        elseif gameState == "loading_free_mode" then
            if isMouseOver(button1X, button1Y, buttonWidth, buttonHeight) then
                free_mode.load(true)
                gameState = "free_mode"
            elseif isMouseOver(button2X, button2Y, buttonWidth, buttonHeight) then
                free_mode.load(false)
                gameState = "free_mode"
            end
        elseif gameState == "loading_labyrinth_mode" then
            -- if isMouseOver(button1X, button1Y, buttonWidth, buttonHeight) then
            --     labyrinth.load(true)
            --     gameState = "labyrinth"
            -- elseif isMouseOver(button2X, button2Y, buttonWidth, buttonHeight) then
            --     labyrinth.load(false)
            --     gameState = "labyrinth"
            -- end
        elseif gameState == "loading_inverted_mode" then
            if isMouseOver(button1X, button1Y, buttonWidth, buttonHeight) then
                inverted.load(true)
                gameState = "inverted"
            elseif isMouseOver(button2X, button2Y, buttonWidth, buttonHeight) then
                inverted.load(false)
                gameState = "inverted"
            end
        end
    end
end

-- pre: x
-- pos: Dibuja un boton en las coordenadas x, y con el texto centrado.
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

-- pre: x, y, width y height son numero reales
-- pos: Retorna true si la posicion actual del mouse esta dentro del area definida por x, y, width y height, sino retorna false
function isMouseOver(x, y, width, height)
    local mouseX, mouseY = love.mouse.getPosition()
    return mouseX >= x and mouseX <= x + width and mouseY >= y and mouseY <= y + height
end

--Pre: 
--Pos: sale del juego dependiendo del modo
function love.quit()
    if gameState == "one_player" then
        one_player.quit()
    elseif gameState == "two_players" then
        two_players.quit()
    elseif gameState == "free_mode" then
        free_mode.quit()
    -- elseif gameState == "labyrinth" then
    --     labyrinth.quit()
    elseif gameState == "inverted" then
        inverted.quit()
    end
end