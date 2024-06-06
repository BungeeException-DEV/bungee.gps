QBCore = exports['qb-core']:GetCoreObject()

-- Callback to retrieve the blip data for the group
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
                        table.insert(trackedPlayers, targetPlayer.PlayerData)
                        break
                    end
                end
            end
        end
    end

    if count > 0 then
        local averageCoords = totalCoords / count
        local playerNames = table.concat(table.map(trackedPlayers, function(player)
            local prefix = ""
            if Config.Jobs[player.job.name] and Config.Gangs[player.gang.name] then
                prefix = "Job/Gang: "
            elseif Config.Jobs[player.job.name] then
                prefix = "Job: "
            elseif Config.Gangs[player.gang.name] then
                prefix = "Gang: "
            end
            return prefix .. player.charinfo.firstname .. " " .. player.charinfo.lastname
        end), ", ")
        cb({
            coords = averageCoords,
            blipColor = blipColor,
            groupName = playerNames
        })
    else
        cb(nil)
    end
end)
