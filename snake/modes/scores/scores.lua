local scores = {}

function scores.readCsv()
    local file = io.open(".scores", "r")
    local datos = {}  -- Tabla para almacenar los datos del CSV

    if file then
        local lineCount = 0  -- Contador de líneas
        for linea in file:lines() do
            lineCount = lineCount + 1
            if lineCount <= 10 then
                local campos = {}  -- Tabla para almacenar los campos de cada línea
                for valor in string.gmatch(linea, "[^;]+") do
                    table.insert(campos, valor)  -- Agrega cada campo a la tabla
                end
                table.insert(datos, {
                    nombre = campos[1],
                    puntuacion = tonumber(campos[2]),
                    fecha = campos[3]  -- Agrega el campo de fecha
                })
            else
                break  -- Sal del bucle después de leer las primeras 10 líneas
            end
        end

        file:close()  -- Cierra el archivo
    end
    return datos
end

function scores.writeCsv(nombre, puntuacion)
    print("Se llamó a writecsv. Nombre y puntuación: ", nombre, puntuacion)
    -- Abrir el archivo CSV en modo de lectura
    local file = io.open(".scores", "r")

    if file then
        local tempFileName = ".scores_temp"
        local tempFile = io.open(tempFileName, "w")

        if tempFile then
            local inserted = false
            local fecha = os.date("%d/%m/%Y %H:%M:%S")
            local nuevaLinea = nombre .. ";" .. puntuacion .. ";" .. fecha

            for line in file:lines() do
                local score = tonumber(line:match(";%d+;"))
                if not inserted and puntuacion > score then
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

            -- Renombrar el archivo temporal al archivo original
            os.remove(".scores")
            os.rename(tempFileName, ".scores")

            print("Datos escritos correctamente en el archivo.")
        else
            print("Error al abrir el archivo temporal.")
        end
    else
        -- El archivo no existe, haz algo aquí si es necesario
        print("El archivo no existe.")
        local newFile = io.open(".scores", "w")

        if newFile then
            -- El archivo se creó con éxito, haz algo aquí si es necesario
            print("El archivo se creó con éxito.")
            -- Agregar la nueva línea con el nombre, puntuación y fecha
            local fecha = os.date("%d/%m/%Y %H:%M:%S")
            local nuevaLinea = nombre .. ";" .. puntuacion .. ";" .. fecha
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
    love.graphics.setColor(251/255, 180/255, 69/255, 100)
    love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - 500, 125, 1000, 485, 10, 10)
end

function scores.mousepressed(x, y, button, istouch, presses)
    if x >= love.graphics.getWidth() / 3 and x <= love.graphics.getWidth() / 3 + 400 and y >= 650 and y<= 650+80 then
        love.event.quit('restart')
    end
end

function scores.dibujarTitulo()
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.printf("High scores", 0, 50, love.graphics.getWidth(), "center")
end

function scores.dibujarSaveButton()
    love.graphics.setColor(0.1, 0.9, 0.1, 0.7)
    love.graphics.rectangle("fill", love.graphics.getWidth() / 3, 650, 400, 80, 10, 10)
    love.graphics.setColor(1.0, 1.0, 1.0)
    love.graphics.print("Volver", love.graphics.getWidth() / 3 + 150, 665)
end

function scores.draw()
    scores.establecerFondo()
    scores.dibujarTitulo()
    scores.dibujarSaveButton()
    local datos = scores.readCsv()
    -- Configurar la fuente
    local font = love.graphics.newFont(30)  -- Tamaño de letra 14
    love.graphics.setFont(font)
    local y = 150
    love.graphics.setColor(0, 0, 0)  -- Establecer color de texto a negro
    for _, persona in ipairs(datos) do
        love.graphics.print("Nombre: " .. persona.nombre .. ", Puntuacion: " .. persona.puntuacion.. ", Fecha: " .. persona.fecha, 200, y)
        y = y + 45  -- Incrementar la posición Y para la siguiente línea
    end
end

function scores.load()
    
end

function scores.update()
    
end

return scores