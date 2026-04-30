RegisterNetEvent('zh-farming:client:ProcessItem', function(index, item)
    local source = source
    local process = Config.Process[index]
    local items = process.items[item]

    for k, v in pairs(items) do
        if not Framework.HasItem(source, k, v) then
            return Notify('Farming processing', string.format('Do not have %s ', k), 'error')
        end
    end

    local success = lib.callback.await('zh-farming:client:ProcessItem', source, index, item)

    if success then
        for k, v in pairs(process.items[item]) do
            Framework.RemoveItem(source, k, v)
        end

        Framework.AddItem(source, item, 1)
    end
end)
