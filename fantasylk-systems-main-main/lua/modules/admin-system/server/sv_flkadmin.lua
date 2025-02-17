print(
    [[
    ///////////////////////////////////////////////////
    /////////////// ADMIN SYSTEM CHARGÉ ///////////////
    ///////////////// DEV PAR KEPYYY //////////////////
    ///////////////////////////////////////////////////
    ]]
)

util.AddNetworkString("admin-menu")
util.AddNetworkString("admin-sel-char")
util.AddNetworkString("admin-sel-ply-charsinfo")
util.AddNetworkString("admin-set-new-chardata")
util.AddNetworkString("admin-del-chardata")
util.AddNetworkString("admin-chara-create")
util.AddNetworkString("admin-setspawnpos")
util.AddNetworkString("admin-delspawnpos")

net.Receive("admin-chara-create", function(len, ply)
    if not FLK.CONFIG_ADMINUSERGROUPS[ply:GetUserGroup()] then ply:ChatPrint("Accès refusé") return end

    local selPly = net.ReadPlayer()
    local charName = net.ReadString()
    local charMdl = net.ReadString()
    local charJob = net.ReadString()
    local charRace = net.ReadString()

    selPly:FLK_CreateChar(charName, charMdl, charJob, charRace)
end)

net.Receive("admin-sel-char", function(len, ply)
    if not FLK.CONFIG_ADMINUSERGROUPS[ply:GetUserGroup()] then ply:ChatPrint("Accès refusé") return end

    local selPly = net.ReadPlayer()
    local selPlyChars = selPly:FLK_GetChars()

    net.Start("admin-sel-ply-charsinfo")
        net.WriteTable(selPlyChars)
    net.Send(ply)
end)

net.Receive("admin-set-new-chardata", function(len, ply)
    if not FLK.CONFIG_ADMINUSERGROUPS[ply:GetUserGroup()] then ply:ChatPrint("Accès refusé") return end

    local selPly = net.ReadPlayer()
    local charid = net.ReadString()
    local newname = net.ReadString()
    local newmodel = net.ReadString()
    local newjob = net.ReadString()
    local newrace = net.ReadString()

    selPly:FLK_AdminChangeChar(charid, newname, newmodel, newjob, newrace)
end)

net.Receive("admin-del-chardata", function(len, ply)
    if not FLK.CONFIG_ADMINUSERGROUPS[ply:GetUserGroup()] then ply:ChatPrint("Accès refusé") return end
    local plysel = net.ReadPlayer()
    local charid = net.ReadString()
            
    plysel:FLK_AdminDelChar(charid)
    plysel:SetNWString("currentCharID", "char_none")
end)

net.Receive("admin-setspawnpos", function(len, ply)
    if not FLK.CONFIG_ADMINUSERGROUPS[ply:GetUserGroup()] then ply:ChatPrint("Accès refusé") return end
    local selPly = net.ReadPlayer()
    local charID = net.ReadString()
    local pos = ply:GetPos()

    selPly:FLK_setCharSpawnPos(pos, charID)
    ply:ChatPrint("Position de spawn du personnage "..charID.." mise à votre position ("..tostring(pos)..").")
end)

net.Receive("admin-delspawnpos", function(len, ply)
    if not FLK.CONFIG_ADMINUSERGROUPS[ply:GetUserGroup()] then ply:ChatPrint("Accès refusé") return end
    local selPly = net.ReadPlayer()
    local charID = net.ReadString()

    selPly:FLK_setCharSpawnPos("none", charID)
    ply:ChatPrint("Position de spawn du personnage "..charID.." réinitialiser.")
end)

hook.Add("PlayerSay", "FLK.AdminMenu", function(ply, txt)
    if txt != "/flkadmin" then return end
    if not FLK.CONFIG_ADMINUSERGROUPS[ply:GetUserGroup()] then ply:ChatPrint("Accès refusé") return end
    
    net.Start("admin-menu")
    net.Send(ply)

    return ""
end)

hook.Add("PlayerButtonDown", "FLK.AdminBindOpen", function(ply, btn)
    local binds = ply:FLK_GetBinds()
    if btn != binds["AdminMenu"] then return end
    if not FLK.CONFIG_ADMINUSERGROUPS[ply:GetUserGroup()] then ply:ChatPrint("Accès refusé") return end

    net.Start("admin-menu")
    net.Send(ply)
end)

hook.Add("PlayerSay", "FLK.ResetAllPlayerCharsLvl", function(ply, txt)
    if txt != "/flkresetallplayercharslvl" then return end
    if not ply:IsSuperAdmin() then ply:ChatPrint("Accès refusé") return end
    
    local defaultstats = {
        ["physdmg"] = 1,
        ["magicdmg"] = 1,
        ["hp"] = FLK.BASEHP,
        ["resistphys"] = 1,
        ["resistmagic"] = 1,
        ["mana"] = 500,
        ["speed"] = 350,
        ["cdreduc"] = 0
    }

    for _, allPly in pairs(player.GetAll()) do
        local plyChars = allPly:FLK_GetChars()

        for _, allchars in pairs(plyChars) do
            for charid, chardata in pairs(allchars) do
                local lvl = allPly:FLK_getCharLevel(charid)
                local formula = FLK.FORMULA(lvl-1)

                allPly:FLK_setCharStats(defaultstats, charid)
                allPly:FLK_setCharExp(formula, charid)
                allPly:FLK_setCharLevel(lvl, charid)
                allPly:FLK_setCharPoints(lvl, charid)
                if allPly:FLK_getCurrentChar() == charid then
                    allPly:FLK_CalculateStats(charid, defaultstats, true)
                    allPly:SetNWInt("clientExp", formula)
                    allPly:SetNWInt("clientLvl", lvl)
                    allPly:SetNWInt("clientPts", lvl)
                end
            end
        end
    end

    return ""
end)