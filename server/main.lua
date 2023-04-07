RegisterNetEvent('zh-farming:server:AddItem', function(item, count)
    Framework.AddItem(source, item, count)
end)

RegisterNetEvent('zh-farming:server:RemoveItem', function(item, count)
    Framework.RemoveItem(source, item, count)
end)
