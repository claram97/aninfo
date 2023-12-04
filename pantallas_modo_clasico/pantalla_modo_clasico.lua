
local modoClasico = {}

function modoClasico.dibujar()
    love.graphics.setBackgroundColor(1, 1, 0.8)

    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(love.graphics.newFont(60))
    love.graphics.printf("Modo Clásico", 0, 50, love.graphics.getWidth(), "center")

    local offsetY = 100

    local buttonWidth = 220
    local buttonHeight = 50

    modoClasico.dibujarBoton(love.graphics.getWidth() / 4, 200 + offsetY, buttonWidth, buttonHeight, "1 Jugador")
    modoClasico.dibujarBoton(3 * love.graphics.getWidth() / 4, 200 + offsetY, buttonWidth, buttonHeight, "2 Jugadores")
end

function modoClasico.dibujarBoton(x, y, width, height, texto)
    love.graphics.setColor(0.2, 0.7, 0.2)
    love.graphics.rectangle("fill", x - width / 2, y, width, height, 15, 15)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(25))
    love.graphics.printf(texto, x - width / 2, y + 15, width, "center")
end

return modoClasico