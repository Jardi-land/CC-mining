local modem = peripheral.find("modem") or error("Modem non trouvé !", 0)
local monitor = peripheral.find("monitor") or error("Écran non trouvé !", 0)

print("Canal à utiliser (ex. 123, 111, 001...) : ")
local_channel = tonumber(read())
modem.open(local_channel) -- Canal 1
monitor.clear()
monitor.setTextScale(1)

local function displayStatus(status, fuel)
    monitor.clear()
    monitor.setCursorPos(1, 1)
    monitor.write("TURTLE STATUS : " .. status)
    monitor.setCursorPos(1, 2)
    monitor.write("Carburant : " .. fuel)
end

print("Entrez la taille du carré à miner : ")
local size = tonumber(read())

if not size or size < 1 then
    print("Taille invalide !")
    return
end

print("Envoi de la commande à la Turtle...")
modem.transmit(local_channel, local_channel, size)

while true do
    local _, _, _, _, message = os.pullEvent("modem_message")
    local data = textutils.unserialize(message)

    if data then
        displayStatus(data.status, data.fuel)
    end

    if data and data.status == "Minage terminé !" then
        print("Minage terminé !")
        break
    end
end
