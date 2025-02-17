print(
    [[
    ///////////////////////////////////////////////////
    /////////////// STATS SYSTEM CHARGÉ ///////////////
    ///////////////// DEV PAR KEPYYY //////////////////
    ///////////////////////////////////////////////////
    ]]
)

util.AddNetworkString("stats-open")
util.AddNetworkString("upgrade-stat")
util.AddNetworkString("setlvl-admin")
util.AddNetworkString("resetlvl-admin")
util.AddNetworkString("stat-authorized")

///////////////////////////////////////////////
// METAFONCTIONS
///////////////////////////////////////////////

local _PLAYER = FindMetaTable("Player")

// GETS //

function _PLAYER:FLK_getCharStats(charID)
    local chars = self:FLK_GetChars()

    for k, v in pairs(chars) do
        if v[charID] != nil then
            return v[charID]["stats"]
        end
    end
end

function _PLAYER:FLK_getCharPoints(charID)
    local chars = self:FLK_GetChars()

    for k, v in pairs(chars) do
        if v[charID] != nil then
            return v[charID]["points"]
        end
    end
end

function _PLAYER:FLK_getCharLevel(charID)
    local chars = self:FLK_GetChars()

    for k, v in pairs(chars) do
        if v[charID] != nil then
            return v[charID]["level"]
        end
    end
end

function _PLAYER:FLK_getCharExp(charID)
    local chars = self:FLK_GetChars()

    for k, v in pairs(chars) do
        if v[charID] != nil then
            return v[charID]["exp"]
        end
    end
end

// SETS //

function _PLAYER:FLK_setCharStats(tblstat, charID)
    local currentchars = self:FLK_GetChars()

    for k, v in pairs(currentchars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == charID then
                b["stats"] = tblstat
            end
        end
    end

    self:FLK_SaveCharData(currentchars)
end

function _PLAYER:FLK_setCharPoints(pts, charID)
    local currentchars = self:FLK_GetChars()
    
    for k, v in pairs(currentchars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == charID then
                b["points"] = pts
            end
        end
    end
    
    self:FLK_SaveCharData(currentchars)
end

function _PLAYER:FLK_setCharLevel(lvl, charID)
    local currentchars = self:FLK_GetChars()

    for k, v in pairs(currentchars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == charID then
                b["level"] = lvl
            end
        end
    end

    self:FLK_SaveCharData(currentchars)
end

function _PLAYER:FLK_setCharExp(exp, charID)
    local currentchars = self:FLK_GetChars()

    for k, v in pairs(currentchars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == charID then
                b["exp"] = exp
            end
        end
    end

    self:FLK_SaveCharData(currentchars)
end

// OTHER //

function _PLAYER:FLK_CalculateStats(charID, dataStats, heal)
    // Get l'inventaire du perso
    // Et faire un truc du genre pour appliquer les buff des items:

    local newStats = dataStats
    
    for nwstatid, nwstat in pairs(dataStats) do
        self:SetNWInt("NW_"..nwstatid, nwstat)
    end

    local charEquipped = self:FLK_getCharEquipped(charID)
    for part, itm in pairs(charEquipped) do
        if itm != "" then
            for itmid, itminfo in pairs(itm) do
                local itmtbl = getItemByID(itmid)
                local itmstats = itmtbl["statChange"]
                
                for statid, stat in pairs(newStats) do
                    newStats[statid] = stat + itmtbl["statChange"][statid]
                end
            end
        end
    end

    self:FLK_ApplyStats(charID, newStats, heal)
end

function _PLAYER:FLK_ApplyStats(charID, calcdStats, heal)
    local run_slow_const = 2.1875                               // RunSpeed de base a 350 ; WalkSpeed de base a 160 ; 350/160 = 2.1875 - je veux garder ce même ratio
    self:SetNWBool("speedMode", true)                           // Ce NWBool sera utile dans le futur pour le SWEP afin d'activer et de désactiver la compétence de vitesse
    self:SetRunSpeed(calcdStats["speed"])                       // DARKRP EDITED : gamemodes/mangarp/gamemode/modules/base/sv_util.lua - line 188-189
    self:SetWalkSpeed( math.floor(calcdStats["speed"] / run_slow_const))
    self:SetMaxHealth(calcdStats["hp"])

    self.physdmg = calcdStats["physdmg"]
    self.magicdmg = calcdStats["magicdmg"]
    self.resistphys = calcdStats["resistphys"]
    self.resistmagic = calcdStats["resistmagic"]

    if not heal then return end
    local charHp = self:FLK_getCharHealth(charID)
    if charHp != "none" then
        if charHp > calcdStats["hp"] then
            self:SetHealth(calcdStats["hp"])
        else    
            self:SetHealth(charHp)
        end
    else
        self:SetHealth(calcdStats["hp"])
    end
end

function _PLAYER:FLK_UpgradeStats(charID, stat, mul)
    local charStats = self:FLK_getCharStats(charID)
    local charPts = self:FLK_getCharPoints(charID)

    if self:FLK_getCharPoints(charID) < FLK.COMPCOST[stat] * mul then
        self:ChatPrint("Vous n'avez pas assez de point !")
        return
    end

    if FLK.COMPMAX[stat] != nil then
        if charStats[stat] >= FLK.COMPMAX[stat] or charStats[stat] + FLK.COMPADD[stat] * mul > FLK.COMPMAX[stat] then
            charStats[stat] = FLK.COMPMAX[stat]

            self:ChatPrint("Niveau maximal atteint")
            return
        end
    end

    self:SetNWInt("clientPts", charPts - FLK.COMPCOST[stat] * mul)
    self:SetNWInt("NW_"..stat, charStats[stat])
    
    charStats[stat] = charStats[stat] + FLK.COMPADD[stat] * mul
    
    self:FLK_setCharStats(charStats, charID)
    self:FLK_setCharPoints(charPts - FLK.COMPCOST[stat] * mul, charID)
    
    self:ChatPrint("Vous avez ajouté " .. FLK.COMPADD[stat] * mul .. " de compétence pour " .. FLK.COMPCOST[stat] * mul .. " points." )
    
    charPts = self:FLK_getCharPoints(charID)
    
    net.Start("stat-authorized")
        net.WriteTable(charStats)
        net.WriteInt(charPts, 16)
    net.Send(self)

    self:FLK_CalculateStats(charID, charStats, false)
end

--

function _PLAYER:GetPhysDmg()
    return self.physdmg or 1
end

function _PLAYER:GetMagicDmg()
    return self.magicdmg or 1
end

function _PLAYER:GetResistPhys()
    return self.resistphys or 1
end

function _PLAYER:GetResistMagic()
    return self.resistmagic or 1
end

///////////////////////////////////////////////
// FONCTIONS
///////////////////////////////////////////////

function StatsInit()
    timer.Create("SS.EXP_TIMER", FLK.LEVELUP_TIME, 0,  AddXPTimer)
end

function AddXPTimer()
    local allply = player.GetAll()
    if table.Count(allply) == 0 then print("No players connected ; no XP given") return end
    if FLK.ADDXP > FLK.BASEXP then print("ERROR : Config's ADDXP value cannot be equal of higher than BASEXP.") return end

    for _, ply in pairs(allply) do
        if ply:FLK_getCurrentChar() == "char_none" then return end

        local charID = ply:FLK_getCurrentChar()
        local curExp = ply:FLK_getCharExp(charID)
        local curLvl = ply:FLK_getCharLevel(charID)
        local curPts = ply:FLK_getCharPoints(charID)

        if curLvl >= FLK.MAXLEVEL then return end

        local reqExp = FLK.FORMULA(curLvl)
        if reqExp < FLK.ADDXP then print("ERROR : Required EXP to level up is lower than the attempted addition of EXP.") return end

        ply:FLK_setCharExp(curExp + FLK.ADDXP, charID)
        ply:SetNWInt("clientExp", curExp + FLK.ADDXP)

        local checkSumExp = reqExp-curExp
        if curExp >= reqExp or checkSumExp <= FLK.ADDXP then
            ply:FLK_setCharLevel(curLvl + 1, charID)
            ply:FLK_setCharPoints(curPts + 1, charID)
            ply:SetNWInt("clientLvl", curLvl + 1)
            ply:SetNWInt("clientPts", curPts + 1)
        end
    end
end

function OnSpawn(ply)
    local id = ply:FLK_getCurrentChar()
    if id == "char_none" then return end

    
    local curExp = ply:FLK_getCharExp(id)
    local curLvl = ply:FLK_getCharLevel(id)
    local curPts = ply:FLK_getCharPoints(id)
    ply:SetNWInt("clientExp", curExp)
    ply:SetNWInt("clientLvl", curLvl)
    ply:SetNWInt("clientPts", curPts)
    
    local curstats = ply:FLK_getCharStats(id)

    --timer.Simple(0.1, function()              // DARKRP EDITED : gamemodes/mangarp/gamemode/modules/base/sv_util.lua - line 199-203
    ply:FLK_CalculateStats(id, curstats, true)
    --end)                                      // J'ai modif le darkrp au lieu d'ajouter un vieux timer dégueu (c'est plus opti, ça évite d'appliquer 27 trucs au spawn !)
end

function OpenStatsMenu(ply)
    local plyCharsTable = ply:FLK_GetChars() 
    local plyCharID = ply:FLK_getCurrentChar()
    local plyCharStats = ply:FLK_getCharStats(plyCharID)
    local plyCharPoints = ply:FLK_getCharPoints(plyCharID)
    local binds = ply:FLK_GetBinds()

    net.Start("stats-open")
        net.WriteTable(plyCharsTable)
        net.WriteString(plyCharID)
        net.WriteTable(plyCharStats)
        net.WriteInt(plyCharPoints, 16)
        net.WriteInt(binds["OpenStats"], 16)
    net.Send(ply)
end

AddXPTimer()
StatsInit()

///////////////////////////////////////////////
// HOOKS & NETS
///////////////////////////////////////////////

hook.Add("PlayerSpawn", "SS.OnSpawn", OnSpawn)

hook.Add("PlayerSay", "SS.StatsOpen", function(ply, txt)
    if txt != "/stats" then return end

    OpenStatsMenu(ply)

    return ""
end)

hook.Add("PlayerButtonDown", "SM.StatsBindOpen", function(ply, btn)
    local binds = ply:FLK_GetBinds()
    if btn != binds["OpenStats"] then return end
    
    OpenStatsMenu(ply)
end)

hook.Add("PlayerSay", "SS.Heal", function(ply, txt)
    if txt != "/heal" then return end

    ply:SetHealth(ply:GetMaxHealth())

    return ""
end)

net.Receive("upgrade-stat", function(len, ply)
    local mul = net.ReadInt(8)
    local stat = net.ReadString()
    local id = ply:FLK_getCurrentChar()

    ply:FLK_UpgradeStats(id, stat, mul)
end)

net.Receive("setlvl-admin", function(len, ply)
    if not FLK.CONFIG_ADMINUSERGROUPS[ply:GetUserGroup()] then ply:ChatPrint("Accès refusé") return end

    local selPly = net.ReadPlayer()
    local charData = net.ReadTable()
    local charID = charData["uniqueid"]
    local lvl = net.ReadInt(16)
    local formula = FLK.FORMULA(lvl-1)

    local defaultstats = {
        ["physdmg"] = FLK.BASEPHYSDAMAGE,
        ["magicdmg"] = FLK.BASEMAGICDAMAGE,
        ["hp"] = FLK.BASEHP,
        ["resistphys"] = FLK.BASERESISTPHYS,
        ["resistmagic"] = FLK.BASERESISTMAGIC,
        ["mana"] = FLK.BASEMANA,
        ["speed"] = FLK.BASERUNSPEED,
        ["cdreduc"] = FLK.BASECDREDUC
    }

    selPly:FLK_setCharStats(defaultstats, charID)
    selPly:FLK_setCharExp(formula, charID)
    selPly:FLK_setCharLevel(lvl, charID)
    selPly:FLK_setCharPoints(lvl, charID)
    if selPly:FLK_getCurrentChar() == charID then
        selPly:FLK_CalculateStats(charID, defaultstats, true)
        selPly:SetNWInt("clientExp", formula)
        selPly:SetNWInt("clientLvl", lvl)
        selPly:SetNWInt("clientPts", lvl)
    end
end)

net.Receive("resetlvl-admin", function(len, ply)
    if not FLK.CONFIG_ADMINUSERGROUPS[ply:GetUserGroup()] then ply:ChatPrint("Accès refusé") return end
    
    local selPly = net.ReadPlayer()
    local charData = net.ReadTable()
    local charID = charData["uniqueid"]

    local defaultstats = {
        ["physdmg"] = FLK.BASEPHYSDAMAGE,
        ["magicdmg"] = FLK.BASEMAGICDAMAGE,
        ["hp"] = FLK.BASEHP,
        ["resistphys"] = FLK.BASERESISTPHYS,
        ["resistmagic"] = FLK.BASERESISTMAGIC,
        ["mana"] = FLK.BASEMANA,
        ["speed"] = FLK.BASERUNSPEED,
        ["cdreduc"] = FLK.BASECDREDUC
    }

    selPly:FLK_setCharStats(defaultstats, charID)
    selPly:FLK_setCharExp(0, charID)
    selPly:FLK_setCharLevel(0, charID)
    selPly:FLK_setCharPoints(0, charID)
    if selPly:FLK_getCurrentChar() == charID then
        selPly:FLK_CalculateStats(charID, defaultstats, true)
        selPly:SetNWInt("clientExp", 0)
        selPly:SetNWInt("clientLvl", 0)
        selPly:SetNWInt("clientPts", 0)
    end
end)

hook.Add("EntityTakeDamage", "OnDmgApplyStatTest", function(ent, dmginfo)
    local atck = dmginfo:GetAttacker()
    local dmg = 80
    
    if atck:IsPlayer() and IsValid(atck) then
        local calcdmg = math.floor( dmg + (((atck:GetPhysDmg()/100)*dmg)/1.3) )
        dmginfo:SetDamage(calcdmg)    
        atck:ChatPrint(calcdmg) 
    end
end)