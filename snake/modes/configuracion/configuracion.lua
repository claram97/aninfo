local configuracion = {}

local defaultConfig = {
    sound = true,
    fullScreen = false,
}

--pre:
--pos: establece el color del background
function configuracion.establecerFondo()
    love.graphics.setBackgroundColor(0.95, 0.95, 0.9) 
end

--pre:
--pos: setea el color y la font, e dibuja Configuracion en la pantalla
function configuracion.dibujarTitulo()
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.printf("Configuración", 0, 50, love.graphics.getWidth(), "center")
end

-- Pre: Variable global 'config' debe estar definida.
-- Pos: Dibuja la interfaz gráfica para la configuración de sonido en el centro de la pantalla.
function configuracion.dibujarSonido()
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.printf("Sonido", 0, 150, love.graphics.getWidth(), "center")

    local toggleColor = config.sound and {0.1, 0.9, 0.1, 0.7} or {0.9, 0.1, 0.1, 0.7} 
    love.graphics.setColor(unpack(toggleColor))
    love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - 25, 200, 50, 30, 10, 10)
end

-- Pre: Variable global 'config' debe estar definida.
-- Pos: Dibuja la interfaz gráfica para la configuración del tamaño de pantalla en el centro de la pantalla.
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

-- Pre: Ninguna
-- Pos: Dibuja un botón de guardado en el centro de la pantalla con el texto "Guardar"
function configuracion.dibujarSaveButton()
    love.graphics.setColor(0.1, 0.9, 0.1, 0.7)
    love.graphics.rectangle("fill", 200, 500, love.graphics.getWidth() - 400, 100, 10, 10)
    love.graphics.setColor(1.0, 1.0, 1.0)
    love.graphics.print("Guardar", love.graphics.getWidth()/2 - 50, 525)
end

-- Pre: Se ejecuta al presionar el botón del mouse.
-- Pos: Actualiza la configuración de sonido y pantalla segun donde se haga click
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

-- Pre: 
-- Pos: Establece el fondo y dibuja el título, el control de sonido, las opciones de tamaño de pantalla y el boton de guardar
function configuracion.draw()
    configuracion.establecerFondo()
    configuracion.dibujarTitulo()
    configuracion.dibujarSonido()
    configuracion.dibujarTamanioPantalla()
    configuracion.dibujarSaveButton()
end

-- Pre: Variables globales 'config' y 'musica_fondo' deben estar definidas.
-- Pos: Configuración guardada en "config.txt". Si el sonido está deshabilitado, se detiene la música; si está habilitado, se inicia o reanuda. La aplicación se reinicia.
function saveConfig()
    print("Entrando a save config")
    local content = "soundEnabled = " .. tostring(config.sound) .. "\n" ..
    "fullScreen = " .. tostring(config.fullScreen)
    
    local file = io.open("config.txt", "w")
    file:write(content)
    file:close()
    if config.sound == false then
        love.audio.stop(musica_fondo)
    else
        love.audio.play(musica_fondo)
    end
    love.event.quit('restart')
end

-- pre: variable global 'config' debe estar definida.
-- post: se encarga de modificar las configuraciones según lo que se haya elegido por el usuario. En el caso de que los valores sean inválidos, se enviará un mensaje por pantalla y se le cargaran los valores por defecto.
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
    return config
end

-- pre: la variable global 'config' debe estar previamente definida.
-- post: inicializa la configuarción del juego.
function configuracion.load()
    config = loadConfig()
    return config
end

function configuracion.update()
    
end

return configuracion