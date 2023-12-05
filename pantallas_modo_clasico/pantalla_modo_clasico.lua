local function dibujarFondo()
    love.graphics.setBackgroundColor(0.96, 0.86, 0.69)  -- Cambiado a un tono de beige
end

local function dibujarTexto()
    love.graphics.setColor(0, 0, 0)
    
    -- Almacenar la fuente original
    local originalFont = love.graphics.getFont()

    
    local fontSize = 80  -- cambiar fuentee
    local largeFont = love.graphics.newFont(fontSize)
    love.graphics.setFont(largeFont)

    love.graphics.printf("Modo Clásico", 0, 100, love.graphics.getWidth(), "center")

    love.graphics.setFont(originalFont)
end

local function dibujarBotones()
    local buttonWidth = 220
    local buttonHeight = 50
    local cornerRadius = 15
    local jugador1ButtonX = love.graphics.getWidth() / 4
    local jugador2ButtonX = 3 * love.graphics.getWidth() / 4
    local buttonY = 400

    love.graphics.setColor(0.2, 0.7, 0.2)  
    love.graphics.rectangle("fill", jugador1ButtonX - buttonWidth / 2, buttonY, buttonWidth, buttonHeight, cornerRadius, cornerRadius)

    love.graphics.setColor(1, 1, 1)  
    love.graphics.printf("Jugador 1", jugador1ButtonX - buttonWidth / 2, buttonY + 10, buttonWidth, "center")

    love.graphics.setColor(0.2, 0.7, 0.2)  
    love.graphics.rectangle("fill", jugador2ButtonX - buttonWidth / 2, buttonY, buttonWidth, buttonHeight, cornerRadius, cornerRadius)

    love.graphics.setColor(1, 1, 1)  
    love.graphics.printf("Jugador 2", jugador2ButtonX - buttonWidth / 2, buttonY + 10, buttonWidth, "center")
end

local function manejarClic(x, y, button)
    local buttonWidth = 220
    local buttonHeight = 50
    local jugador1ButtonX = love.graphics.getWidth() / 4
    local jugador2ButtonX = 3 * love.graphics.getWidth() / 4
    local buttonY = 400

    if button == 1 and x >= jugador1ButtonX - buttonWidth / 2 and x <= jugador1ButtonX + buttonWidth / 2 and y >= buttonY and y <= buttonY + buttonHeight then
        -- charo aca agrega aquí la lógica del boton jugador 1
        print("Clic en Jugador 1") --esto es un ejemplo que puse para ver si andaba
    elseif button == 1 and x >= jugador2ButtonX - buttonWidth / 2 and x <= jugador2ButtonX + buttonWidth / 2 and y >= buttonY and y <= buttonY + buttonHeight then
        -- charo aca agrega aquí la lógica del boton jugadores 2
        print("Clic en Jugador 2") --idem arriba
    end
end

local FuncionesExtras = {}

function FuncionesExtras.mostrarPantallaInicio()
    dibujarFondo()
    dibujarTexto()
    dibujarBotones()
end

function FuncionesExtras.mousepressed(x, y, button, istouch, presses)
    manejarClic(x, y, button)
end

return FuncionesExtras