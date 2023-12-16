
local PantallaPausa = {}

function PantallaPausa.draw()
    Love.graphics.setBackgroundColor(1, 0.6, 0)
    Love.graphics.setColor(0.8, 0.8, 0.6) 
    Love.graphics.rectangle("fill", 50, 200, Love.graphics.getWidth() - 100, 200, 10, 10)
    Love.graphics.setColor(0, 0, 0)
    Love.graphics.printf("El juego está en pausa. Presione P para volver al juego", 100, 220, Love.graphics.getWidth() - 200, "center")
end

return PantallaPausa