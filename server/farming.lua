local serverPlant = {}
local dataFarm = Config.Farming

RegisterNetEvent('zh-farming:server:AddNewPlant', function(key, offset)
    local plant = dataFarm.seeds[key]
    local index = #serverPlant + 1
    serverPlant[index] = {
        name = key,
        stage = 'a',
        laststage = plant.laststage,
        coords = offset,
        progress = 0,
        water = 50
    }
    TriggerClientEvent('zh-farming:client:NewFarm', -1, index, key, 'a', plant.laststage, offset, 0, 50)
end)

CreateThread(function()
    while true do
        for i = 1, #serverPlant do
            if serverPlant[i] ~= nil then
                if serverPlant[i].stage ~= serverPlant[i].laststage then
                    serverPlant[i].progress = serverPlant[i].progress + Config.Progress
                    serverPlant[i].water = serverPlant[i].water - Config.Water
                    if serverPlant[i].progress >= 100 then
                        serverPlant[i].progress = 0
                        if serverPlant[i].stage == 'a' then
                            serverPlant[i].stage = 'b'
                        elseif serverPlant[i].stage == 'b' then
                            serverPlant[i].stage = 'c'
                        elseif serverPlant[i].stage == 'c' then
                            serverPlant[i].stage = 'd'
                        elseif serverPlant[i].stage == 'd' then
                            serverPlant[i].stage = 'e'
                        end
                    end
                end
            end
        end
        TriggerClientEvent('zh-farming:client:UpdateAllPlant', -1, serverPlant)
        Wait(60 * 1000 * Config.Update)
    end
end)

RegisterNetEvent('zh-farming:server:ActionPlant', function(key, type)
    local random = Config.PlantAction
    if type == 'water' then
        serverPlant[key].water = serverPlant[key].water + random
        if serverPlant[key].water >= 100 then
            serverPlant[key].water = 99
        end
        TriggerClientEvent('zh-farming:client:UpdatePlant', -1, key, type, serverPlant[key].water)
    elseif type == 'harvest' then
        Framework.AddItem(source, serverPlant[key].name, 1)
        TriggerClientEvent('zh-farming:client:DeathPlant', -1, key)
        serverPlant[key] = nil
    elseif type == 'fertilizer' then
        serverPlant[key].progress = serverPlant[key].progress + random
        if serverPlant[key].progress >= 100 then
            serverPlant[key].progress = 99
        end
        TriggerClientEvent('zh-farming:client:UpdatePlant', -1, key, type, serverPlant[key].progress)
    end
end)

RegisterNetEvent('zh-farming:server:DeathPlant', function(key)
    if serverPlant[key] then
        TriggerClientEvent('zh-farming:client:DeathPlant', -1, key)
        serverPlant[key] = nil
    end
end)

lib.callback.register('zh-farming:server:GetAllPlants', function(source)
    return serverPlant
end)

RegisterNetEvent('zh-farming:server:RegisterShop', function()
    local shop = Config.Shops
    exports.ox_inventory:RegisterShop(shop.label, {
        name = shop.label,
        inventory = shop.inventory,
    })
end)
