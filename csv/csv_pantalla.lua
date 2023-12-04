local PantallaScore = {}

function PantallaScore.dibujarFondo()
    love.graphics.setBackgroundColor(0.6, 0.7, 1, 0.8)
end

function PantallaScore.dibujarTitulo()
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(love.graphics.newFont(40)) 
    love.graphics.printf("Puntajes", 0, 50, love.graphics.getWidth(), "center")
end

function PantallaScore.dibujarJugador(nombre, puntaje, offsetY)
    love.graphics.setFont(love.graphics.newFont(25)) 

    love.graphics.printf(nombre, 50, offsetY, love.graphics.getWidth(), "left")
    love.graphics.printf(puntaje, 250, offsetY, love.graphics.getWidth(), "left")
    love.graphics.line(50, offsetY + 40, love.graphics.getWidth() - 50, offsetY + 40)  
end

function PantallaScore.mostrarPuntajes(puntajes)
    PantallaScore.dibujarFondo()
    PantallaScore.dibujarTitulo()

    local offsetY = 150
    local lineSpacing = 50

    for index, jugador in ipairs(puntajes) do
        PantallaScore.dibujarJugador(jugador.nombre, jugador.puntaje, offsetY)
        offsetY = offsetY + lineSpacing 
    end
end

return PantallaScore