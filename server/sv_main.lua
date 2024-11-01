local NameTagData = {}

-- Event to add new player name tag data to the server
RegisterServerEvent('emfan-nametag:server:AddNewPlayer', function(id, data)
    NameTagData[id] = data
    -- Broadcast updated name tag data to all clients
    TriggerClientEvent('emfan-nametag:server:UpdateNameTagData', -1, NameTagData)
end)