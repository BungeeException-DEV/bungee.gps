local Framework = nil
if Config.Framework == 'QBCore' then
    Framework = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'ESX' or Config.Framework == 'ESX_Legacy' then
    Framework = exports['es_extended']:getSharedObject()
end

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
    local player = Framework.GetPlayerData()
    for _, item in ipairs(player.items) do
        if item.name == Config.ItemName then
            return true
        end
    end
    return false
end

local function updateBlip()
    local player = Framework.GetPlayerData()
    if hasGpsTracker() then
        Framework.TriggerCallback('bungee.gps:server:GetGroupBlipData', function(groupData)
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
        end, player.job.name, (Config.Framework == 'QBCore' and player.gang.name or nil))
    else
        if groupBlip then
            RemoveBlip(groupBlip)
            groupBlip = nil
        end
    end
end

RegisterCommand('reloadgps', function()
    updateBlip()
    Framework.Notify('GPS reloaded')
end, false)

AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.CreateThread(function()
        while true do
            updateBlip()
            Citizen.Wait(Config.BlipUpdateInterval)
        end
    end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload', function()
    if groupBlip then
        RemoveBlip(groupBlip)
        groupBlip = nil
    end
end)

RegisterNetEvent('Framework:Client:OnJobUpdate', function(JobInfo)
    Framework.GetPlayerData().job = JobInfo
    updateBlip()
end)

if Config.Framework == 'ESX' or Config.Framework == 'ESX_Legacy' then
    RegisterNetEvent('esx:setJob', function(JobInfo)
        Framework.GetPlayerData().job = JobInfo
        updateBlip()
    end)
end

if Config.Framework == 'QBCore' then
    RegisterNetEvent('Framework:Client:OnGangUpdate', function(GangInfo)
        Framework.GetPlayerData().gang = GangInfo
        updateBlip()
    end)
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        Citizen.CreateThread(function()
            while not Framework.GetPlayerData().job do
                Citizen.Wait(100)
            end
            updateBlip()
        end)
    end
end)
