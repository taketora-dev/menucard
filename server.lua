-- Server-side script for menucard
RegisterNetEvent('menucard:server:log', function(message)
    print("[MENUCARD] " .. tostring(message))
end)

-- Optional: Add server-side menu actions here if needed
RegisterNetEvent('menucard:server:orderItem', function(itemName, price)
    local src = source
    print("[MENUCARD] Player " .. src .. " ordered " .. itemName .. " for " .. price)
    -- Add your order processing logic here
end)
