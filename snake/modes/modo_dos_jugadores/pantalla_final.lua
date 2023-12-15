local inputText = ""
local maxCharacters = 23

local function dibujarFondo()
    love.graphics.setBackgroundColor(1, 0.6, 0) 
    love.graphics.setColor(1, 0.6, 0) 
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight(), 0, 0)
end

local function dibujarRectangulo()
    love.graphics.setColor(0.8, 0.8, 0.6) 
    love.graphics.rectangle("fill", 50, 160, love.graphics.getWidth() - 100, 200, 10, 10)
end

local function dibujarTexto()
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("El juego ha finalizado!", 0, 75, love.graphics.getWidth(), "center")
    love.graphics.printf("En esta partida has conseguido", 100, 195, love.graphics.getWidth() - 200, "center")
end

local function dibujarCirculo(score)
    love.graphics.setColor(1, 1, 0) 
    local circleRadius = 30
    local circleX = love.graphics.getWidth() / 2
    local circleY = 300 
    love.graphics.circle("fill", circleX, circleY, circleRadius)

    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(font)
    
    local scoreText = tostring(score)
    local scoreTextWidth = font:getWidth(scoreText)
    local scoreTextHeight = font:getHeight(scoreText)
    
    local textX = circleX - scoreTextWidth / 2
    local textY = circleY - scoreTextHeight / 2
    
    love.graphics.print(scoreText, textX, textY)

    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("puntos", circleX + circleRadius + 10, circleY - 10, love.graphics.getWidth(), "left")
end


local function dibujarBotones()
    local buttonWidth = 200  -- Aumenta el ancho del botón
    local buttonHeight = 80   -- Aumenta la altura del botón
    local cornerRadius = 10
    local restartButtonX = (love.graphics.getWidth() - buttonWidth) / 4
    local restartButtonY = 575

    -- Botón "Volver a Jugar"
    love.graphics.setColor(0.1, 0.5, 0.1)
    love.graphics.rectangle("fill", restartButtonX, restartButtonY, buttonWidth, buttonHeight, cornerRadius, cornerRadius)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Volver a jugar (F10)", restartButtonX, restartButtonY + 15, buttonWidth, "center")

    -- Botón "Menú"
    local menuButtonX = 2 * (love.graphics.getWidth() - buttonWidth) / 4 + buttonWidth
    local menuButtonY = 575

    love.graphics.setColor(0.1, 0.5, 0.1)
    love.graphics.rectangle("fill", menuButtonX, menuButtonY, buttonWidth, buttonHeight, cornerRadius, cornerRadius)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Menú principal (F11)", menuButtonX, menuButtonY + 15, buttonWidth, "center")

    local sendScoreButtonWidth = 200
    local sendScoreButtonHeight = 80
    local sendScoreButtonX = 475
    local sendScoreButtonY = 485

    love.graphics.setColor(0.1, 0.5, 0.1)
    love.graphics.rectangle("fill", sendScoreButtonX, sendScoreButtonY, sendScoreButtonWidth, sendScoreButtonHeight, cornerRadius, cornerRadius)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Send score (F12)", sendScoreButtonX, sendScoreButtonY + 13, buttonWidth, "center")
end

function dibujarTextEntry()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 400, 400, 350, 50)
    love.graphics.setColor(0.1, 0.5, 0.1)
    love.graphics.rectangle("line", 400, 400, 350, 50)
    love.graphics.setColor(0, 0, 0)
end

function love.textinput(text)
    -- Limitar la cantidad de caracteres
    if #inputText < maxCharacters then
        -- Verificar si el texto ingresado contiene solo números y letras
        if text:match("[%w ]") then
            inputText = inputText .. text
        end
    end
end

local FuncionesExtras = {}

function FuncionesExtras.mostrarPantallaFinal(score)
    dibujarFondo()
    dibujarRectangulo()
    dibujarTexto()
    dibujarCirculo(score)
    dibujarBotones()
    dibujarTextEntry()
    love.graphics.printf(inputText, 400, 410, 350, "center")
end

function FuncionesExtras.getTextLenght()
    return #inputText
end

function FuncionesExtras.getText()
    return inputText
end

function FuncionesExtras.load()
    inputText = ""
end

return FuncionesExtras