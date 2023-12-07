local restartButtonPressed = false
local ganador = ""
local perdedor = ""

local function dibujarFondo()
    love.graphics.setBackgroundColor(1, 0.6, 0) 
end

local function dibujarGanadorPerdedor(ganador, perdedor)
    love.graphics.setColor(0, 0, 0)
    
    local font = love.graphics.getFont()
    
    love.graphics.printf("JUGADOR GANADOR", 50, 270, love.graphics.getWidth() - 100, "center")
    love.graphics.printf(ganador, 50, 320, love.graphics.getWidth() - 100, "center")

    love.graphics.printf("JUGADOR PERDEDOR", 50, 370, love.graphics.getWidth() - 100, "center")
    love.graphics.printf(perdedor, 50, 420, love.graphics.getWidth() - 100, "center")
end

local function dibujarRectangulo()
    love.graphics.setColor(0.8, 0.8, 0.6) 
    love.graphics.rectangle("fill", 50, 200, love.graphics.getWidth() - 100, 300, 10, 10)
end

local function dibujarTexto()
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("El juego ha finalizado!", 0, 100, love.graphics.getWidth(), "center")
end

local function dibujarBotones()
    local buttonWidth = 220
    local buttonHeight = 70
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

local FuncionesAuxiliares = {}

function FuncionesAuxiliares.mostrarPantallaFinal(score, ganador, perdedor)
    dibujarFondo()
    dibujarRectangulo()
    dibujarTexto()
    dibujarGanadorPerdedor(ganador, perdedor)
    dibujarBotones()
end

function love.mousepressed(x, y, button, istouch, presses)
    manejarClic(x, y, button)
end

return FuncionesAuxiliares