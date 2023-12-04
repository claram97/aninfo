local configuracion = {}

local sonidoActivado = true
local tamanoPantalla = "mediana"

function configuracion.establecerFondo()
    
    love.graphics.setBackgroundColor(0.95, 0.95, 0.9) 
end

function configuracion.dibujarTitulo()
    
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.printf("Configuración", 0, 50, love.graphics.getWidth(), "center")
end

function configuracion.dibujarSonido()

    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.printf("Sonido", 0, 150, love.graphics.getWidth(), "center")

    
    local toggleColor = sonidoActivado and {0.1, 0.9, 0.1, 0.7} or {0.9, 0.1, 0.1, 0.7} 
    love.graphics.setColor(unpack(toggleColor))
    love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - 25, 200, 50, 30, 10, 10)
end

function configuracion.dibujarTamanioPantalla()
    
    love.graphics.setColor(1, 0.6, 0, 0.7) -- el cuarto valo r es para la opacidad creo
    love.graphics.rectangle("fill", 50, 300, love.graphics.getWidth() - 100, 150, 10, 10)

    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("Tamaño de la Pantalla", 0, 330, love.graphics.getWidth(), "center")


    local opcionMediana = (tamanoPantalla == "mediana") and " [X]" or " [ ]"
    local opcionGrande = (tamanoPantalla == "grande") and " [X]" or " [ ]"

    love.graphics.printf("Mediana" .. opcionMediana, 0, 380, love.graphics.getWidth(), "center")
    love.graphics.printf("Grande" .. opcionGrande, 0, 410, love.graphics.getWidth(), "center")
end

function configuracion.mousepressed(x, y, button, istouch, presses)

    if y >= 200 and y <= 230 then
        sonidoActivado = not sonidoActivado
    end

    if y >= 380 and y <= 400 then
        tamanoPantalla = "mediana"
    elseif y >= 410 and y <= 430 then
        tamanoPantalla = "grande"
    end
end

function configuracion.draw()
    configuracion.establecerFondo()
    configuracion.dibujarTitulo()
    configuracion.dibujarSonido()
    configuracion.dibujarTamanioPantalla()
end

return configuracion