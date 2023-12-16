local function dibujarFondo()
    love.graphics.setBackgroundColor(1, 0.6, 0)
    love.graphics.setColor(1, 0.6, 0)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight(), 0, 0)
end

local function dibujarRectangulo()
    love.graphics.setColor(0.8, 0.8, 0.6)
    love.graphics.rectangle("fill", 50, 160, love.graphics.getWidth() - 100, 300, 10, 10)
end

local function dibujarTexto()
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("El juego ha finalizado!", 0, 75, love.graphics.getWidth(), "center")
    love.graphics.printf("En esta partida han conseguido:", 100, 195, love.graphics.getWidth() - 200, "center")
end

local function dibujarCirculo(score1, score2, ganador)
    local circleRadius = 30
    local circleX = love.graphics.getWidth() / 2
    local circleY = 300

    -- Dibujar círculo y puntaje para jugador 1
    love.graphics.setColor(1, 1, 0)
    --love.graphics.circle("fill", circleX, circleY, circleRadius)
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(font)
    local scoreText1 = "Jugador 1: " .. tostring(score1) .. " puntos"
    love.graphics.print(scoreText1, circleX - font:getWidth(scoreText1) / 2, circleY - font:getHeight(scoreText1) / 2 - 20)

    -- Dibujar círculo y puntaje para jugador 2
    love.graphics.setColor(1, 1, 0)
    --love.graphics.circle("fill", circleX, circleY+50, circleRadius)
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(font)
    local scoreText2 = "Jugador 2: " .. tostring(score2) .. " puntos"
    love.graphics.print(scoreText2, circleX - font:getWidth(scoreText2) / 2, circleY - font:getHeight(scoreText2) / 2 - 20 + 50)

    local ganadorText = "El " .. ganador .. " ha ganado"
    love.graphics.print(ganadorText, circleX - font:getWidth(scoreText2) / 2, circleY - font:getHeight(scoreText2) / 2 - 20 + 125)

    --love.graphics.printf("puntos", circleX + 50 + circleRadius + 10, circleY - 10, love.graphics.getWidth(), "left")
end


local function dibujarBotones()
    local buttonWidth = 200  -- Aumenta el ancho del botón
    local buttonHeight = 80   -- Aumenta la altura del botón
    local cornerRadius = 10
    local restartButtonX = (love.graphics.getWidth() - buttonWidth) / 4 * 1.4
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
end

local FuncionesExtras = {}

function FuncionesExtras.mostrarPantallaFinal(score1, score2, ganador)
    dibujarFondo()
    dibujarRectangulo()
    dibujarTexto()
    dibujarCirculo(score1, score2, ganador)
    dibujarBotones()
end

return FuncionesExtras