local objects = {}
local itemNames = exports.ox_inventory:Items()

lib.callback.register('zh-farming:client:ProcessItem', function(index, item)
    TaskTurnPedToFaceEntity(cache.ped, objects[index], 1000)
    Wait(1000)
    local progress = Config.Process[index].progress
    PlayEffect(progress.dict_effect, progress.effect, objects[index], progress.effect_pos, vec3(0, 0, 0), 10000)
    if lib.progressBar({
            duration = 10000,
            label = string.format('Processing %s', itemNames[item].label),
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true
            },
            anim = {
                dict = progress.dict,
                clip = progress.clip,
            },
            prop = {
                model = progress.model,
                pos = progress.pos,
                rot = progress.rot,
                bone = progress.bone,
            },

        })
    then
        Notify('Farming processing', string.format('Success process %s %s', 1, itemNames[item].label), 'success')
        return true
    else
        Notify('Farming processing', 'Cancel', 'error')
        return false
    end
end)

local function MenuProcess(index)
    local menus = {}
    for k, v in pairs(Config.Process[index].items) do
        menus[#menus + 1] = {
            title = itemNames[k].label,
            icon = "nui://ox_inventory/web/images/" .. k .. ".png",
            metadata = v,
            onSelect = function()
                for j, b in pairs(v) do
                    local count = exports.ox_inventory:Search('count', j)
                    if count < b then
                        return Notify('Farming processing', string.format('Do not have %s ', j), 'error')
                    end
                end
                TriggerServerEvent("zh-farming:client:ProcessItem", index, k)
            end
        }
    end
    lib.registerContext({
        id = 'menu_process',
        title = 'Some context menu',
        options = menus
    })
    lib.showContext('menu_process')
end

CreateThread(function()
    for i = 1, #Config.Process do
        local coords = Config.Process[i].coords
        local rotation = Config.Process[i].rotation
        local object = CreateObject(GetHashKey(Config.Process[i].object), coords.x, coords.y, coords.z, false, false,
            false)
        SetEntityRotation(object, rotation.x, rotation.y, rotation.z, 2, true)
        FreezeEntityPosition(object, true)
        objects[#objects + 1] = object
        local options = {
            {
                event = 'ox_target:debug',
                icon = 'fa-solid fa-road',
                label = 'Option 1',
                onSelect = function()
                    MenuProcess(i)
                end
            },
        }
        exports.ox_target:addLocalEntity(object, options)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for i = 1, #objects do
            if DoesEntityExist(objects[i]) then
                DeleteEntity(objects[i])
            end
        end
    end
end)
