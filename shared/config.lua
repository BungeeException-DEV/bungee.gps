---
--- Here are the Blip Colors https://docs.fivem.net/docs/game-references/blips/
---

Config = {
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
