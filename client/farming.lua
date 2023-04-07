local farms = {}
local clientFarm = {}
local dataFarm = Config.Farming
local task = false

local function GetGroundHash(ped)
    local pedPosition = GetEntityCoords(ped)
    local num = StartShapeTestCapsule(pedPosition.x, pedPosition.y, pedPosition.z + 4, pedPosition.x, pedPosition.y,
        pedPosition.z - 2.0, 2, 1, ped, 7)
    local arg1, arg2, arg3, arg4, arg5 = GetShapeTestResultEx(num)
    return arg5
end

local function PlayEffect(dict, particleName, entity, off, rot, time, cb)
    CreateThread(function()
        lib.RequestNamedPtfxAsset(dict)
        UseParticleFxAssetNextCall(dict)
        Wait(10)
        local particleHandle = StartParticleFxLoopedOnEntity(particleName, entity, off.x, off.y, off.z, rot.x, rot.y,
            rot.z, 1.0)
        SetParticleFxLoopedColour(particleHandle, 0, 255, 0, 0)
        Wait(time)
        StopParticleFxLooped(particleHandle, false)
        if cb then
            cb()
        end
    end)
end

local function PlantAction(key, type)
    task = true
    lib.hideContext(false)
    local playerCoords = GetEntityCoords(cache.ped)
    if type == 'water' then
        local object = CreateObject('prop_wateringcan', playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
        local boneIndex = GetPedBoneIndex(cache.ped, 0x8CBD)
        local off = vector3(0.15, 0.0, 0.4)
        local rot = vector3(0.0, -180.0, -140.0)
        FreezeEntityPosition(cache.ped, true)
        AttachEntityToEntity(object, cache.ped, boneIndex, off.x, off.y, off.z, rot.x, rot.y, rot.z, false, false, false,
            true, 1, true)
        lib.RequestAnimDict("missfbi3_waterboard")
        TaskPlayAnim(cache.ped, "missfbi3_waterboard", "waterboard_loop_player", -8.0, 8.0, -1, 49, 1.0)
        PlayEffect("core", "ent_sht_water", object, vec3(0.34, 0.0, 0.2), vec3(0.0, 0.0, 0.0), 1000 * 5)
        if lib.progressCircle({
                duration = 1000 * 5,
                position = 'bottom',
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                    move = true
                },
            })
        then
            ClearPedTasks(cache.ped)
            DeleteEntity(object)
            FreezeEntityPosition(cache.ped, false)
            TriggerServerEvent('zh-farming:server:ActionPlant', key, type)
        end
    elseif type == 'harvest' then
        TaskStartScenarioInPlace(cache.ped, "WORLD_HUMAN_GARDENER_PLANT", 0, 1)
        if lib.progressCircle({
                duration = 1000 * 5,
                position = 'bottom',
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                    move = true
                },
            })
        then
            ClearPedTasks(cache.ped)
            TriggerServerEvent('zh-farming:server:ActionPlant', key, type)
        end
    elseif type == 'fertilizer' then
        local object = CreateObject('prop_paper_bag_01', playerCoords.x, playerCoords.y, playerCoords.z, true,
            true, true)
        local boneIndex = GetPedBoneIndex(cache.ped, 0x8CBD)
        local off = vector3(0.15, 0.1, 0)
        local rot = vector3(250.5, 280.100, 200.0)
        AttachEntityToEntity(object, cache.ped, boneIndex, off.x, off.y, off.z, rot.x, rot.y, rot.z, false, false, false,
            true, 1, true)
        lib.RequestAnimDict("anim@amb@business@cfid@cfid_desk_no_work_bgen_chair_no_work@")
        TaskPlayAnim(cache.ped, "anim@amb@business@cfid@cfid_desk_no_work_bgen_chair_no_work@", "phone_search_lazyworker",
            -8.0, 8.0, -1, 49, 1.0)
        PlayEffect("core", "ent_anim_leaf_blower", object, vec3(0.0, 0.0, 0.20), vec3(0.0, 0.0, 0.0), 1000 * 5)
        if lib.progressCircle({
                duration = 1000 * 5,
                position = 'bottom',
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                    move = true
                },
            })
        then
            ClearPedTasks(cache.ped)
            DeleteEntity(object)
            FreezeEntityPosition(cache.ped, false)
            TriggerServerEvent('zh-farming:server:ActionPlant', key, type)
        end
    end
    task = false
end

local function CreateMenu(key)
    local plant = farms[key]
    local harvestText = 'Not ready to harvest'
    if plant.stage == plant.laststage then
        harvestText = 'Ready to harvest'
    end
    lib.registerContext({
        id = 'plants_menu_',
        title = 'My plant',
        options = {
            {
                title = 'Progress : ' .. plant.progress .. '%',
                icon = 'fas fa-leaf',
                iconColor = 'green',
                progress = plant.progress,
                colorScheme = 'green'
            },
            {
                title = 'Water : ' .. plant.water .. '%',
                icon = 'fa fa-tint',
                iconColor = 'blue',
                progress = plant.water,
                colorScheme = 'blue',
            },
            {
                title = 'Wash',
                icon = 'fa fa-shower',
                iconColor = 'blue',
                colorScheme = 'blue',
                description = 'Plants need water?',
                onSelect = function()
                    PlantAction(key, 'water')
                end
            },
            {
                title = 'Fertilizer',
                icon = 'fa fa-signing',
                iconColor = 'yellow',
                description = 'Plants need fertilizer?',
                onSelect = function()
                    PlantAction(key, 'fertilizer')
                end
            },
            {
                title = 'Harvest ?',
                icon = 'fa fa-spoon',
                iconColor = 'red',
                description = harvestText,
                onSelect = function()
                    if plant.stage ~= plant.laststage then
                        return Notify('Farming', "Can't harvest", 'error')
                    end
                    PlantAction(key, 'harvest')
                end
            },

        }
    })
    lib.showContext('plants_menu_')
end

local DeletePlantFarm = function(key)
    if clientFarm[key] then
        DeleteEntity(clientFarm[key].object)
        exports.ox_target:removeLocalEntity(clientFarm[key].object, 'option_plant_target')
        clientFarm[key] = nil
    end
end

local CreatePlantFarm = function(key)
    clientFarm[key] = {}
    local farm = farms[key]
    local data = dataFarm.seeds[farm.name]
    local model = data.stage[farm.stage]
    lib.requestModel(model)
    clientFarm[key].object = CreateObject(GetHashKey(model), farm.coords.x, farm.coords.y, farm.coords.z - 0.1, false,
        false, false)
    FreezeEntityPosition(clientFarm[key].object, true)
    clientFarm[key].stage = farm.stage
    local options = {
        {
            name = 'option_plant_target',
            icon = 'fas fa-leaf',
            label = 'Check plant',
            canInteract = function(entity, distance, coords, name, bone)
                return distance < 2 and not task
            end,
            onSelect = function()
                CreateMenu(key)
            end
        }
    }
    exports.ox_target:addLocalEntity(clientFarm[key].object, options)
end

local CheckPlantTest = function(key)
    return clientFarm[key]
end

local CheckStage = function(key)
    if clientFarm[key] ~= nil and farms[key] ~= nil then
        if clientFarm[key].stage ~= farms[key].stage then
            return true
        end
    end
    return false
end

local function UpdateStage(key)
    DeletePlantFarm(key)
    CreatePlantFarm(key)
end

CreateThread(function()
    while true do
        local sleep = 1000
        local coordPed = GetEntityCoords(cache.ped)
        for k, v in ipairs(farms) do
            local check = CheckPlantTest(k)
            local stage = CheckStage(k)
            local coordsObject = v.coords
            if #(coordPed - coordsObject) < 50 then
                if v.water < 1 then
                    TriggerServerEvent('zh-farming:server:DeathPlant', k)
                end
                if not check and not stage then
                    CreatePlantFarm(k)
                end
                if stage then
                    UpdateStage(k)
                end
            else
                if check then
                    DeletePlantFarm(k)
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('zh-farming:client:NewFarm', function(index, name, stage, laststage, coords, progress, water)
    if farms[index] == nil then
        farms[index] = {
            name = name,
            stage = stage,
            laststage = laststage,
            coords = coords,
            progress = progress,
            water = water
        }
    end
end)

RegisterNetEvent('zh-farming:client:UpdateAllPlant', function(data)
    farms = data
end)

RegisterNetEvent('zh-farming:client:UpdatePlant', function(key, type, value, stage)
    if type == 'water' then
        farms[key].water = value
    elseif type == 'harvest' then
        if farms[key] then
            DeletePlantFarm(key)
            farms[key] = nil
        end
    elseif type == 'fertilizer' then
        farms[key].progress = value
    end
end)

RegisterNetEvent('zh-farming:client:DeathPlant', function(key)
    if farms[key] then
        DeletePlantFarm(key)
        farms[key] = nil
    end
end)

local function RegisterItems()
    for k, v in pairs(dataFarm.seeds) do
        exports(k, function(data, slot)
            local playerOffset = GetOffsetFromEntityInWorldCoords(cache.ped, -0.0, 0.6, -0.95)
            local closestPlant = 0
            local ground = GetGroundHash(cache.ped)
            for i = 1, #dataFarm.model do
                if closestPlant == 0 then
                    closestPlant = GetClosestObjectOfType(playerOffset.x, playerOffset.y, playerOffset.z, 2.0,
                        GetHashKey(dataFarm.model[i]), false, false, false)
                end
            end
            if closestPlant ~= 0 then
                return Notify('Farming', "Can't place here", 'error')
            elseif not dataFarm.soil[ground] then
                return Notify('Farming', "Not soil", 'error')
            end
            exports.ox_inventory:useItem(data, function(data)
                if data then
                    TaskStartScenarioInPlace(cache.ped, "WORLD_HUMAN_GARDENER_PLANT", 0, 1)
                    Wait(5000)
                    ClearPedTasks(cache.ped)
                    TriggerServerEvent('zh-farming:server:AddNewPlant', k, playerOffset)
                end
            end)
        end)
    end
end

local function RegisterShop()
    local shop = Config.Shops
    local peds = shop.ped
    local options = {
        {
            icon = 'fa fa-comments',
            label = 'Open shops',
            onSelect = function()
                exports.ox_inventory:openInventory('shop', { type = shop.label, id = 1 })
            end
        }
    }
    CreateBlip(shop.blip, shop.location)
    SpawnPed(peds.model, peds.coords, function(ped)
        FreezeEntityPosition(ped, true)
        TaskSetBlockingOfNonTemporaryEvents(ped, true)
        SetEntityInvincible(ped, true)
        ClearPedTasks(ped)
        exports.ox_target:addLocalEntity(ped, options)
    end)
    TriggerServerEvent('zh-farming:server:RegisterShop')
end

AddEventHandler("playerSpawned", function()
    lib.callback('zh-farming:server:GetAllPlants', false, function(allPlant)
        farms = allPlant
    end)
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        RegisterItems()
        RegisterShop()
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for i = 1, #clientFarm do
            if DoesEntityExist(clientFarm[i].object) then
                DeleteEntity(clientFarm[i].object)
            end
        end
    end
end)
