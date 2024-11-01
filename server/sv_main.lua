local NameTagData = {}

RegisterServerEvent('emfan-nametag:server:AddNewPlayer', function(id, data)
    NameTagData[id] = data
    TriggerClientEvent('emfan-nametag:server:UpdateNameTagData', -1, NameTagData)
end)