-- Configuración de la granja
local width = 4  -- Ancho del campo de cultivo
local length = 11  -- Largo del campo de cultivo

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

-- Función para inspeccionar y depurar bloques
function inspectAndDebug(direction)
    local success, data
    if direction == "down" then
        success, data = turtle.inspectDown()
    elseif direction == "up" then
        success, data = turtle.inspectUp()
    else
        success, data = turtle.inspect()
    end
    
    if success then
        debug("Se detectó un bloque " .. direction)
        debug("Nombre del bloque: " .. data.name)
        if data.metadata then
            debug("Metadata del bloque: " .. data.metadata)
        end
    else
        debug("No se detectó ningún bloque " .. direction)
    end
    return success, data
end

-- Función para cosechar y clasificar desde arriba
function harvestAndSort()
    local success, data = inspectAndDebug("down")
    if success and data.name == "minecraft:potatoes" and data.metadata == 7 then
        debug("La planta detectada es una patata madura")
        turtle.digDown()
        turtle.suckDown()
        turtle.placeDown()  -- Replanta la patata
        local itemCount = turtle.getItemCount()
        debug("Cantidad de ítems recogidos: " .. itemCount)
        if itemCount > 0 then
            turtle.turnRight()
            turtle.dropDown()
            turtle.turnLeft()
        else
            debug("No se recogió ninguna patata")
        end
    else
        debug("La planta debajo de la tortuga no es una patata madura")
    end
end

-- Función para moverse dentro del campo de cultivo
function moveWithinField()
    for z = 1, length do
        for x = 1, width - 1 do
            harvestAndSort()
            turtle.forward()
        end
        harvestAndSort()
        if z < length then
            if z % 2 == 1 then
                turtle.turnRight()
                turtle.forward()
                turtle.turnRight()
            else
                turtle.turnLeft()
                turtle.forward()
                turtle.turnLeft()
            end
        end
    end
end

-- Función para elevar la tortuga al inicio
function elevateTurtle()
    if not turtle.up() then
        debug("No se pudo elevar la tortuga. Asegúrate de que no haya bloque encima.")
    else
        debug("Tortuga elevada un bloque.")
    end
end

-- Programa principal
while true do
    debug("Iniciando ciclo principal")
    refuelIfNeeded()
    elevateTurtle()
    moveWithinField()
    -- Regresar al inicio después de completar el ciclo
    turtle.turnRight()
    turtle.turnRight()
    for z = 1, length do
        for x = 1, width do
            turtle.forward()
        end
        if z < length then
            turtle.turnRight()
            turtle.forward()
            turtle.turnRight()
        end
    end
    -- Reposicionarse para el siguiente ciclo
    turtle.turnRight()
    turtle.turnRight()
    sleep(60)  -- Esperar un minuto antes de la siguiente acción
    debug("Ciclo principal completado, esperando 60 segundos")
end
