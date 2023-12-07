local function dibujarFondo()
    love.graphics.setBackgroundColor(1, 0.6, 0) 
end

local function dibujarRectangulo()
    love.graphics.setColor(0.8, 0.8, 0.6) 
    love.graphics.rectangle("fill", 50, 200, love.graphics.getWidth() - 100, 200, 10, 10)
end

local function dibujarTexto()
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("El juego ha finalizado!", 0, 100, love.graphics.getWidth(), "center")
    love.graphics.printf("En esta partida has conseguido", 100, 220, love.graphics.getWidth() - 200, "center")
end

local function dibujarCirculo(score)
    love.graphics.setColor(1, 1, 0) 
    local circleRadius = 30
    local circleX = love.graphics.getWidth() / 2
    local circleY = 350  
    love.graphics.circle("fill", circleX, circleY, circleRadius)

    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(font)
    
    local scoreText = tostring(score)
    local scoreTextWidth = font:getWidth(scoreText)
    local scoreTextHeight = font:getHeight(scoreText)
    
    local textX = circleX - scoreTextWidth / 2
    local textY = circleY - scoreTextHeight / 2
    
    love.graphics.print(scoreText, textX, textY)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Puntaje", circleX + circleRadius + 10, circleY - 10, love.graphics.getWidth(), "left")
end

local function dibujarBotones()
    local buttonWidth = 220  -- Aumenta el ancho del botón
    local buttonHeight = 70   -- Aumenta la altura del botón
    local cornerRadius = 10
    local restartButtonX = (love.graphics.getWidth() - buttonWidth) / 4
    local restartButtonY = 500

    -- Botón "Volver a Jugar"
    love.graphics.setColor(0.1, 0.5, 0.1)
    love.graphics.rectangle("fill", restartButtonX, restartButtonY, buttonWidth, buttonHeight, cornerRadius, cornerRadius)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Volver a jugar (Z)", restartButtonX, restartButtonY + 15, buttonWidth, "center")

    -- Botón "Menú"
    local menuButtonX = 2 * (love.graphics.getWidth() - buttonWidth) / 4 + buttonWidth
    local menuButtonY = 500

    love.graphics.setColor(0.1, 0.5, 0.1)
    love.graphics.rectangle("fill", menuButtonX, menuButtonY, buttonWidth, buttonHeight, cornerRadius, cornerRadius)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Menú principal (M)", menuButtonX, menuButtonY + 15, buttonWidth, "center")
end


local function manejarClic(x, y, button)
    local restartButtonX = (love.graphics.getWidth() - 200) / 4
    local restartButtonY = 500
    local buttonWidth = 200
    local buttonHeight = 50

    if button == 1 and not restartButtonPressed and x >= restartButtonX and x <= restartButtonX + buttonWidth and y >= restartButtonY and y <= restartButtonY + buttonHeight then
        restartButtonPressed = true
        love.event.quit("restart")
    end
end

local FuncionesExtras = {}

function FuncionesExtras.mostrarPantallaFinal(score)
    dibujarFondo()
    dibujarRectangulo()
    dibujarTexto()
    dibujarCirculo(score)
    dibujarBotones()
end

function love.mousepressed(x, y, button, istouch, presses)
    manejarClic(x, y, button)
end

return FuncionesExtras
