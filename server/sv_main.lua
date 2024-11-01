local NameTagData = {}

RegisterServerEvent('emfan-nametag:server:AddNewPlayer', function(id, data)
    print("id", id)
    NameTagData[id] = data
    TriggerClientEvent('emfan-nametag:server:UpdateNameTagData', -1, NameTagData)
end)