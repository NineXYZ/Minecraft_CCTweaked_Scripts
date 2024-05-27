-- Inicializar posiciones
local coalChest = "right"    -- Cofre con carbón
local poisonChest = "back"   -- Cofre para patatas envenenadas
local normalChest = "left"   -- Cofre para patatas normales
local fuelThreshold = 20     -- Umbral mínimo de combustible

-- Función para repostar
function refuelIfNeeded()
    if turtle.getFuelLevel() < fuelThreshold then
        turtle.turnRight()  -- Suponiendo que el cofre con carbón está a la derecha
        turtle.suck()  -- Extrae el carbón del cofre
        turtle.refuel()
        turtle.turnLeft()  -- Regresa a la posición original
    end
end

-- Función para cosechar y clasificar
function harvestAndSort()
    turtle.select(2)
    turtle.dig()
    local success, data = turtle.inspect()
    if success and data.name == "minecraft:potato" then
        turtle.suck()
        if data.metadata == 6 then  -- Verifica si la patata está envenenada (metadata puede variar, ajusta según sea necesario)
            turtle.turnLeft()
            turtle.drop(poisonChest)
            turtle.turnRight()
        else
            turtle.turnRight()
            turtle.drop(normalChest)
            turtle.turnLeft()
        end
    end
end

-- Programa principal
while true do
    refuelIfNeeded()
    harvestAndSort()
    turtle.forward()
    sleep(60)  -- Esperar un minuto antes de la siguiente acción
end
