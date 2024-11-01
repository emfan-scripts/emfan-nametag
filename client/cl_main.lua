local emfan = exports['emfan-framework']:getFrameworkSettings()

-- Flag to toggle visibility of name tags
local TagsVisible = false
-- Table to store name tag data for players
local NameTagData = {}

-- Function to draw player information on the screen
local function drawPlayerInfo(id, firstname, lastname, crewTag)
    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    local x, y, z = pos.x, pos.y, pos.z + 1.1
    
    -- Convert 3D world coordinates to 2D screen coordinates
    local onScreen, _x, _y = World3dToScreen2d(x, y, z + 0.1)
    
    if onScreen then
        -- Draw background rectangle for crew tag
        BeginTextCommandGetWidth("STRING")
        AddTextComponentString(crewTag)
        local width = EndTextCommandGetWidth(1) * 0.4
        DrawRect(_x, _y + 0.015, width, 0.03, 255, 255, 255, 200)
        
        -- Draw green bar below the crew tag
        DrawRect(_x, _y + 0.015 + 0.015, width, 0.005, 9, 214, 2, 255)
        
        -- Draw crew tag text
        SetTextFont(4)
        SetTextProportional(1)
        SetTextScale(0.5, 0.5)
        SetTextColour(0, 0, 0, 255)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(crewTag)
        EndTextCommandDisplayText(_x, _y) 

        -- Draw player ID and name
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

-- Function to continuously show name tags when enabled
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

-- Command to toggle name tag visibility
RegisterCommand(Config.Command, function(source, args, rawCommand)
    TagsVisible = not TagsVisible
    showTags(TagsVisible)
end)

-- Thread to initialize player data and send it to the server
CreateThread(function()
    emfan.waitForLogin()
    
    local PlayerData = emfan.getPlayer()
    local id = PlayerData.source
    local netPed = PedToNet(PlayerPedId())

    local NameTag = {}

    if Config.Framework == 'qb' then
        NameTag = {
            id = id,
            gang = PlayerData.gang.label,
            firstname = PlayerData.charinfo.firstname,
            lastname = PlayerData.charinfo.lastname,
            netPed = netPed
        }
    -- Prepare name tag data for the player
    local NameTag = {
        id = id,
        gang = PlayerData.gang.label,
        firstname = PlayerData.charinfo.firstname,
        lastname = PlayerData.charinfo.lastname,
        netPed = netPed
    }

    elseif Config.Framework == 'esx' then   
        NameTag = {
            id = id,
            gang = PlayerData.job.label,                    -- Change this crew / gang if you want to show this instead, just make sure this exist since it doesn't in the standard ESX.
            firstname = PlayerData.charinfo.firstname,
            lastname = PlayerData.charinfo.lastname,
            netPed = netPed
        }
       
    else
        print("Your Config.Framework is setup wrong: ", Config.Framework)
    end

    -- Send player name tag data to the server
    TriggerServerEvent('emfan-nametag:server:AddNewPlayer', id, NameTag)
end)

-- Event to update name tag data from the server
RegisterNetEvent('emfan-nametag:server:UpdateNameTagData', function(data)
    NameTagData = data
end)