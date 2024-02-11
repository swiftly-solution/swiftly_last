local g_hList = {}
local LIST_LIMIT = 5

function getPlayerInfo(player)
    local name, steamid, ip
    if not player then 
        name, steamid, ip = "Unknown", "Unknown", "Unknown"
        print("Error: Player is nil.")
    else
        name = player:GetName()
        steamid = tostring(player:GetSteamID())
        ip = player:GetIPAddress()
    end
    return name, steamid, ip
end

events:on("OnClientDisconnect", function(playerid)
    local player = GetPlayer(playerid)

    if not player then return end
    if player:IsFakeClient() == 1 then return end

    if #g_hList >= LIST_LIMIT then
        table.remove(g_hList, 1)
    end
    local name, steamid, ip = getPlayerInfo(player)
    table.insert(g_hList, {name = name, steamid = steamid, ip = ip})
end)

function listLastDisconnectedPlayers(playerid, args, argc, silent)
    if playerid == -1 then
        print("============================== LAST DISCONNECTED PLAYERS ==============================")
        for _, disconnectedPlayer in ipairs(g_hList) do
            print(string.format(".:[Name: %s | SteamID: %s | IP: %s]:.", disconnectedPlayer.name, disconnectedPlayer.steamid, disconnectedPlayer.ip))
        end        
        print("=======================================================================================")
        return
    end

    local player = GetPlayer(playerid)
    if not player then return end
    
    local IsAdmin = exports["swiftly_admins"]:CallExport("HasFlags", playerid, "b")

    if IsAdmin == 0 then
        player:SendMsg(MessageType.Console, "You don't have the permission to use this command.")
        return
    end    
    
    if IsAdmin == 1 then
        player:SendMsg(MessageType.Console, "============================== LAST DISCONNECTED PLAYERS ============================== \n")
        for _, disconnectedPlayer in ipairs(g_hList) do
            player:SendMsg(MessageType.Console, string.format(".:[Name: %s | SteamID: %s | IP: %s]:. \n", disconnectedPlayer.name, disconnectedPlayer.steamid, disconnectedPlayer.ip))
        end        
        player:SendMsg(MessageType.Console, "======================================================================================= \n")
    end
end

commands:Register("last", listLastDisconnectedPlayers)

function GetPluginAuthor()
    return "Swiftly Solution"
end

function GetPluginVersion()
    return "v1.0.0"
end

function GetPluginName()
    return "Swiftly Last"
end

function GetPluginWebsite()
    return "https://github.com/swiftly-solution/swiftly_last"
end
