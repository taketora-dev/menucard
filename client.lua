local function DebugPrint(message)
    if Config and Config.Debug then
        print("[MENUCARD DEBUG] " .. tostring(message))
        TriggerServerEvent('menucard:server:log', '[DEBUG] ' .. tostring(message))
    end
end


local function sortedEntries(tbl)
    local entries = {}
    if tbl then
        for k, v in pairs(tbl) do
            entries[#entries+1] = { key = k, val = v }
        end
        table.sort(entries, function(a, b)
            local ao = tonumber(a.val.order or math.huge) or math.huge
            local bo = tonumber(b.val.order or math.huge) or math.huge
            if ao ~= bo then return ao < bo end
            local al = tostring(a.val.label or a.key):lower()
            local bl = tostring(b.val.label or b.key):lower()
            return al < bl
        end)
    end
    return entries
end

local function BuildMenuData()
    local menuData = {}
    
    -- Debug print
    DebugPrint("Building menu data...")
    
    -- Paket Combo
    if Config.PaketCombo then
        for _, e in ipairs(sortedEntries(Config.PaketCombo)) do
            local k, v = e.key, e.val
            local imgKey = k
            if v.items and v.items[1] and v.items[1].name then
                imgKey = v.items[1].name
            end
            local imgs = {}
            if v.items and type(v.items) == 'table' then
                for i = 1, math.min(#v.items, 2) do
                    local it = v.items[i]
                    if it and it.name then
                        imgs[#imgs+1] = "img/" .. it.name .. ".png"
                    end
                end
            end
            table.insert(menuData, {
                name = v.label,
                price = v.price,
                img = "img/" .. imgKey .. ".png",
                imgs = imgs,
                cat = "combo",
                description = v.description or ""
            })
            DebugPrint("Added combo: " .. v.label)
        end
    end
    
    -- Food
    if Config.Food then
        for _, e in ipairs(sortedEntries(Config.Food)) do
            local k, v = e.key, e.val
            table.insert(menuData, {
                name = v.label,
                price = v.price,
                img = "img/" .. k .. ".png",
                imgs = { "img/" .. k .. ".png" },
                cat = "food",
                description = v.description or ""
            })
            DebugPrint("Added food: " .. v.label)
        end
    end
    
    -- Drinks
    if Config.Drinks then
        for _, e in ipairs(sortedEntries(Config.Drinks)) do
            local k, v = e.key, e.val
            table.insert(menuData, {
                name = v.label,
                price = v.price,
                img = "img/" .. k .. ".png",
                imgs = { "img/" .. k .. ".png" },
                cat = "drink",
                description = v.description or ""
            })
            DebugPrint("Added drink: " .. v.label)
        end
    end
    
    -- Desserts
    if Config.Desserts then
        for _, e in ipairs(sortedEntries(Config.Desserts)) do
            local k, v = e.key, e.val
            table.insert(menuData, {
                name = v.label,
                price = v.price,
                img = "img/" .. k .. ".png",
                imgs = { "img/" .. k .. ".png" },
                cat = "dessert",
                description = v.description or ""
            })
            DebugPrint("Added dessert: " .. v.label)
        end
    end
    
    DebugPrint("Total menu items: " .. #menuData)
    return menuData
end

RegisterNUICallback("getMenuData", function(_, cb)
    DebugPrint("NUI callback getMenuData triggered")
    local data = BuildMenuData()
    -- Return Lua table directly; NUI will JSON-encode it.
    if type(data) ~= "table" then data = {} end
    cb(data)
end)

local function OpenMenu()
    DebugPrint("Opening menu...")
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "openMenu", debug = Config and Config.Debug or false })
    DebugPrint("Menu opened successfully")
end

RegisterCommand("menu", function()
    DebugPrint("Menu command executed")
    OpenMenu()
end, false)

RegisterNUICallback("closeMenu", function(_, cb)
    DebugPrint("Closing menu...")
    SetNuiFocus(false, false)
    cb("ok")
    DebugPrint("Menu closed successfully")
end)

-- Simple interaction zone

CreateThread(function()
    while not Config do Wait(100) end
    DebugPrint("Config loaded successfully!")
    DebugPrint("Debug mode: " .. tostring(Config.Debug))
    DebugPrint("UseTarget: " .. tostring(Config.UseTarget))
    DebugPrint("Coordinates: " .. tostring(Config.menu.coords))
    DebugPrint("Interaction size: " .. tostring(Config.menu.size))

    if Config.UseTarget then
        DebugPrint("Target system enabled: " .. tostring(Config.Target))
        local function isResourceStarted(res)
            for i=0,GetNumResources()-1 do
                if GetResourceByFindIndex(i) == res and GetResourceState(res) == "started" then
                    return true
                end
            end
            return false
        end
        if Config.Target == "ox_target" and isResourceStarted("ox_target") then
            exports.ox_target:addBoxZone({
                coords = Config.menu.coords,
                size = vector3(Config.menu.size, Config.menu.size, 2.0),
                rotation = Config.menu.heading or 0.0,
                debug = Config.Debug,
                options = {
                    {
                        name = "menucard_menu",
                        icon = "fa-solid fa-utensils",
                        label = "Lihat Menu",
                        onSelect = function()
                            DebugPrint("Target: OpenMenu via ox_target")
                            OpenMenu()
                        end
                    }
                }
            })
        elseif Config.Target == "qb-target" and isResourceStarted("qb-target") then
            exports["qb-target"]:AddBoxZone("menucard_menu", Config.menu.coords, Config.menu.size, Config.menu.size, {
                name = "menucard_menu",
                heading = Config.menu.heading or 0.0,
                debugPoly = Config.Debug,
                minZ = Config.menu.coords.z - 1.0,
                maxZ = Config.menu.coords.z + 2.0
            }, {
                options = {
                    {
                        icon = "fas fa-utensils",
                        label = "Lihat Menu",
                        event = "menucard:client:openMenu"
                    }
                },
                distance = Config.menu.size or 3.0
            })
            RegisterNetEvent("menucard:client:openMenu", function()
                DebugPrint("Target: OpenMenu via qb-target")
                OpenMenu()
            end)
        else
            DebugPrint("Target system not found or not supported!")
        end
    else
        -- fallback: manual zone
        local lastDistance = 999999
        local inZone = false
        while true do
            local sleep = 500
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - Config.menu.coords)
            if Config.Debug and math.abs(distance - lastDistance) > 1.0 then
                DebugPrint("Player distance from menu zone: " .. string.format("%.2f", distance))
                lastDistance = distance
            end
            if distance < Config.menu.size then
                sleep = 0
                if not inZone then
                    DebugPrint("Player entered menu zone!")
                    inZone = true
                end
                DrawMarker(
                    1,
                    Config.menu.coords.x, Config.menu.coords.y, Config.menu.coords.z - 1.0,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    2.0, 2.0, 1.0,
                    0, 255, 0, 100,
                    false,
                    true,
                    2,
                    false,
                    "", "",
                    false
                )
                if Config.Debug then
                    SetTextFont(4)
                    SetTextScale(0.35, 0.35)
                    SetTextColour(255, 255, 0, 255)
                    SetTextEntry("STRING")
                    AddTextComponentString("DEBUG: Menu Zone Active~n~Distance: " .. string.format("%.2f", distance) .. "~n~Coords: " .. tostring(Config.menu.coords))
                    DrawText(0.01, 0.5)
                end
                local onScreen, screenX, screenY = World3dToScreen2d(Config.menu.coords.x, Config.menu.coords.y, Config.menu.coords.z + 1.0)
                if onScreen then
                    SetTextScale(0.6, 0.6)
                    SetTextFont(4)
                    SetTextProportional(true)
                    SetTextColour(255, 255, 255, 255)
                    SetTextDropshadow(0, 0, 0, 0, 255)
                    SetTextEdge(2, 0, 0, 0, 150)
                    SetTextDropShadow()
                    SetTextOutline()
                    SetTextEntry("STRING")
                    SetTextCentre(true)
                    AddTextComponentString("~g~[E]~w~ Lihat Menu")
                    DrawText(screenX, screenY)
                end
                if IsControlJustReleased(0, 38) then
                    DebugPrint("E key pressed! Opening menu...")
                    OpenMenu()
                end
            else
                if inZone then
                    DebugPrint("Player left menu zone!")
                    inZone = false
                end
            end
            Wait(sleep)
        end
    end
end)
