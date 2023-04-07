if Framework.ESX() then
    local ESX = exports['es_extended']:getSharedObject()

    function Framework.AddItem(src, item, count)
        local Player = ESX.GetPlayerFromId(src)
        if Player.canCarryItem(item, count) then
            Player.addInventoryItem(item, count)
        end
    end

    function Framework.RemoveItem(src, item, count)
        local Player = ESX.GetPlayerFromId(src)
        Player.removeInventoryItem(item, count)
    end
end

if Framework.QBCore() then
    local QBCore = exports['qb-core']:GetCoreObject()

    function Framework.AddItem(src, item, count)
        local Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.AddItem(item, count)
    end

    function Framework.RemoveItem(src, item, count)
        local Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.AddItem(item, count)
    end
end
