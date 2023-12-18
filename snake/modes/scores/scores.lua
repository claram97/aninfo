local scores = {}

function scores.readCsv()
    local file = io.open(".scores", "r")
    local datos = {}  -- Tabla para almacenar los datos del CSV
    local lineCount = 0  -- Contador de líneas leídas

    if file then
        for linea in file:lines() do
            local campos = {}  -- Tabla para almacenar los campos de cada línea
            for valor in string.gmatch(linea, "[^;]+") do
                table.insert(campos, valor)  -- Agrega cada campo a la tabla
            end

            -- Verifica que la línea tenga al menos 3 campos antes de intentar acceder a ellos
            if #campos >= 3 then
                table.insert(datos, {
                    nombre = campos[1],
                    puntuacion = tonumber(campos[2]),
                    modo = campos[3],  -- Agrega el campo de modo
                    fecha = campos[4]  -- Agrega el campo de fecha
                })

                lineCount = lineCount + 1  -- Incrementa el contador de líneas leídas

                if lineCount >= 10 then
                    break  -- Sale del bucle después de leer 10 líneas
                end
            else
                -- Manejo de error o advertencia si la línea no tiene suficientes campos
                print("Advertencia: La línea no tiene suficientes campos.")
            end
        end

        file:close()  -- Cierra el archivo
    end
    return datos
end

function split(str, delimiter)
    local result = {}
    local pattern = "(.-)" .. delimiter
    local lastEnd = 1
    local s, e, cap = str:find(pattern, 1)

    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(result, cap)
        end
        lastEnd = e + 1
        s, e, cap = str:find(pattern, lastEnd)
    end

    if lastEnd <= #str then
        cap = str:sub(lastEnd)
        table.insert(result, cap)
    end

    return result
end

function scores.writeCsv(nombre, puntuacion, modo)
    -- Abrir el archivo CSV en modo de lectura
    local file = io.open(".scores", "r")

    if file then
        local tempFileName = ".scores_temp"
        local tempFile = io.open(tempFileName, "w")

        if tempFile then
            local inserted = false
            local fecha = os.date("%d/%m/%Y %H:%M:%S")
            local nuevaLinea = nombre .. ";" .. puntuacion .. ";" .. modo .. ";" .. fecha
            
            for line in file:lines() do
                local result = split(line, ";")
                local score = result[2]
                if not inserted and puntuacion > tonumber(score) then
                    tempFile:write(nuevaLinea .. "\n")
                    inserted = true
                end
                tempFile:write(line .. "\n")
            end

            if not inserted then
                tempFile:write(nuevaLinea .. "\n")
            end

            file:close()
            tempFile:close()

            os.remove(".scores")
            os.rename(tempFileName, ".scores")

        else
            print("Error al abrir el archivo temporal.")
        end
    else
        -- El archivo no existe, haz algo aquí si es necesario
        local newFile = io.open(".scores", "w")

        if newFile then
            -- El archivo se creó con éxito, haz algo aquí si es necesario
            -- Agregar la nueva línea con el nombre, puntuación, modo y fecha
            local fecha = os.date("%d/%m/%Y %H:%M:%S")
            local nuevaLinea = nombre .. ";" .. puntuacion .. ";" .. modo .. ";" .. fecha
            newFile:write(nuevaLinea .. "\n")
            -- Cierra el archivo después de realizar las operaciones necesarias
            newFile:close()
        else
            -- Hubo un error al crear el archivo, maneja el error según sea necesario
            print("Error al crear el archivo.")
        end
    end
end

function scores.establecerFondo()
    love.graphics.setBackgroundColor(0.95, 0.95, 0.9)
    local rectWidth = love.graphics.getWidth() * 0.8
    local rectHeight = love.graphics.getHeight() * 0.6
    local rectX = (love.graphics.getWidth() - rectWidth) / 2
    local rectY = love.graphics.getHeight() * 0.15 -- Ajuste hacia abajo
    love.graphics.setColor(251/255, 180/255, 69/255, 100)
    love.graphics.rectangle("fill", rectX, rectY, rectWidth, rectHeight, 10, 10)
end

function scores.mousepressed(x, y, button, istouch, presses)
    local buttonX = love.graphics.getWidth() / 3
    local buttonY = love.graphics.getHeight() * 0.77 -- Ajuste hacia abajo
    local buttonWidth = love.graphics.getWidth() * 0.4
    local buttonHeight = love.graphics.getHeight() * 0.1
    
    if x > buttonX and x < buttonX + buttonWidth and y > buttonY and y < buttonY + buttonHeight then
        return true
    end
end

function scores.dibujarTitulo()
    love.graphics.setColor(0, 0, 0)
    local fontSize = love.graphics.getHeight() * 0.05
    love.graphics.setFont(love.graphics.newFont(fontSize))
    love.graphics.printf("High scores", 0, love.graphics.getHeight() * 0.07, love.graphics.getWidth(), "center") -- Ajuste hacia abajo
end

function scores.dibujarSaveButton()
    local buttonX = love.graphics.getWidth() / 3
    local buttonY = love.graphics.getHeight() * 0.77 -- Ajuste hacia abajo
    local buttonWidth = love.graphics.getWidth() * 0.4
    local buttonHeight = love.graphics.getHeight() * 0.1

    love.graphics.setColor(0.1, 0.9, 0.1, 0.7)
    love.graphics.rectangle("fill", buttonX, buttonY, buttonWidth, buttonHeight, 10, 10)
    love.graphics.setColor(1.0, 1.0, 1.0)
    love.graphics.print("Volver", buttonX + buttonWidth * 0.375, buttonY + buttonHeight * 0.35)
end


function scores.draw()
    scores.establecerFondo()
    scores.dibujarTitulo()
    scores.dibujarSaveButton()
    local datos = scores.readCsv()
    
    -- Configurar la fuente
 
    local config = configuracion.load()
    if config.fullScreen then
        local font = love.graphics.newFont(23)  -- Tamaño de letra 30 (puedes ajustar según sea necesario)
        love.graphics.setFont(font)
        local y = 120
        love.graphics.setColor(0, 0, 0)  -- Establecer color de texto a negro
        local x = width * 0.10
        for _, persona in ipairs(datos) do
            love.graphics.print(persona.nombre .. ", " .. persona.puntuacion .. " puntos, modo " .. persona.modo .. ", " .. persona.fecha, x, y)
            y = y + 40  -- Incrementar la posición Y para la siguiente línea
        end    
    else
        local font = love.graphics.newFont(25)  -- Tamaño de letra 30 (puedes ajustar según sea necesario)
        love.graphics.setFont(font)
        local y = 150
        love.graphics.setColor(0, 0, 0)  -- Establecer color de texto a negro
        local x = width * 0.10
        for _, persona in ipairs(datos) do
            love.graphics.print(persona.nombre .. ", " .. persona.puntuacion .. " puntos, modo " .. persona.modo .. ", " .. persona.fecha, x, y)
            y = y + 45  -- Incrementar la posición Y para la siguiente línea
        end    
    end
    
end

function scores.load()
    configuracion = require('snake.modes.configuracion.configuracion')
end

function scores.update()
    
end

return scores