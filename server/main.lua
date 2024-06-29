local Framework = nil
if Config.Framework == 'QBCore' then
    Framework = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'ESX' or Config.Framework == 'ESX_Legacy' then
    Framework = exports['es_extended']:getSharedObject()
end

Framework.Functions.CreateCallback('bungee.gps:server:GetGroupBlipData', function(source, cb, jobName, gangName)
    local src = source
    local xPlayer = Framework.GetPlayer(src)
    local blipColor = 0
    local groupTypes = {}

    if Config.Jobs[jobName] then
        blipColor = Config.Jobs[jobName].blipColor
        table.insert(groupTypes, 'Job')
    end
    
    if Config.Framework == 'QBCore' and Config.Gangs[gangName] then
        blipColor = Config.Gangs[gangName].blipColor
        table.insert(groupTypes, 'Gang')
    end
    
    if #groupTypes == 0 then
        cb(nil)
        return
    end

    local players = Framework.GetPlayers()
    local trackedPlayers = {}
    local totalCoords = vector3(0, 0, 0)
    local count = 0

    for _, playerId in ipairs(players) do
        local targetPlayer = Framework.GetPlayer(playerId)
        if targetPlayer and targetPlayer.PlayerData.source ~= src then
            local targetJobName = targetPlayer.PlayerData.job.name
            local targetGangName = targetPlayer.PlayerData.gang and targetPlayer.PlayerData.gang.name or nil

            local isJobMatch = Config.Jobs[jobName] and targetJobName == jobName
            local isGangMatch = Config.Framework == 'QBCore' and Config.Gangs[gangName] and targetGangName == gangName

            if isJobMatch or isGangMatch then
                local items = targetPlayer.PlayerData.items
                for _, item in ipairs(items) do
                    if item.name == Config.ItemName then
                        local coords = GetEntityCoords(GetPlayerPed(targetPlayer.PlayerData.source))
                        totalCoords = totalCoords + coords
                        count = count + 1
                        table.insert(trackedPlayers, {
                            jobName = targetJobName,
                            gangName = targetGangName,
                            firstName = targetPlayer.PlayerData.charinfo.firstname,
                            lastName = targetPlayer.PlayerData.charinfo.lastname
                        })
                        break
                    end
                end
            end
        end
    end

    if count > 0 then
        local averageCoords = totalCoords / count
        local playerNames = ""
        for i, player in ipairs(trackedPlayers) do
            local jobConfig = Config.Jobs[player.jobName]
            local gangConfig = Config.Gangs[player.gangName]
            local prefix = ""

            if jobConfig and gangConfig then
                if jobName == player.jobName and gangName == player.gangName then
                    prefix = "Job/Gang: "
                elseif jobName == player.jobName then
                    prefix = "Job: "
                elseif gangName == player.gangName then
                    prefix = "Gang: "
                end
            elseif jobConfig then
                prefix = "Job: "
            elseif gangConfig then
                prefix = "Gang: "
            end

            playerNames = playerNames .. prefix .. player.firstName .. " " .. player.lastName
            if i < #trackedPlayers then
                playerNames = playerNames .. ", "
            end
        end
        
        cb({
            coords = averageCoords,
            blipColor = blipColor,
            groupName = playerNames
        })
    else
        cb(nil)
    end
end)

RegisterNetEvent('bungee.gps:server:UpdateJob', function()
    local src = source
    local Player = Framework.GetPlayer(src)
    TriggerClientEvent(Config.Framework == 'QBCore' and 'Framework:Client:OnJobUpdate' or 'esx:setJob', src, Player.PlayerData.job)
end)

if Config.Framework == 'QBCore' then
    RegisterNetEvent('bungee.gps:server:UpdateGang', function()
        local src = source
        local Player = Framework.GetPlayer(src)
        TriggerClientEvent('Framework:Client:OnGangUpdate', src, Player.PlayerData.gang)
    end)
end
