local serverPlant = {}
local dataFarm = Config.Farming

RegisterNetEvent('zh-farming:server:AddNewPlant', function(name, offset)
    local plant = dataFarm.seeds[name]
    local key = os.time()
    serverPlant[key] = {
        name = name,
        stage = 'a',
        laststage = plant.laststage,
        coords = offset,
        progress = 10,
        water = 50
    }
    TriggerClientEvent('zh-farming:client:NewFarm', -1, key, name, 'a', plant.laststage, offset, 10, 50)
end)

CreateThread(function()
    while true do
        for k, v in pairs(serverPlant) do
            if v.stage ~= v.laststage then
                v.progress = v.progress + Config.Progress
                v.water = v.water - Config.Water
                if v.progress >= 100 then
                    v.progress = 0
                    if v.stage == 'a' then
                        v.stage = 'b'
                    elseif v.stage == 'b' then
                        v.stage = 'c'
                    elseif v.stage == 'c' then
                        v.stage = 'd'
                    end
                end
                TriggerClientEvent('zh-farming:client:UpdatePlant', -1, k, 'water', v.water)
                Wait(100)
                TriggerClientEvent('zh-farming:client:UpdatePlant', -1, k, 'fertilizer', v.progress)
                Wait(100)
                TriggerClientEvent('zh-farming:client:UpdatePlant', -1, k, 'stage', v.stage)
                Wait(100)
            end
        end
        -- TriggerClientEvent('zh-farming:client:UpdateAllPlant', -1, serverPlant)
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
