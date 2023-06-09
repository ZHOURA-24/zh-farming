function Notify(title, desc, type)
    lib.notify({
        title = title,
        description = desc,
        type = type
    })
end

function ShowHelp(text, pos, icon, color, textColor)
    lib.showTextUI(text, {
        position = pos,
        icon = icon,
        style = {
            borderRadius = 10,
            backgroundColor = color,
            color = textColor
        }
    })
end

function HideHelp()
    lib.hideTextUI()
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

---@param model string
---@return boolean|vector3
function ObjectControl(model)
    busy = true
    lib.requestModel(model)
    local object = CreateObjectNoOffset(model, 1.0, 1.0, 1.0, true, true, false)
    SetEntityCollision(object, false, false)
    FreezeEntityPosition(object, true)
    SetEntityDrawOutline(object, true)
    local text = '[E] - Confirm  \n [Q] - Cancel'
    ShowHelp(text, 'top-center', 'arrows', 'blue', 'white')
    while true do
        local hit, entity, endCoords, surfaceNormal, materialHash = lib.raycast.cam(1, 1, 20)
        DrawLine(GetEntityCoords(cache.ped), endCoords, 255, 255, 255, 255)
        if hit then
            SetEntityCoords(object, endCoords.x, endCoords.y, endCoords.z + 0.1)
        end
        if not Config.Farming.soil[materialHash] then
            SetEntityDrawOutlineColor(250, 0, 0, 1)
            SetEntityHeading(object, GetEntityHeading(object) + 10.0)
        else
            SetEntityDrawOutlineColor(30, 250, 0, 1)
        end
        if IsControlJustPressed(0, 38) then
            if Config.Farming.soil[materialHash] then
                DeleteEntity(object)
                HideHelp()
                busy = false
                return endCoords
            else
                Notify('Farming', "Not soil", 'error')
            end
        elseif IsControlJustPressed(0, 44) then
            DeleteEntity(object)
            HideHelp()
            busy = false
            return false
        end
        Wait(0)
    end
end

function PlayEffect(dict, particleName, entity, off, rot, time, cb)
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