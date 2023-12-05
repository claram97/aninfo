-- main.lua

FuncionesExtras = require("pantalla_modo_clasico")


function love.load()
    -- Configuraciones iniciales, si es necesario
end

function love.update(dt)
    -- Actualizaciones lógicas, si es necesario
end

function love.draw()
    -- Dibuja la pantalla de inicio
    FuncionesExtras.mostrarPantallaInicio()
end

function love.mousepressed(x, y, button, istouch, presses)
    -- Maneja los clics del mouse
    FuncionesExtras.mousepressed(x, y, button, istouch, presses)
end
