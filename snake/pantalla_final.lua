-- pre: Ninguna
-- pos: Establece el color de fondo en RGB(1, 0.6, 0)
local function dibujarFondo()
    love.graphics.setBackgroundColor(1, 0.6, 0) 
end

-- pre: Ninguna
-- pos: Establece el color de trazo en RGB(0.8, 0.8, 0.6) y dibuja un rectángulo relleno en la pantalla con esquinas redondeadas
local function dibujarRectangulo()
    love.graphics.setColor(0.8, 0.8, 0.6) 
    love.graphics.rectangle("fill", 50, 200, love.graphics.getWidth() - 100, 200, 10, 10)
end

-- pre: Ninguna
-- pos: Establece el color de trazo en RGB(0, 0, 0) y dibuja dos bloques de texto centrados en la pantalla, indicando que el juego ha finalizado junto a su score
local function dibujarTexto()
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("El juego ha finalizado!", 0, 100, love.graphics.getWidth(), "center")
    love.graphics.printf("En esta partida has conseguido", 100, 220, love.graphics.getWidth() - 200, "center")
end

-- pre: Se espera que 'font' sea una fuente de texto válida y que 'score' sea un número.
-- pos: Dibuja un círculo amarillo relleno en la pantalla, con un texto en el centro indicando el puntaje y "Puntaje" al lado
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

-- pre: Ninguna
-- pos: Dibuja dos botones en la pantalla con anchos y alturas específicos, con texto centrado en cada botón, uno para volver a jugar y otro volver al menu
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

-- pre: Los parámetros 'x', 'y', y 'button' son números representando las coordenadas y el botón del mouse.
-- pos: Actualiza el estado de 'restartButtonPressed' a true si el clic del mouse ocurrió en las coordenadas del botón de reinicio
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

-- pre: 'score' es un número que representa el puntaje del jugador.
-- pos: Dibuja la pantalla final del juego, incluyendo el fondo, un rectángulo, texto informativo, un círculo con el puntaje
function FuncionesExtras.mostrarPantallaFinal(score)
    dibujarFondo()
    dibujarRectangulo()
    dibujarTexto()
    dibujarCirculo(score)
    dibujarBotones()
end

-- pre: 'x' e 'y' son coordenadas del mouse, 'button' es el botón del mouse presionado.
-- pos: maneja el clic del mouse, llamando a la función 'manejarClic' con las coordenadas y el botón correspondientes.
function love.mousepressed(x, y, button, istouch, presses)
    manejarClic(x, y, button)
end

return FuncionesExtras