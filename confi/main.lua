

local configuracion = require("configuracion")

function love.draw()
    configuracion.draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    configuracion.mousepressed(x, y, button, istouch, presses)
end
