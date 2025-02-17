print(
    [[
    /////////////////////////////////////////////
    /////////// BIND SYSTEMS CHARGÉ /////////////
    ////////////// DEV PAR KEPYYY ///////////////
    /////////////////////////////////////////////
    ]]
)

include("flk_config.lua")
AddCSLuaFile("flk_config.lua")

util.AddNetworkString("open-binds")
util.AddNetworkString("new-bind")
util.AddNetworkString("reset-binds")

////
local _PLAYER = FindMetaTable("Player")

function _PLAYER:FLK_HasBindDATA()
    local user_id = SQLStr("binds_"..self:SteamID64())
    local chars = sql.Query(" SELECT jsonBindTable FROM FLK_PlayerBinds WHERE user_id = "..user_id.." LIMIT 1")

    if chars == nil or chars == false then return false else return true end
end

function _PLAYER:FLK_GetBinds()
    local user_id = SQLStr("binds_"..self:SteamID64())
    local binds = sql.QueryValue(" SELECT jsonBindTable FROM FLK_PlayerBinds WHERE user_id = "..user_id.." LIMIT 1")

    if binds == nil then return FLK.DEFAULTBINDS end
    return util.JSONToTable(binds)
end

function _PLAYER:FLK_SaveBindData(data)
    local user_id = SQLStr("binds_"..self:SteamID64())
    sql.Query( "REPLACE INTO FLK_PlayerBinds ( user_id, jsonBindTable ) VALUES ( " .. user_id .. ", '" .. util.TableToJSON(data) .. "' )" )

    hook.Call("FLK_bindDataSaved", nil, self, data)
end

////

function BindDataInitialize()
    if sql.TableExists("FLK_PlayerBinds") then 
        return
    else
        sql.Query("CREATE TABLE FLK_PlayerBinds( user_id TEXT NOT NULL PRIMARY KEY , jsonBindTable TEXT )")                // Sinon on créé la table
    end
end

BindDataInitialize()

function BindPlayerInit(ply)
    if not ply:FLK_HasBindDATA() then -- big safeguard en gros
        -- Initialise le fichier data pour les binds du joueurs

        ply:FLK_SaveBindData(FLK.DEFAULTBINDS)
            
        return
    end
end

////////////////////////////////////////

net.Receive("new-bind", function(len, ply)
    local binds = net.ReadTable()

    ply:FLK_SaveBindData(binds)
end)

net.Receive("reset-binds", function(len, ply)
    ply:FLK_SaveBindData(FLK.DEFAULTBINDS)
end)

hook.Add("PlayerInitialSpawn", "BS.FirstSpawn", BindPlayerInit)

hook.Add("PlayerSay", "BS.OpenMenu", function(ply, txt)
    if txt != "/binds" then return end

    local bind = ply:FLK_GetBinds()

    net.Start("open-binds")
        net.WriteTable(bind)
    net.Send(ply)

    return ""
end)