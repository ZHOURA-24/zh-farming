function Notify(title, desc, type)
    lib.notify({
        title = title,
        description = desc,
        type = type
    })
end

function SpawnPed(model, coords, cb)
    lib.requestModel(model)
    local ped = CreatePed(26, model, coords.x, coords.y, coords.z, coords.w or 0, false, false)
    SetModelAsNoLongerNeeded(ped)
    if cb then
        cb(ped)
    end
end

function CreateBlip(settings, coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, settings.id)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, settings.scale)
    SetBlipColour(blip, settings.colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(settings.name)
    BeginTextCommandSetBlipName(settings.name)
    EndTextCommandSetBlipName(blip)
    return blip
end
