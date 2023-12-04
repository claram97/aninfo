local PantallaScore = require("csv_pantalla")

local puntajesEjemplo = {
    {nombre = "Jugador1", puntaje = 2},
    {nombre = "Jugador2", puntaje = 4},
    {nombre = "Jugador3", puntaje = 7},
    {nombre = "Jugador4", puntaje = 7},
}

function love.draw()
    PantallaScore.mostrarPuntajes(puntajesEjemplo)
end
