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
    local success, data = turtle.inspect()
    if success then
        debug("Se detectó una planta delante de la tortuga")
        if data.name == "minecraft:potatoes" then
            debug("La planta detectada es una patata")
            turtle.dig()
            turtle.suck()
            local itemCount = turtle.getItemCount()
            debug("Cantidad de ítems recogidos: " .. itemCount)
            if itemCount > 0 then
                turtle.turnRight()
                turtle.drop(normalChest)
                turtle.turnLeft()
            else
                debug("No se recogió ninguna patata")
            end
        else
            debug("La planta delante de la tortuga no es una patata")
        end
    else
        debug("No se detectó ninguna planta delante de la tortuga")
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
