###The scripts are no longer in development and there will be no further changes!

# bungee.gps

## GPS Tracker Script for QBCore and ESX

### Englisch
This script allows players to see their colleagues from the same job or gang on the map if they have a GPS tracker item in their inventory. The blips are updated every 5 seconds and will show the player's first and last name. The gang functionality is only available for QBCore.

### German
Dieses Skript ermöglicht es Spielern, ihre Kollegen mit dem gleichen Job oder aus der gleichen Gang auf der Karte zu sehen, wenn sie einen GPS-Tracker im Inventar haben. Die Blips werden alle 5 Sekunden aktualisiert und zeigen den Vor- und Nachnamen des Spielers an. Die Gang-Funktion ist nur für QBCore verfügbar.

## Features
- Display blips for players in the same job.
- Display blips for players in the same gang (QBCore only).
- Customizable job and gang configurations.
- Blips are updated every 5 seconds.
- Blips show the player's first and last name.
- Reload command to refresh GPS tracking.

## Installation
1. Add the script to your QBCore or ESX resources folder.
2. Ensure the script is started in your server configuration.

## Configuration
Edit the `config.lua` file to customize the jobs and gangs, including their blip colors.

```lua
Config = {
    Framework = 'QBCore', -- Set to 'QBCore', 'ESX' or 'ESX_Legacy'
    ItemName = "gps_tracker",
    BlipUpdateInterval = 5000,  -- Update interval in milliseconds
    Jobs = {
        police = { blipColor = 18 }, -- Light Blue
        ambulance = { blipColor = 1 }, -- Red
        mechanic = { blipColor = 11 }, -- Light Green
        -- Add more jobs here
    },
    Gangs = {
        ballas = { blipColor = 83 }, -- Purple
        vagos = { blipColor = 5 }, -- Yellow
        -- Add more gangs here
    }
}
```

## Adding the GPS Tracker Item
Add the following entry to your shared/items.lua file in QBCore or the equivalent file in ESX:

```lua
['gps_tracker'] = {
    name = 'gps_tracker',
    label = 'GPS Tracker',
    weight = 200,
    type = 'item',
    image = 'gps.png',
    unique = false,
    useable = false,
    shouldClose = true,
    combinable = nil,
    description = 'A GPS tracker to see your colleagues on the map.'
}
```

## Commands
/reloadgps - Reloads the GPS tracking.

## Usage
- Ensure the players have the gps_tracker item in their inventory.
- Players will automatically see their colleagues on the map.
- Use the /reloadgps command if needed to refresh the GPS tracking.

## Note
- Make sure to set the Framework option in the config.lua to the appropriate framework you are using (QBCore, ESX, or ESX_Legacy).
- The gang functionality is only available for QBCore.
