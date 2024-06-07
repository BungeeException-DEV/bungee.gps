# madv.gps

# QBCore GPS Tracker Script

# Englisch
This script allows players to see their colleagues from the same job or gang on the map if they have a GPS tracker item in their inventory. The blips are updated every 5 seconds and will show the player's first and last name. 

# German
Dieses Skript ermöglicht es Spielern, ihre Kollegen mit dem gleichen Job oder aus der gleichen Gang auf der Karte zu sehen, wenn sie einen GPS-Tracker im Inventar haben. Die Blips werden alle 5 Sekunden aktualisiert und zeigen den Vor- und Nachnamen des Spielers an.

## Features
- Display blips for players in the same job or gang.
- Customizable job and gang configurations.
- Blips are updated every 5 seconds.
- Blips show the player's first and last name.
- Reload command to refresh GPS tracking.

## Installation
1. Add the script to your QBCore resources folder.
2. Ensure the script is started in your server configuration.

## Configuration
Edit the `config.lua` file to customize the jobs and gangs, including their blip colors.

```lua
Config = {
    ItemName = "gps_tracker",
    BlipUpdateInterval = 5000,  -- Update interval in milliseconds
    Jobs = {
        police = { blipColor = 3 },
        ambulance = { blipColor = 1 },
        mechanic = { blipColor = 5 },
        -- Add more jobs here
    },
    Gangs = {
        ballas = { blipColor = 5 },
        vagos = { blipColor = 46 },
        -- Add more gangs here
    }
}
```

## Adding the GPS Tracker Item
Add the following entry to your shared/items.lua file in QBCore:

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
