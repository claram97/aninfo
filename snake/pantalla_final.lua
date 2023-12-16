local inputText = ""
local maxCharacters = 22

-- pre: Ninguna
-- pos: Establece el color de fondo en RGB(1, 0.6, 0)
local function dibujarFondo()
    love.graphics.setBackgroundColor(1, 0.6, 0) 
end

-- pre: Ninguna
-- pos: Establece el color de trazo en RGB(0.8, 0.8, 0.6) y dibuja un rectángulo relleno en la pantalla con esquinas redondeadas
local function dibujarRectangulo()
    love.graphics.setColor(0.8, 0.8, 0.6) 
    love.graphics.rectangle("fill", 50, 160, love.graphics.getWidth() - 100, 200, 10, 10)
end

-- pre: Ninguna
-- pos: Establece el color de trazo en RGB(0, 0, 0) y dibuja dos bloques de texto centrados en la pantalla, indicando que el juego ha finalizado junto a su score
local function dibujarTexto()
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("El juego ha finalizado!", 0, 75, love.graphics.getWidth(), "center")
    love.graphics.printf("En esta partida has conseguido", 100, 195, love.graphics.getWidth() - 200, "center")
end

-- pre: Se espera que 'font' sea una fuente de texto válida y que 'score' sea un número.
-- pos: Dibuja un círculo amarillo relleno en la pantalla, con un texto en el centro indicando el puntaje y "Puntaje" al lado

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

-- pre: Ninguna
-- pos: Dibuja dos botones en la pantalla con anchos y alturas específicos, con texto centrado en cada botón, uno para volver a jugar y otro volver al menu
local function dibujarBotones()
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
    
    local buttonWidth = 200  -- Aumenta el ancho del botón
    local buttonHeight = 80   -- Aumenta la altura del botón
    local cornerRadius = 10
    local restartButtonX = (love.graphics.getWidth() - buttonWidth) / 4
    local restartButtonY = screenHeight * 0.71875  -- 575/800

    -- Botón "Volver a Jugar"
    love.graphics.setColor(0.1, 0.5, 0.1)
    love.graphics.rectangle("fill", restartButtonX, restartButtonY, buttonWidth, buttonHeight, cornerRadius, cornerRadius)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Volver a jugar (F10)", restartButtonX, restartButtonY + 15, buttonWidth, "center")

    -- Botón "Menú"
    local menuButtonX = 2 * (love.graphics.getWidth() - buttonWidth) / 4 + buttonWidth
    local menuButtonY = screenHeight * 0.71875  -- 575/800

    love.graphics.setColor(0.1, 0.5, 0.1)
    love.graphics.rectangle("fill", menuButtonX, menuButtonY, buttonWidth, buttonHeight, cornerRadius, cornerRadius)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Menú principal (F11)", menuButtonX, menuButtonY + 15, buttonWidth, "center")

    local sendScoreButtonWidth = 200
    local sendScoreButtonHeight = 80
    local sendScoreButtonX = screenWidth * 0.3958  -- 475/1200
    local sendScoreButtonY = screenHeight * 0.60625  -- 485/800

    love.graphics.setColor(0.1, 0.5, 0.1)
    love.graphics.rectangle("fill", sendScoreButtonX, sendScoreButtonY, sendScoreButtonWidth, sendScoreButtonHeight, cornerRadius, cornerRadius)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Send score (F12)", sendScoreButtonX, sendScoreButtonY + 13, buttonWidth, "center")
end

function dibujarTextEntry()
    local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()

    -- Calcula los valores relativos a la pantalla
    local x = screenWidth * 0.3333  -- 400/1200
    local y = screenHeight * 0.5    -- 400/800
    local width = screenWidth * 0.2917  -- 350/1200
    local height = screenHeight * 0.0625  -- 50/800

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", x, y, width, height)

    love.graphics.setColor(0.1, 0.5, 0.1)
    love.graphics.rectangle("line", x, y, width, height)

    love.graphics.setColor(0, 0, 0)
    if screenWidth == BIG_WINDOW_WIDTH then
        x = x + 65
    end
    love.graphics.printf(inputText, x, y + 5, 350, "center")
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

-- pre: 'score' es un número que representa el puntaje del jugador.
-- pos: Dibuja la pantalla final del juego, incluyendo el fondo, un rectángulo, texto informativo, un círculo con el puntaje
function FuncionesExtras.mostrarPantallaFinal(score)
    dibujarFondo()
    dibujarRectangulo()
    dibujarTexto()
    dibujarCirculo(score)
    dibujarBotones()
    dibujarTextEntry()
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