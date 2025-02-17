print(
    [[
    ///////////////////////////////////////////////////////
    /////////////// CHARGEMENT DES SYSTEMES ///////////////
    //////////////////// DEV PAR KEPYYY ///////////////////
    ///////////////////////////////////////////////////////
    ]]
)

include("flk_config.lua")
AddCSLuaFile("flk_config.lua")

local fl, dir = file.Find("addons/fantasylk-systems-main/lua/modules/*", "garrysmod")

for k, v in pairs(dir) do
    local flsmod, dirsmod = file.Find("addons/fantasylk-systems-main/lua/modules/"..v.."/server/*.lua", "garrysmod")
    for _, b in pairs(flsmod) do
        include("modules/"..v.."/server/"..b)
    end

    local flcmod, dircmod = file.Find("addons/fantasylk-systems-main/lua/modules/"..v.."/client/*.lua", "garrysmod")
    table.Add(tbl, flcmod)
    for _, d in pairs(flcmod) do
        AddCSLuaFile("modules/"..v.."/client/"..d)
    end
end