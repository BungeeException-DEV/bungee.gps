local QBCore = exports['qb-core']:GetCoreObject()
local groupBlip = nil

local function updateGroupBlip(coords, blipColor, groupName)
    if not groupBlip then
        groupBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(groupBlip, 1)
        SetBlipAsShortRange(groupBlip, true)
        SetBlipDisplay(groupBlip, 4)
        SetBlipPriority(groupBlip, 10)
        SetBlipScale(groupBlip, 0.7)
        SetBlipCategory(groupBlip, 7)
    end
    
    SetBlipCoords(groupBlip, coords.x, coords.y, coords.z)
    SetBlipColour(groupBlip, blipColor)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(groupName)
    EndTextCommandSetBlipName(groupBlip)
end

local function hasGpsTracker()
    local player = QBCore.Functions.GetPlayerData()
    for _, item in ipairs(player.items) do
        if item.name == Config.ItemName then
            return true
        end
    end
    return false
end

local function updateBlip()
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

RegisterCommand('reloadgps', function()
    updateBlip()
    QBCore.Functions.Notify('GPS reloaded')
end, false)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    Citizen.CreateThread(function()
        while true do
            updateBlip()
            Citizen.Wait(Config.BlipUpdateInterval)
        end
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    if groupBlip then
        RemoveBlip(groupBlip)
        groupBlip = nil
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    QBCore.Functions.GetPlayerData().job = JobInfo
    updateBlip()
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(GangInfo)
    QBCore.Functions.GetPlayerData().gang = GangInfo
    updateBlip()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        Citizen.CreateThread(function()
            while not QBCore.Functions.GetPlayerData().job do
                Citizen.Wait(100)
            end
            updateBlip()
        end)
    end
end)
