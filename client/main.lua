QBCore = exports['qb-core']:GetCoreObject()
local groupBlip = nil

local function updateGroupBlip(coords, blipColor, groupName)
    if not groupBlip then
        groupBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(groupBlip, 1)
        SetBlipAsShortRange(groupBlip, true)
        SetBlipDisplay(groupBlip, 4)
        SetBlipPriority(groupBlip, 10) -- Blip Priority
        SetBlipScale(groupBlip, 0.7) -- Blip Scale
        SetBlipCategory(groupBlip, 7) -- That the blip is at the top
    end
    
    SetBlipCoords(groupBlip, coords.x, coords.y, coords.z)
    SetBlipColour(groupBlip, blipColor)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(groupName)
    EndTextCommandSetBlipName(groupBlip)
end

-- Check if the player has the item
local function hasGpsTracker()
    local player = QBCore.Functions.GetPlayerData()
    for _, item in ipairs(player.items) do
        if item.name == Config.ItemName then
            return true
        end
    end
    return false
end

-- Main function to update the blips
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.BlipUpdateInterval)

        local player = QBCore.Functions.GetPlayerData()
        if hasGpsTracker() then
            QBCore.Functions.TriggerCallback('madv.gps:server:GetGroupBlipData', function(groupData)
                if groupData then
                    local coords = groupData.coords
                    local blipColor = groupData.blipColor
                    local groupName = groupData.groupName
                    updateGroupBlip(coords, blipColor, groupName)
                else
                    if groupBlip then
                        RemoveBlip(groupBlip)
                        groupBlip = nil
                    end
                end
            end, player.job.name, player.gang.name)
        else
            if groupBlip then
                RemoveBlip(groupBlip)
                groupBlip = nil
            end
        end
    end
end)
