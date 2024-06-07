local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('madv.gps:server:GetGroupBlipData', function(source, cb, jobName, gangName)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local blipColor = 0
    local groupTypes = {}

    if Config.Jobs[jobName] then
        blipColor = Config.Jobs[jobName].blipColor
        table.insert(groupTypes, 'Job')
    end
    
    if Config.Gangs[gangName] then
        blipColor = Config.Gangs[gangName].blipColor
        table.insert(groupTypes, 'Gang')
    end
    
    if #groupTypes == 0 then
        cb(nil)
        return
    end

    local players = QBCore.Functions.GetPlayers()
    local trackedPlayers = {}
    local totalCoords = vector3(0, 0, 0)
    local count = 0

    for _, playerId in ipairs(players) do
        local targetPlayer = QBCore.Functions.GetPlayer(playerId)
        if targetPlayer and targetPlayer.PlayerData.source ~= src then
            local targetJobName = targetPlayer.PlayerData.job.name
            local targetGangName = targetPlayer.PlayerData.gang.name

            local isJobMatch = Config.Jobs[jobName] and targetJobName == jobName
            local isGangMatch = Config.Gangs[gangName] and targetGangName == gangName

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

RegisterNetEvent('madv.gps:server:UpdateJob', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent('QBCore:Client:OnJobUpdate', src, Player.PlayerData.job)
end)

RegisterNetEvent('madv.gps:server:UpdateGang', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent('QBCore:Client:OnGangUpdate', src, Player.PlayerData.gang)
end)
