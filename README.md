# madv.gps

# QBCore GPS-Tracker Script

## Beschreibung (Deutsch)
Dieses QBCore-Skript ermöglicht es Spielern, die ein bestimmtes Item (z.B. "GPS-Tracker") in ihrem Inventar haben, auf der Karte sichtbar zu sein. Spieler derselben Job- oder Gang-Gruppe können einander sehen, solange sie das Item ebenfalls besitzen. Die Blips auf der Karte werden alle 5 Sekunden aktualisiert und verschwinden, wenn das Item aus dem Inventar entfernt wird. Eine Konfigurationsdatei erlaubt es, die relevanten Jobs/Gangs und die Farbe der Blips zu definieren. Die Blips werden stets ganz oben in der Liste angezeigt und zeigen den Vor- und Nachnamen des Spielers an, zusammen mit der Kennzeichnung, ob es sich um ein Job- oder Gang-Mitglied handelt.

## Description (English)
This QBCore script allows players who have a specific item (e.g., "GPS-Tracker") in their inventory to be visible on the map. Players of the same job or gang can see each other as long as they also possess the item. The blips on the map update every 5 seconds and disappear when the item is removed from the inventory. A configuration file allows defining the relevant jobs/gangs and the color of the blips. The blips are always displayed at the top of the list and show the player's first and last name, along with a designation of whether they are a job or gang member.

## Installation

### Download and Add Files
1. Download the following files and add them to your QBCore server:
   - `config.lua`
   - `client.lua`
   - `server.lua`
   - `utils.lua`
   - `fxmanifest.lua`

### Add "GPS Tracker" Item
2. Open the `qb-core/shared/items.lua` file and add the following code:
   ```lua
   ['gps_tracker'] = {
       ['name'] = 'gps_tracker',
       ['label'] = 'GPS Tracker',
       ['weight'] = 200,
       ['type'] = 'item',
       ['image'] = 'gps_tracker.png',
       ['unique'] = true,
       ['useable'] = true,
       ['shouldClose'] = false,
       ['combinable'] = nil,
       ['description'] = 'A device that shows the location of the bearer.'
   },

### Add Item Image
3. Create an image for the GPS Tracker and save it as gps_tracker.png in the qb-inventory/html/images directory.

### Restart the Server
4. Restart your QBCore server to apply the changes.

### Notes
- Ensure the gps_tracker.png image is correctly placed in the qb-inventory/html/images directory.
- The blips on the map automatically update every 5 seconds.
- Players must have the gps_tracker item in their inventory to be visible to other players of the same job or gang group.
