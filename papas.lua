-- Inicializar posiciones
local coalChest = "right"    -- Cofre con carbón
local poisonChest = "back"   -- Cofre para patatas envenenadas
local normalChest = "left"   -- Cofre para patatas normales
local fuelThreshold = 20     -- Umbral mínimo de combustible

-- Función para imprimir mensajes de depuración
function debug(message)
    print("[DEBUG] " .. message)
end

-- Función para repostar
function refuelIfNeeded()
    if turtle.getFuelLevel() < fuelThreshold then
        debug("Nivel de combustible bajo, repostando...")
        turtle.turnRight()  -- Suponiendo que el cofre con carbón está a la derecha
        turtle.suck()  -- Extrae el carbón del cofre
        turtle.refuel()
        debug("Combustible actual: " .. turtle.getFuelLevel())
        turtle.turnLeft()  -- Regresa a la posición original
    else
        debug("Nivel de combustible suficiente: " .. turtle.getFuelLevel())
    end
end

-- Función para cosechar y clasificar
function harvestAndSort()
    turtle.select(2)
    turtle.dig()
    local success, data = turtle.inspect()
    if success and data.name == "minecraft:potato" then
        debug("Se detectó una planta de patata")
        turtle.suck()
        if data.metadata == 6 then  -- Verifica si la patata está envenenada (metadata puede variar, ajusta según sea necesario)
            debug("Patata envenenada detectada, guardando en el cofre correspondiente")
            turtle.turnLeft()
            turtle.drop()
            turtle.turnRight()
        else
            debug("Patata normal detectada, guardando en el cofre correspondiente")
            turtle.turnRight()
            turtle.drop()
            turtle.turnLeft()
        end
    else
        debug("No se detectó ninguna planta de patata")
    end
end

-- Programa principal
while true do
    debug("Iniciando ciclo principal")
    refuelIfNeeded()
    harvestAndSort()
    turtle.forward()
    sleep(60)  -- Esperar un minuto antes de la siguiente acción
    debug("Ciclo principal completado, esperando 60 segundos")
end
