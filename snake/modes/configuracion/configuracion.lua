local configuracion = {}

local defaultConfig = {
    sound = true,
    fullScreen = false,
}

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

    local toggleColor = config.sound and {0.1, 0.9, 0.1, 0.7} or {0.9, 0.1, 0.1, 0.7} 
    love.graphics.setColor(unpack(toggleColor))
    love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - 25, 200, 50, 30, 10, 10)
end

function configuracion.dibujarTamanioPantalla()
    love.graphics.setColor(1, 0.6, 0, 0.7) -- el cuarto valo r es para la opacidad creo
    love.graphics.rectangle("fill", 50, 300, love.graphics.getWidth() - 100, 150, 10, 10)

    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("Tamaño de la Pantalla", 0, 330, love.graphics.getWidth(), "center")

    local opcionMediana = (config.fullScreen == false) and " [X]" or " [ ]"
    local opcionGrande = (config.fullScreen == true) and " [X]" or " [ ]"

    love.graphics.printf("Mediana" .. opcionMediana, 0, 380, love.graphics.getWidth(), "center")
    love.graphics.printf("Grande" .. opcionGrande, 0, 410, love.graphics.getWidth(), "center")
end

function configuracion.dibujarSaveButton()
    love.graphics.setColor(0.1, 0.9, 0.1, 0.7)
    love.graphics.rectangle("fill", 200, 500, love.graphics.getWidth() - 400, 100, 10, 10)
    love.graphics.setColor(1.0, 1.0, 1.0)
    love.graphics.print("Guardar", love.graphics.getWidth()/2 - 50, 525)
end

function configuracion.mousepressed(x, y, button, istouch, presses)
    if y >= 200 and y <= 230 then
        config.sound = not config.sound
    end

    if y >= 380 and y <= 400 then
        config.fullScreen = false
    elseif y >= 410 and y <= 430 then
        config.fullScreen = true 
    end

    if y >= 500 and y <= 600 then
        saveConfig()
    end
end

function configuracion.draw()
    configuracion.establecerFondo()
    configuracion.dibujarTitulo()
    configuracion.dibujarSonido()
    configuracion.dibujarTamanioPantalla()
    configuracion.dibujarSaveButton()
end

function saveConfig()
    print("Entrando a save config")
    local content = "soundEnabled = " .. tostring(config.sound) .. "\n" ..
    "fullScreen = " .. tostring(config.fullScreen)
    
    local file = io.open("config.txt", "w")
    file:write(content)
    file:close()
end


function loadConfig()
    local file = io.open("config.txt", "r")
    config = defaultConfig

    if file then
        local content = file:read("*a")
        local soundEnabledMatch = content:match("soundEnabled = (%a+)")
        local fullScreenMatch = content:match("fullScreen = (%a+)")

        if soundEnabledMatch then
            config.sound = soundEnabledMatch == "true"
        else
            print("Error: Invalid soundEnabled value in config.txt")
            config.sound = defaultConfig.soundEnabled
        end

        if fullScreenMatch then
            config.fullScreen = fullScreenMatch == "true"
        else
            print("Error: Invalid fullScreen value in config.txt")
            config.fullScreen = defaultConfig.fullScreen
        end
    end
end

function configuracion.load()
    loadConfig()
end

function configuracion.update()
    
end

return configuracion