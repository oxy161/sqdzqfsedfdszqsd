print(
    [[
    ////////////////////////////////////////////////////////
    /////////////// CHARACTER CREATOR CHARGÉ ///////////////
    //////////////////// DEV PAR KEPYYY ////////////////////
    ////////////////////////////////////////////////////////
    ]]
)

util.AddNetworkString("new-player")
util.AddNetworkString("old-player")
util.AddNetworkString("np-chara-create")
util.AddNetworkString("selected-char")
util.AddNetworkString("return-charasel")
util.AddNetworkString("bdg-open")
util.AddNetworkString("apply-bdg")
util.AddNetworkString("bind-menu")

include("flk_config.lua")
AddCSLuaFile("flk_config.lua")

--[[
A faire :

 - Esthétique

]]

/////////////////////////////////////////////////////////////////////////
// METAFONCTIONS /// METAFONCTIONS /// METAFONCTIONS /// METAFONCTIONS // 
/////////////////////////////////////////////////////////////////////////

local _PLAYER = FindMetaTable("Player")

// return bool / Vérifie si le joueur à bien de la DATA //
function _PLAYER:FLK_HasDATA()
    local chars = sql.Query(" SELECT jsonCharTable FROM FLK_Characters WHERE user_id = 'chars_"..self:SteamID64().."' LIMIT 1")

    if chars == nil or chars == false then return false else return true end
end

// Switch le joueur de personnage //
function _PLAYER:FLK_changeChar(charID, force)
    local id = self:FLK_getCurrentChar()
        
    if self:Alive() then 
        local discHp = self:Health()
        local discPos = self:GetPos()
        self:FLK_setCharHealth(discHp, id)
        self:FLK_setCharPos(discPos, id)
    end

    local discMoney = self:getDarkRPVar("money")
    self:FLK_setCharMoney(discMoney, id)

    if id == charID and force != true then self:ChatPrint("Vous jouez déjà ce personnage...") return end
    
    local charDataTable = self:FLK_GetChars()
    
    for k, v in pairs(charDataTable) do -- "obligé" de loop et de check nil du au fonctionnement du JSON, qui est convertit en table lorsque réimporté en lua
        if v[charID] != nil then
            local charName = v[charID]["name"]
            local charJob = v[charID]["job"]
            local charMoney = v[charID]["money"]
            local charMdl = v[charID]["model"]
            local charSkin = v[charID]["skin"]
            local charBdg = v[charID]["bodygroup"]
            local charPos = v[charID]["lastpos"]
            local charSpawnPos = v[charID]["spawnpos"]
            local charHp = v[charID]["health"]
            local _, jb = DarkRP.getJobByCommand(charJob)
            if jb == nil then self:ChatPrint("ERREUR : Votre job n'existe pas. Contactez un administrateur.") return end

            self:SetNWString("currentCharID", charID)
            self:changeTeam(jb, true)
            self:setDarkRPVar("money", charMoney)
            self:Spawn()
            self:setRPName(charName)

            if charPos != "none" then
                self:SetPos(charPos)
            else
                if charSpawnPos != "none" then
                    self:SetPos(charSpawnPos)
                end
            end

            // Hook de quand le joueur change de perso, args = le joueur, le perso d'avant et perso d'après
            hook.Run("FLK_PlayerChangeChar", self, id, charID)
        end
    end
end

// Permet de tout changer en une seule fonction (pour le menu admin)
function _PLAYER:FLK_AdminChangeChar(id, name, model, job, race)
    local currentchars = self:FLK_GetChars()

    local discPos = self:GetPos()
    local discHp = self:Health()
    local charid = self:FLK_getCurrentChar()
    
    self:FLK_setCharPos(discPos, charid)
    self:FLK_setCharHealth(discHp, charid)
    
    self:FLK_resetCharBdg(id)
    self:FLK_setCharName(name, id)
    self:FLK_setCharModel(model, id)
    self:FLK_setCharJob(job, id)
    self:FLK_setCharRace(race, id)
    
    self:FLK_changeChar(id, true)
end

// return table / Sort une table de tous les persos du joueur //
function _PLAYER:FLK_GetChars()
    local user_id = SQLStr("chars_"..self:SteamID64())
    local chars = sql.QueryValue(" SELECT jsonCharTable FROM FLK_Characters WHERE user_id = "..user_id.." LIMIT 1")

    if chars == nil then return {} end
    return util.JSONToTable(chars)
end

function _PLAYER:FLK_resetCharBdg(charID)
    if charID == "char_none" then return end
    local currentchars = self:FLK_GetChars()

    for k, v in pairs(currentchars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == charID then
                b["bodygroup"] = "none"
                b["skin"] = 0
            end
        end
    end

    self:FLK_SaveCharData(currentchars)
end

// return string / Donne l'ID du personnage actuel du joueur //
function _PLAYER:FLK_getCurrentChar()
    return self:GetNWString("currentCharID", "char_none")
end

// return int / Permet de compter le nombre de persos d'un joueur //
function _PLAYER:FLK_getCharAmount()
    return table.Count(self:FLK_GetChars())
end

// return string / donne les noms, model ou team (nom du job darkrp pour l'instant) du perso //
function _PLAYER:FLK_getCharName(charID)
    local chars = self:FLK_GetChars()

    for k, v in pairs(chars) do
        if v[charID] != nil then
            return v[charID]["name"]
        end
    end
end

function _PLAYER:FLK_getCharModel(charID)
    if not SERVER then return end

    local chars = self:FLK_GetChars()

    for k, v in pairs(chars) do
        if v[charID] != nil then
            return v[charID]["model"]
        end
    end
end

function _PLAYER:FLK_getCharJob(charID)
    local chars = self:FLK_GetChars()

    for k, v in pairs(chars) do
        if v[charID] != nil then
            return v[charID]["job"]
        end
    end
end

function _PLAYER:FLK_getCharMoney(charID)
    local chars = self:FLK_GetChars()

    for k, v in pairs(chars) do
        if v[charID] != nil then
            return v[charID]["money"]
        end
    end
end

function _PLAYER:FLK_getCharPos(charID)
    local chars = self:FLK_GetChars()

    for k, v in pairs(chars) do
        if v[charID] != nil then
            return v[charID]["lastpos"]
        end
    end
end

function _PLAYER:FLK_getCharBdg(charID)
    local chars = self:FLK_GetChars()

    for k, v in pairs(chars) do
        if v[charID] != nil then
            return v[charID]["bodygroup"]
        end
    end
end

function _PLAYER:FLK_getCharSkin(charID)
    local chars = self:FLK_GetChars()

    for k, v in pairs(chars) do
        if v[charID] != nil then
            return v[charID]["skin"]
        end
    end
end

function _PLAYER:FLK_getCharHealth(charID)
    local chars = self:FLK_GetChars()

    for k, v in pairs(chars) do
        if v[charID] != nil then
            return v[charID]["health"]
        end
    end
end

function _PLAYER:FLK_getCharSpawnPos(charID)
    local chars = self:FLK_GetChars()

    for k, v in pairs(chars) do
        if v[charID] != nil then
            return v[charID]["spawnpos"]
        end
    end
end

// Permet de changer des propriétés des persos
function _PLAYER:FLK_setCharModel(model, charID)
    if charID == "char_none" then return end
    local currentchars = self:FLK_GetChars()

    for k, v in pairs(currentchars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == charID then
                b["model"] = model
            end
        end
    end

    self:FLK_SaveCharData(currentchars)
end

function _PLAYER:FLK_setCharName(name, charID)
    if charID == "char_none" then return end
    local currentchars = self:FLK_GetChars()

    for k, v in pairs(currentchars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == charID then
                b["name"] = name
            end
        end
    end

    self:FLK_SaveCharData(currentchars)
end

function _PLAYER:FLK_setCharJob(comm, charID)
    if charID == "char_none" then return end
    local currentchars = self:FLK_GetChars()

    for k, v in pairs(currentchars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == charID then
                b["job"] = comm
            end
        end
    end

    self:FLK_SaveCharData(currentchars)
end

function _PLAYER:FLK_setCharMoney(amt, charID)
    if charID == "char_none" then return end
    local currentchars = self:FLK_GetChars()

    for k, v in pairs(currentchars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == charID then
                b["money"] = amt
            end
        end
    end

    self:FLK_SaveCharData(currentchars)
end

function _PLAYER:FLK_setCharRace(race, charID)
    if charID == "char_none" then return end
    local currentchars = self:FLK_GetChars()

    for k, v in pairs(currentchars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == charID then
                b["race"] = race
            end
        end
    end

    self:FLK_SaveCharData(currentchars)
end

function _PLAYER:FLK_setCharPos(pos, charID)
    if charID == "char_none" then return end
    local currentchars = self:FLK_GetChars()

    for k, v in pairs(currentchars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == charID then
                b["lastpos"] = pos
            end
        end
    end

    self:FLK_SaveCharData(currentchars)
end

function _PLAYER:FLK_setCharHealth(hp, charID)
    if charID == "char_none" then return end
    local currentchars = self:FLK_GetChars()

    for k, v in pairs(currentchars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == charID then
                b["health"] = hp
            end
        end
    end

    self:FLK_SaveCharData(currentchars)
end

function _PLAYER:FLK_setCharSpawnPos(pos, charID)
    if charID == "char_none" then return end
    local currentchars = self:FLK_GetChars()

    for k, v in pairs(currentchars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == charID then
                b["spawnpos"] = pos
            end
        end
    end

    self:FLK_SaveCharData(currentchars)
end

function _PLAYER:FLK_setCharBdg(bdg, charskin, charID)
    if charID == "char_none" then return end
    local currentchars = self:FLK_GetChars()

    for k, v in pairs(currentchars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == charID then
                b["bodygroup"] = bdg
                b["skin"] = charskin
            end
        end
    end

    self:SetSkin(charskin)

    for k, v in pairs(self:GetBodyGroups()) do
        if table.Count(bdg) > 0 then
            for a, b in pairs(bdg) do
                if v["id"] == a then
                    self:SetBodygroup(a, b)
                    break
                else
                    self:SetBodygroup(v["id"], 0)
                end
            end
        else
            self:SetBodygroup(v["id"], 0)
        end
    end

    self:FLK_SaveCharData(currentchars)
end

// Supprime le personnage ID
function _PLAYER:FLK_AdminDelChar(id)
    local currentchars = self:FLK_GetChars()

    for k, v in pairs(currentchars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == id then
                table.remove(currentchars, k)
            end
        end
    end

    self:FLK_SaveCharData(currentchars)
    hook.Call("FLK_charDeleted", nil, self, id)
end

// Sauvegarde les données actuelles du perso avec la table "data"
function _PLAYER:FLK_SaveCharData(data)
    sql.Query( "REPLACE INTO FLK_Characters ( user_id, jsonCharTable ) VALUES ( 'chars_" .. self:SteamID64() .. "', '" .. util.TableToJSON(data) .. "' )" )

    hook.Call("FLK_dataSaved", nil, self, data)
end

// Supprime toute la data du perso (à refaire car on utilise pas le PData ici on est des hommes et on a notre propre base SQL ouai)
function _PLAYER:FLK_RemoveChars()
    self:RemovePData("characters")
end

////////////////////////////////////////////////////////////////////////////////
// CRÉATION DU PERSONNAGE // CRÉATION DU PERSONNAGE // CRÉATION DU PERSONNAGE // 
// CRÉATION DU PERSONNAGE // CRÉATION DU PERSONNAGE // CRÉATION DU PERSONNAGE // 
// CRÉATION DU PERSONNAGE // CRÉATION DU PERSONNAGE // CRÉATION DU PERSONNAGE // 
// CRÉATION DU PERSONNAGE // CRÉATION DU PERSONNAGE // CRÉATION DU PERSONNAGE // 
////////////////////////////////////////////////////////////////////////////////

function _PLAYER:FLK_CreateChar(name, model, job, race, bdg, charskin)
    if table.Count(self:FLK_GetChars()) >= FLK.CONFIG_MAXCHARACTERS then print("Nombre de personnages maximal déjà atteint") return end

    local uniqueCharID = generateUniqueID()

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /// IMPORTANT // IMPORTANT // IMPORTANT // IMPORTANT // IMPORTANT // IMPORTANT // IMPORTANT // IMPORTANT // IMPORTANT /// 
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // ICI IL FAUDRA METTRE TOUTES LES DONNÉES QUI SERONT UTILES DANS LE FUTUR ! Y COMPRIS LE MANA, LA MAGIE, LES STATS... //
    // C'est le SEUL endroit dans tout le character creator qui fera mention et qui utilisera des données d'autres modules //
    // Pour le reste (fonction getCharMana, set les stats etc) on le fera dans les modules correspondant à ce qu'on veut ! //
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    local NewCharData = {
        ["charac"] = { // "charac" obligatoire pour conformer au formattage json
            [uniqueCharID] = {
                // Perso de base
                ["uniqueid"] = uniqueCharID,
                ["name"] = name,
                ["model"] = model,
                ["job"] = job,
                ["money"] = FLK.BASEMONEY,
                ["race"] = race,
                ["bodygroup"] = "none",
                ["skin"] = 0,
                ["spawnpos"] = "none",
                ["lastpos"] = "none",
                ["health"] = "none",
                
                // Magie & Mêlée // Fonction de Get dans le module des compétences
                ["compmagic"] = {
                    ["magic1"] = "none",
                    ["magic2"] = "none"
                },
                ["compmelee"] = {
                    ["daggers"] = {
                        ["first"] = false,
                        ["second"] = false,
                        ["third"] = false,
                        ["fourth"] = false,
                        ["fifth"] = false
                    },
                    ["sword"] = {
                        ["first"] = false,
                        ["second"] = false,
                        ["third"] = false,
                        ["fourth"] = false,
                        ["fifth"] = false
                    },
                    ["spear"] = {
                        ["first"] = false,
                        ["second"] = false,
                        ["third"] = false,
                        ["fourth"] = false,
                        ["fifth"] = false
                    },
                    ["axe"] = {
                        ["first"] = false,
                        ["second"] = false,
                        ["third"] = false,
                        ["fourth"] = false,
                        ["fifth"] = false
                    }
                },

                // Stats // Fonction de Get dans le module de stats
                ["points"] = 0,
                ["level"] = 0,
                ["exp"] = 0,
                ["stats"] = {
                    // Ratio ou addition à utiliser pour le calcul des stats
                    ["physdmg"] = FLK.BASEPHYSDAMAGE,
                    ["magicdmg"] = FLK.BASEMAGICDAMAGE,
                    ["hp"] = FLK.BASEHP,
                    ["resistphys"] = FLK.BASERESISTPHYS,
                    ["resistmagic"] = FLK.BASERESISTMAGIC,
                    ["mana"] = FLK.BASEMANA,
                    ["speed"] = FLK.BASERUNSPEED,
                    ["cdreduc"] = FLK.BASECDREDUC
                },
                
                // Inventaire
                ["inventory"] = {},
                ["linkeditems"] = {},
                ["equipped"] = {
                    ["head"] = "",
                    ["chest"] = "",
                    ["legs"] = "",
                    ["feet"] = "",
                    ["primary"] = "",
                    ["unique"] = "",
                    ["necklace"] = "",
                    ["ring"] = "",
                    ["book"] = "",
                    ["rune"] = ""
                }
            }
        }
    }

    if bdg != nil and table.Count(bdg) > 0 then
        NewCharData["charac"][uniqueCharID]["bodygroup"] = bdg
    end

    if charskin != nil then
        NewCharData["charac"][uniqueCharID]["skin"] = charskin
    end

    local plyCurrentChars = self:FLK_GetChars()

    table.Add(plyCurrentChars, NewCharData)

    local tblBank = {}
    self:FLK_SaveCharBank(tblBank, uniqueCharID)

    self:FLK_SaveCharData(plyCurrentChars)
    self:FLK_changeChar(uniqueCharID)
    hook.Run("FLK_charCreated", self, uniqueCharID, name, job)
end

////////////////////////////////////////////////////////////////////////////////
// CRÉATION DU PERSONNAGE // CRÉATION DU PERSONNAGE // CRÉATION DU PERSONNAGE // 
// CRÉATION DU PERSONNAGE // CRÉATION DU PERSONNAGE // CRÉATION DU PERSONNAGE // 
// CRÉATION DU PERSONNAGE // CRÉATION DU PERSONNAGE // CRÉATION DU PERSONNAGE // 
// CRÉATION DU PERSONNAGE // CRÉATION DU PERSONNAGE // CRÉATION DU PERSONNAGE // 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// MAIN CODE /// MAIN CODE  /// MAIN CODE  /// MAIN CODE  // 
////////////////////////////////////////////////////////////

// On check si le dossier data existe, sinon on créer le dossier
function DataInitialize()
    if sql.TableExists("FLK_UsedCharIDs") then 
        return
    else
        sql.Query("CREATE TABLE FLK_UsedCharIDs( old_id TEXT )")                // Sinon on créé la table
    end

    if sql.TableExists("FLK_Characters") then 
        return
    else
        sql.Query("CREATE TABLE FLK_Characters( user_id TEXT NOT NULL PRIMARY KEY , jsonCharTable TEXT )")             //  Pas besoin de créer une valeure par défaut ici
    end
end

// Initialisation du joueur lors de la connection
function OnFirstSpawn(ply)
    ply:setRPName(ply:SteamName())

    if not ply:FLK_HasDATA() then -- big safeguard en gros
        -- Initialise le fichier data pour les persos du joueurs
        local tblChar = {}
        ply:FLK_SaveCharData(tblChar)

        net.Start("new-player") -- envois l'info clientside que le joueur est nouveau sur le serv
            net.WritePlayer(ply)
        net.Send(ply)
            
        return
    end

    local plyCharsTable = ply:FLK_GetChars()

    net.Start("old-player")
        net.WriteTable(plyCharsTable)
    net.Send(ply)
end

// Génère un ID unique pour le perso
function generateUniqueID()
    local idTable = sql.Query("SELECT * FROM FLK_UsedCharIDs")
    local newid

    if not idTable then
        newid = "char_0"
    else
        newid = "char_"..tostring(table.Count(idTable))
    end
    
    sql.Query("INSERT INTO FLK_UsedCharIDs(old_id) VALUES('"..newid.."')")

    hook.Call("FLK_idGenerated", nil, newid)
    return newid
end

// Save de la position quand le joueur déco
function OnDisconnect(ply)
    if not ply:Alive() then return end

    local discPos = ply:GetPos()
    local charid = ply:FLK_getCurrentChar()
    
    ply:FLK_setCharPos(discPos, charid)
end

// Réinitialise la position du perso quand le joueur meurt (au cas ou déco lorsque mort)
function OnDeath(ply)
    local charid = ply:FLK_getCurrentChar()
    ply:FLK_setCharPos("none", charid)
    ply:FLK_setCharHealth("none", charid)
end

function OpenCharSel(ply)
    local plyCharsTable = ply:FLK_GetChars()
    local binds = ply:FLK_GetBinds()
    
    net.Start("old-player")
        net.WriteTable(plyCharsTable)
        net.WriteInt(binds["OpenCC"], 16)
    net.Send(ply)
end

function OnSpawn(ply)
    --timer.Simple(0.1, function()                                  // DARKRP EDITED : gamemodes/mangarp/gamemode/modules/base/sv_gamemode_functions.lua - line 616-644
        local charID = ply:FLK_getCurrentChar()
        if charID != "char_none" then
            local charMdl = ply:FLK_getCharModel(charID)
            local charBdg = ply:FLK_getCharBdg(charID)
            local charSkin = ply:FLK_getCharSkin(charID)
    
            ply:SetModel(charMdl)

            for bdid, subid in pairs(ply:GetBodyGroups()) do
                if charBdg != "none" then
                    for a, b in pairs(charBdg) do
                        if subid["id"] == a then
                            ply:SetBodygroup(a, b)
                            break
                        else
                            ply:SetBodygroup(subid["id"], 0)
                        end
                    end
                else
                    ply:SetBodygroup(subid["id"], 0)
                end
            end

            if charSkin != nil then
                ply:SetSkin(charSkin)
            end
        end
    --end)                                                          // J'ai modif le darkrp au lieu d'ajouter un vieux timer dégueu (c'est plus opti, ça évite d'appliquer 27 trucs au spawn !)                                   
end

/////////////////////////////////////////////////////////////////////
// CALL DE FONCTIONS /// CALL DE FONCTIONS  /// CALL DE FONCTIONS ///
/////////////////////////////////////////////////////////////////////

DataInitialize()

///////////////////////////////////////////////////////////////////
// HOOKS & NET /// HOOKS & NET  /// HOOKS & NET /// HOOKS & NET ///
///////////////////////////////////////////////////////////////////

net.Receive("np-chara-create", function(len, ply)
    local charName = net.ReadString()
    local charMdl = net.ReadString()
    local charBdg = net.ReadTable()
    local charSkin = net.ReadInt(8)
    local Fact = net.ReadString()

    // Le serveur vérifie lui-même dans la config le job de base pour ne pas trust le client
    for k, v in pairs(FLK.CONFIG_FACTIONSMENU) do
        for a, b in pairs(v) do
            if a == Fact then
                local charJob = b["comm"]
                local charRace = b["race"]
                ply:FLK_CreateChar(charName, charMdl, charJob, charRace, charBdg, charSkin)
                return
            end
        end
    end
end)

net.Receive("selected-char", function(len, ply)
    local pID = net.ReadString()

    ply:FLK_changeChar(pID)
end)

net.Receive("return-charasel", function(len, ply)
    OpenCharSel(ply)
end)

net.Receive("apply-bdg", function(len, ply)
    local charBdg = net.ReadTable()
    local charSkin = net.ReadInt(8)
    local id = ply:FLK_getCurrentChar()

    ply:FLK_setCharBdg(charBdg, charSkin, id)
end)

hook.Add("PlayerSpawn", "CC.OnSpawn", OnSpawn)
hook.Add("PlayerDeath", "CC.OnDeath", OnDeath)
hook.Add("PlayerDisconnected", "CC.OnDisconnect", OnDisconnect)
hook.Add("PlayerInitialSpawn", "CC.OnFirstSpawn", OnFirstSpawn)

hook.Add("PlayerSay", "CC.MenuOpen", function(ply, txt)
    if txt != "/cc" then return end

    OpenCharSel(ply)

    return ""
end)

hook.Add("PlayerButtonDown", "CC.MenuBindOpen", function(ply, btn)
    local binds = ply:FLK_GetBinds()
    if btn != binds["OpenCC"] then return end

    OpenCharSel(ply)
end)

hook.Add("PlayerSay", "CC.BdgOpen", function(ply, txt)
    if txt != "/bd" then return end

    local plyCharsTable = ply:FLK_GetChars()
    
    net.Start("bdg-open")
        net.WriteTable(plyCharsTable)
        net.WriteString(ply:FLK_getCurrentChar())
    net.Send(ply)

    return ""
end)

hook.Add("PlayerButtonDown", "CC.BdgBindOpen", function(ply, btn)
    local binds = ply:FLK_GetBinds()
    if btn != binds["OpenBDG"] then return end

    local plyCharsTable = ply:FLK_GetChars()
    
    net.Start("bdg-open")
        net.WriteTable(plyCharsTable)
        net.WriteString(ply:FLK_getCurrentChar())
        net.WriteInt(binds["OpenBDG"], 16)
    net.Send(ply)
end)

hook.Add("playerCanChangeTeam", "CC.PlyChange", function(ply, tm, fc)
    if not fc then ply:ChatPrint("Petit coquin... Ce job ne t'est pas attribué...") return false, "Not attributed" end
end)

hook.Add("PlayerSay", "CC.DebugDelete", function(ply, txt)
    if txt != "/del" then return end

    sql.Query("DROP TABLE FLK_UsedCharIDs")                                               // Utile pour dev
    sql.Query("DROP TABLE FLK_UsedItemIDs")
    sql.Query("DROP TABLE FLK_GendItemIDs")    
    sql.Query("DROP TABLE FLK_Characters")
    sql.Query("DROP TABLE FLK_PlayerBinds")
    ply:FLK_RemoveChars()
    ply:ChatPrint("Fait")

    return ""
end)