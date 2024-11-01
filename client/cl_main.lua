local emfan = exports['emfan-framework']:getFrameworkSettings()

local TagsVisible = false
local NameTagData = {}

local function drawPlayerInfo(id, firstname, lastname, crewTag)
    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    local x, y, z = pos.x, pos.y, pos.z + 1.1
    
    local onScreen, _x, _y = World3dToScreen2d(x, y, z + 0.1)
    
    if onScreen then
        BeginTextCommandGetWidth("STRING")
        AddTextComponentString(crewTag)
        local width = EndTextCommandGetWidth(1) * 0.4
        
        DrawRect(_x, _y + 0.015, width, 0.03, 255, 255, 255, 200)
        
        DrawRect(_x, _y + 0.015 + 0.015, width, 0.005, 9, 214, 2, 255)
        
        SetTextFont(4)
        SetTextProportional(1)
        SetTextScale(0.5, 0.5)
        SetTextColour(0, 0, 0, 255)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(crewTag)
        EndTextCommandDisplayText(_x, _y) 

        SetTextFont(4)
        SetTextProportional(1)
        SetTextScale(0.9, 0.9)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        SetTextCentre(true)
        SetTextOutline(true)
        AddTextComponentString(id .. " | " .. firstname .. " " .. lastname)
        EndTextCommandDisplayText(_x, _y + 0.025)
    end
end

local function showTags(state)
    while TagsVisible do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        for k, v in pairs(NameTagData) do
            local ped = NetToPed(v.netPed)
            local pedCoords = GetEntityCoords(ped)
            local xDist = #(pedCoords - playerCoords)
            if xDist <= 100 then
                drawPlayerInfo(v.id, v.firstname, v.lastname, v.gang)
            end
        end
    end
end

RegisterCommand(Config.Command, function(source, args, rawCommand)
    if TagsVisible then
        TagsVisible = false
    else
        TagsVisible = true
    end
    showTags(TagsVisible)
end)

CreateThread(function()
    emfan.waitForLogin()
    local PlayerData = emfan.getPlayer()
    local id = PlayerData.source
    local netPed = PedToNet(PlayerPedId())



    -- If you're not using QBCore then you will need to change this to work with your framework
    local NameTag = {
        id = id,
        gang = PlayerData.gang.label,
        firstname = PlayerData.charinfo.firstname,
        lastname = PlayerData.charinfo.lastname,
        netPed = netPed
    }



    TriggerServerEvent('emfan-nametag:server:AddNewPlayer', id, NameTag)

end)

RegisterNetEvent('emfan-nametag:server:UpdateNameTagData', function(data)
    for key, value in pairs(data) do 
        for k, v in pairs(value) do
            print("data", key, k, v)
        end
    end
    NameTagData = data
end)
