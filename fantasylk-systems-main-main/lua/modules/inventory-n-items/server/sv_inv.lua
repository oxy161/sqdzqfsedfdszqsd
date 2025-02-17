print(
    [[
    //////////////////////////////////////////
    /////////// INV SYSTEM CHARGÉ ////////////
    ////////////// DEV PAR KEPYYY ////////////
    //////////////////////////////////////////
    ]]
)

include("flk_config.lua")
include("flk_items.lua")
AddCSLuaFile("flk_config.lua")
AddCSLuaFile("flk_items.lua")

-----------------

// Ajoute les materials
local fl, fd = file.Find("addons/fantasylk-systems-main/materials/items/*.png", "garrysmod")
for k, v in pairs(fl) do
    resource.AddFile("materials/items/"..v)
end

util.AddNetworkString("inv-open")
util.AddNetworkString("inventory-moved-item")
util.AddNetworkString("bank-moved-item")
util.AddNetworkString("swap-moved-item")
util.AddNetworkString("split-item")
util.AddNetworkString("split-item-bank")
util.AddNetworkString("stack-item")
util.AddNetworkString("stack-item-bank")
util.AddNetworkString("move-item-to-inv")
util.AddNetworkString("move-item-to-bank")
util.AddNetworkString("equip-item")
util.AddNetworkString("unequip-item")
util.AddNetworkString("use-item")
util.AddNetworkString("del-item")
util.AddNetworkString("give-item")
util.AddNetworkString("open-trade-menu")
util.AddNetworkString("trade-item")
util.AddNetworkString("close-inv")

/////////////////////////////////////////////////////
// Metafunctions // Metafunctions // Metafunctions //
/////////////////////////////////////////////////////

local _PLAYER = FindMetaTable("Player")

// Permet de give un item à un perso en indiquant la reférence et la quantitée
function _PLAYER:FLK_giveItem(charID, ref, amt)
    // Si le joueur n'a pas de perso alors on ne peut pas give
    if charID == "char_none" then return end

    // Si l'inventaire est plein alors on ne peut pas give
    local currentchars = self:FLK_GetChars()
    local currentinv = self:FLK_getCharInv(charID)

    if table.Count(currentinv) >= FLK.INVSIZE then self:ChatPrint("Votre inventaire est plein.") return end

    // On génère l'item en utilisant la référence et on récup l'ID
    // On récupère les infos (table) de l'item avec l'ID généré
    // On setup une table vide pour intégrer l'item généré
    // On choppe la quantitée voulue, avec "1" par défaut

    local itm_id = generateItem(ref)
    local itm = getItemByID(itm_id)
    
    local amt = amt or 1
    local curamt = self:FLK_getItmAmount(itm_id, charID)
    
    // Si l'item est une resource alors :
    // On récupère la quantitée existante de l'item généré
    // On ajoute la quantitée de l'item à la nouvelle quantitée
    // Sinon :
    // On ajoute l'item unique dans l'inventaire avec une quantitée par défaut de 1
    
    if itm["type"] == "resource" then
        local invslot, found = self:FLK_FindItem(itm_id, charID)
        if found then
            currentinv[invslot] = {
                [itm_id] = {
                    ["ref"] = ref,
                    ["stack"] = curamt + amt,
                    ["linked"] = false
                }
            } 
        else
            local slot = self:FindSlot(charID)
            currentinv[slot] = {
                [itm_id] = {
                    ["ref"] = ref,
                    ["stack"] = curamt + amt,
                    ["linked"] = false
                }
            }
        end
    else
        for i = 1, amt do
            local slot = self:FindSlot(charID)
            local curinv = self:FLK_getCharInv(charID)
            if #curinv >= 32 then return end

            curinv[slot] = {
                [itm_id] = {
                    ["ref"] = ref,
                    ["stack"] = 1,
                    ["linked"] = false
                }
            }

            self:FLK_setCharInv(curinv, charID)
        end
        return
    end

    // On sauvegarde la data
    self:FLK_setCharInv(currentinv, charID)
end

// Permet de récupérer la quantitée d'un item (et donc de vérifier si un item existe)
function _PLAYER:FLK_getItmAmount(id, charID)
    local currentinv = self:FLK_getCharInv(charID)
    local amt

    for slot, itm in pairs(currentinv) do
        if currentinv[slot][id] != nil then
            amt = itm[id]["stack"]
        end
    end

    return amt or 0
end

// Similaire à getItmAmount() mais pour la banque du joueur
function _PLAYER:FLK_getItmAmountInBank(id, charID)
    local currentbank = self:FLK_getCharBank(charID)
    local amt

    for slot, itm in pairs(currentbank) do
        if currentbank[slot] == id then
            amt = itm["stack"]
        end
    end

    return amt or "unique"
end

// Vérifie si le joueur possède une banque
function _PLAYER:FLK_CharHasBankInv(charID)
    local bank = sql.Query(" SELECT jsonBank FROM FLK_CharBanks WHERE char_id = 'bank_"..charID.."' LIMIT 1")

    if bank == nil or bank == false then return false else return true end
end

// Sauvegarde la banque du joueur
function _PLAYER:FLK_SaveCharBank(bank, charID)
    sql.Query( "REPLACE INTO FLK_CharBanks ( char_id, jsonBank ) VALUES ( 'bank_" .. charID .. "', '" .. util.TableToJSON(bank) .. "' )" )
end

function _PLAYER:FLK_FindItem(itmid, charID)
    local currentinv = self:FLK_getCharInv(charID)
    local found = false
    local fslot = "none"

    for slot, item in pairs(currentinv) do
        if currentinv[slot][itmid] != nil then
            found = true
            fslot = slot
        end
    end

    return fslot, found
end

function _PLAYER:FLK_FindItemBank(itmid, charID)
    local currentbank = self:FLK_getCharBank(charID)
    local found = false
    local fslot = "none"

    for slot, item in pairs(currentbank) do
        if currentbank[slot][itmid] != nil then
            found = true
            fslot = slot
        end
    end

    return fslot, found
end

function _PLAYER:FLK_FindItemSpecific(itmid, slot, charID)
    local currentinv = self:FLK_getCharInv(charID)

    if currentinv[slot] != nil then
        if currentinv[slot][itmid] != nil then
            return true
        else
            return false
        end
    else
        return false
    end
end

function _PLAYER:FLK_FindItemSpecificBank(itmid, slot, charID)
    local currentbank = self:FLK_getCharBank(charID)

    if currentbank[slot] != nil then
        if currentbank[slot][itmid] != nil then
            return true
        else
            return false
        end
    else
        return false
    end
end

function _PLAYER:FindSlot(charID)
    local currentinv = self:FLK_getCharInv(charID) 

    for i = 1, FLK.INVSIZE do
        if currentinv[i] == nil then
            return i
        end
    end
end

function _PLAYER:FindSlotBank(charID)
    local currentbank = self:FLK_getCharBank(charID) 

    for i = 1, FLK.BANKSIZE do
        if currentbank[i] == nil then
            return i
        end
    end
end

// GETS

// Récupère l'inventaire du joueur
function _PLAYER:FLK_getCharInv(charID)
    local chars = self:FLK_GetChars()

    for k, v in pairs(chars) do
        if v[charID] != nil then
            return v[charID]["inventory"]
        end
    end
end

// Récupère la banque du joueur
function _PLAYER:FLK_getCharBank(charID)
    local char_id = SQLStr("bank_"..charID)
    local bank = sql.QueryValue(" SELECT jsonBank FROM FLK_CharBanks WHERE char_id = "..char_id.." LIMIT 1")

    if bank == nil then return {} end
    return util.JSONToTable(bank)
end

// Récupère les items équipés du joueurs
function _PLAYER:FLK_getCharEquipped(charID)
    local chars = self:FLK_GetChars()
    local tbl = {}

    for k, v in pairs(chars) do
        if v[charID] != nil then
            return v[charID]["equipped"]
        end
    end
end

// SETS

// REMPLACE l'inventaire du joueur par la table 'inv'
function _PLAYER:FLK_setCharInv(inv, charID)
    if charID == "char_none" then return end
    local currentchars = self:FLK_GetChars()

    for k, v in pairs(currentchars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == charID then
                b["inventory"] = inv
            end
        end
    end

    self:FLK_SaveCharData(currentchars)
end

// Équipe un item via l'identifiant unique dans le slot spécifié
function _PLAYER:FLK_setCharEquipped(slot, itm, charID)
    if charID == "char_none" then return end

    // Si le slot spécifié n'existe pas alors return error
    if not FLK.EQUIPPABLE[slot] then print("ERROR : Slot is not valid.") return end

    local currentchars = self:FLK_GetChars()

    for k, v in pairs(currentchars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == charID then
                b["equipped"][slot] = itm
            end
        end
    end

    self:FLK_SaveCharData(currentchars)
end

//////////////////////////////////////////////////////
// Fonctions // Fonctions // Fonctions // Fonctions //
//////////////////////////////////////////////////////

// Initialise les tables SQL
function InventoryDataInitialize()
    if not sql.TableExists("FLK_UsedItemIDs") then 
        sql.Query("CREATE TABLE FLK_UsedItemIDs( old_id TEXT )")
    end

    if not sql.TableExists("FLK_GendItemIDs") then 
        sql.Query("CREATE TABLE FLK_GendItemIDs( item_id TEXT NOT NULL PRIMARY KEY , item_ref TEXT )")
    end

    if not sql.TableExists("FLK_GendItemIDs") then 
        sql.Query("CREATE TABLE FLK_GendItemIDs( item_id TEXT NOT NULL PRIMARY KEY , item_ref TEXT )")
    end

    if not sql.TableExists("FLK_CharBanks") then 
        sql.Query("CREATE TABLE FLK_CharBanks( char_id TEXT NOT NULL PRIMARY KEY , jsonBank TEXT )")
    end
end

// Permet de générer un item
function generateItem(ref)
    
    // Si l'item n'existe pas, alors on return
    local itm = getItemByRef(ref)
    if itm == nil then print("ERROR : CANNOT GENERATE ITEM ; item == "..tostring(itm)) return end

    // Si l'item est une resource, alors on ne génère pas d'identifié unique
    local itm_id
    if itm["type"] == "resource" then
        itm_id = ref
    else
        itm_id = generateUniqueItemID()
    end

    // On ajoute l'item dans le SQL des items générés
    sql.Query( "REPLACE INTO FLK_GendItemIDs ( item_id, item_ref ) VALUES ( '".. itm_id .. "', '" .. ref .. "' )" )

    // On return l'identifiant de l'Item généré
    return itm_id
end

// Permet de généré un identifiant unique pour les items
function generateUniqueItemID()
    // On récupère la table des identifiants usés
    local idTable = sql.Query("SELECT * FROM FLK_UsedItemIDs")
    local newid

    // Si la table n'existe pas alors 'itm_0'
    if not idTable then
        newid = "itm_0"
    else
        newid = "itm_"..tostring(#idTable)
    end
    
    // On insert l'identifiant dans la table des id usés
    sql.Query("INSERT INTO FLK_UsedItemIDs(old_id) VALUES('"..newid.."')")

    // On call le hook d'item généré
    hook.Call("FLK_idItemGenerated", nil, newid)

    // On return l'id
    return newid
end

// Permet de récupérer la table de l'item via la référence
function getItemByRef(ref)
    return FLK.ITEMS[ref]
end

// Permet de récupérer la table de l'item via l'identifiant
function getItemByID(id)
    local sqlid = SQLStr(id)
    local sqlitm = sql.QueryValue("SELECT item_ref FROM FLK_GendItemIDs WHERE item_id = "..sqlid.." LIMIT 1")
    return FLK.ITEMS[sqlitm]
end

// Permet de récupérer la référence de l'item via l'identifiant
function getRefByID(id)
    local sqlid = SQLStr(id)
    local sqlitm = sql.QueryValue("SELECT item_ref FROM FLK_GendItemIDs WHERE item_id = "..sqlid.." LIMIT 1")
    return sqlitm
end

// Ouverture de l'inventaire
function OpenInventory(ply)
    // On set toutes les variables
    local charID = ply:FLK_getCurrentChar()
    local plyChars = ply:FLK_GetChars()
    local plyCharInv = ply:FLK_getCharInv(charID)
    local plyCharEquipped = ply:FLK_getCharEquipped(charID)
    local binds = ply:FLK_GetBinds()
    
    // On envois tout au client
    net.Start("inv-open")
        net.WriteString(charID)
        net.WriteTable(plyChars)
        net.WriteTable(plyCharInv)
        net.WriteTable(plyCharEquipped)
        net.WriteInt(binds["OpenInv"], 16)
    net.Send(ply)
end

function OpenBank(ply)
    local charID = ply:FLK_getCurrentChar()
    local charInv = ply:FLK_getCharInv(charID)
    local bank = ply:FLK_getCharBank(charID)

    net.Start("open-bank-inv")
        net.WriteString(charID)
        net.WriteTable(charInv)
        net.WriteTable(bank)
    net.Send(ply)
end

------------------------------------
-- Fonctions plus internes & nets --
------------------------------------

// Via drag n drop
function InvMoveItm(len, ply)
    local curslot = net.ReadInt(16)
    local newslot = net.ReadInt(16)
    local itmid = net.ReadString()
    local isBank = net.ReadBool()
    local charID = ply:FLK_getCurrentChar()

    if not ply:FLK_FindItemSpecific(itmid, curslot, charID) then ply:ChatPrint("Erreur : Item introuvable.") return end

    
    local currentinv = ply:FLK_getCharInv(charID)
    local itm = currentinv[curslot]

    currentinv[curslot] = nil
    currentinv[newslot] = itm

    ply:FLK_setCharInv(currentinv, charID)
    if not isBank then
        OpenInventory(ply)
    else
        OpenBank(ply)
    end
end

// Via drag n drop
function BankMoveItm(len, ply)
    local curslot = net.ReadInt(16)
    local newslot = net.ReadInt(16)
    local itmid = net.ReadString()
    local charID = ply:FLK_getCurrentChar()

    if not ply:FLK_FindItemSpecificBank(itmid, curslot, charID) then ply:ChatPrint("Erreur : Item introuvable.") return end

    
    local currentbank = ply:FLK_getCharBank(charID)
    local itm = currentbank[curslot]

    currentbank[curslot] = nil
    currentbank[newslot] = itm

    ply:FLK_SaveCharBank(currentbank, charID)

    OpenBank(ply)
end

// Via drag n drop
function SwapMoveItm(len, ply)
    local curslot = net.ReadInt(16)
    local newslot = net.ReadInt(16)
    local itmid = net.ReadString()
    local realm = net.ReadString()
    local charID = ply:FLK_getCurrentChar()
    
    if realm == "inventory" then
        if not ply:FLK_FindItemSpecific(itmid, curslot, charID) then ply:ChatPrint("Erreur : Item introuvable.") return end
    
        local currentinv = ply:FLK_getCharInv(charID)
        local currentbank = ply:FLK_getCharBank(charID)
        local itm = currentinv[curslot]
    
        currentinv[curslot] = nil
        currentbank[newslot] = itm
    
        ply:FLK_SaveCharBank(currentbank, charID)
        ply:FLK_setCharInv(currentinv, charID)
    elseif realm == "bank" then
        if not ply:FLK_FindItemSpecificBank(itmid, curslot, charID) then ply:ChatPrint("Erreur : Item introuvable.") return end

        local currentinv = ply:FLK_getCharInv(charID)
        local currentbank = ply:FLK_getCharBank(charID)
        local itm = currentbank[curslot]
    
        currentbank[curslot] = nil
        currentinv[newslot] = itm
    
        ply:FLK_SaveCharBank(currentbank, charID)
        ply:FLK_setCharInv(currentinv, charID)
    end

    OpenBank(ply)
end

function SplitItem(len, ply)
    local curslot = net.ReadInt(16)
    local itmid = net.ReadString()
    local isBank = net.ReadBool()
    local charID = ply:FLK_getCurrentChar()
    local newslot = ply:FindSlot(charID)

    if not ply:FLK_FindItemSpecific(itmid, curslot, charID) then ply:ChatPrint("Erreur : Item introuvable.") return end

    local currentinv = ply:FLK_getCharInv(charID)
    local curamt = currentinv[curslot][itmid]["stack"]
    
    local calcamt = math.floor(curamt/2)
    local itm

    if calcamt > 0 then
        itm = {
            [itmid] = {
                ["ref"] = getRefByID(itmid),
                ["stack"] = calcamt,
                ["linked"] = false
            }
        }
    else
        itm = nil
    end
    currentinv[curslot][itmid]["stack"] = curamt - calcamt
    currentinv[newslot] = itm

    ply:FLK_setCharInv(currentinv, charID)

    if not isBank then
        OpenInventory(ply)
    elseif isBank then
        OpenBank(ply)
    end
end

function SplitItemBank(len, ply)
    local curslot = net.ReadInt(16)
    local itmid = net.ReadString()
    local charID = ply:FLK_getCurrentChar()
    local newslot = ply:FindSlotBank(charID)

    if not ply:FLK_FindItemSpecificBank(itmid, curslot, charID) then ply:ChatPrint("Erreur : Item introuvable.") return end

    local currentbank = ply:FLK_getCharBank(charID)
    local curamt = currentbank[curslot][itmid]["stack"]
    
    local calcamt = math.floor(curamt/2)
    local itm

    if calcamt > 0 then
        itm = {
            [itmid] = {
                ["ref"] = getRefByID(itmid),
                ["stack"] = calcamt,
                ["linked"] = false
            }
        }
    else
        itm = nil
    end
    currentbank[curslot][itmid]["stack"] = curamt - calcamt
    currentbank[newslot] = itm

    ply:FLK_SaveCharBank(currentbank, charID)

    OpenBank(ply)
end

function StackItem(len, ply)
    local Aslot = net.ReadInt(16)
    local Bslot = net.ReadInt(16)
    local itmid = net.ReadString()
    local isBank = net.ReadBool()
    local realm = net.ReadString()
    local charID = ply:FLK_getCurrentChar()
    if FLK.ITEMS[getRefByID(itmid)]["type"] != "resource" then return end

    // Permet de stack lors d'un swap
    if realm == "bank" then 
        if not ply:FLK_FindItemSpecificBank(itmid, Aslot, charID) then ply:ChatPrint("Erreur : Item introuvable.") return end
        if not ply:FLK_FindItemSpecific(itmid, Bslot, charID) then ply:ChatPrint("Erreur : Item introuvable.") return end

        local currentbank = ply:FLK_getCharBank(charID)
        local currentinv = ply:FLK_getCharInv(charID)

        local Aitm = currentbank[Aslot]
        local Aamt = Aitm[itmid]["stack"]

        local Bitm = currentinv[Bslot]
        local Bamt = Bitm[itmid]["stack"]

        local calc = Aamt + Bamt

        Bitm[itmid]["stack"] = calc

        currentbank[Aslot] = nil
        currentinv[Bslot][Bitm] = Bitm

        ply:FLK_setCharInv(currentinv, charID)
        ply:FLK_SaveCharBank(currentbank, charID)

        OpenBank(ply) 
        return 
    end

    if not ply:FLK_FindItemSpecific(itmid, Aslot, charID) then ply:ChatPrint("Erreur : Item introuvable.") return end
    if not ply:FLK_FindItemSpecific(itmid, Bslot, charID) then ply:ChatPrint("Erreur : Item introuvable.") return end

    local currentinv = ply:FLK_getCharInv(charID)
    
    local Aitm = currentinv[Aslot]
    local Aamt = Aitm[itmid]["stack"]

    local Bitm = currentinv[Bslot]
    local Bamt = Bitm[itmid]["stack"]

    local calc = Aamt + Bamt

    Bitm[itmid]["stack"] = calc

    currentinv[Aslot] = nil
    currentinv[Bslot][Bitm] = Bitm

    ply:FLK_setCharInv(currentinv, charID)

    if not isBank then
        OpenInventory(ply)
    elseif isBank then
        OpenBank(ply)
    end
end

function StackItemBank(len, ply)
    local Aslot = net.ReadInt(16)
    local Bslot = net.ReadInt(16)
    local itmid = net.ReadString()
    local realm = net.ReadString()
    local charID = ply:FLK_getCurrentChar()
    if FLK.ITEMS[getRefByID(itmid)]["type"] != "resource" then return end

    // Permet de stack lors d'un swap
    if realm == "inventory" then 
        if not ply:FLK_FindItemSpecific(itmid, Aslot, charID) then ply:ChatPrint("Erreur : Item introuvable.") return end
        if not ply:FLK_FindItemSpecificBank(itmid, Bslot, charID) then ply:ChatPrint("Erreur : Item introuvable.") return end

        local currentbank = ply:FLK_getCharBank(charID)
        local currentinv = ply:FLK_getCharInv(charID)

        local Aitm = currentinv[Aslot]
        local Aamt = Aitm[itmid]["stack"]

        local Bitm = currentbank[Bslot]
        local Bamt = Bitm[itmid]["stack"]

        local calc = Aamt + Bamt

        Bitm[itmid]["stack"] = calc

        currentinv[Aslot] = nil
        currentbank[Bslot][Bitm] = Bitm

        ply:FLK_setCharInv(currentinv, charID)
        ply:FLK_SaveCharBank(currentbank, charID)

        OpenBank(ply) 
        return 
    end

    if not ply:FLK_FindItemSpecificBank(itmid, Aslot, charID) then ply:ChatPrint("Erreur : Item introuvable.") return end
    if not ply:FLK_FindItemSpecificBank(itmid, Bslot, charID) then ply:ChatPrint("Erreur : Item introuvable.") return end

    local currentbank = ply:FLK_getCharBank(charID)
    
    local Aitm = currentbank[Aslot]
    local Aamt = Aitm[itmid]["stack"]

    local Bitm = currentbank[Bslot]
    local Bamt = Bitm[itmid]["stack"]

    local calc = Aamt + Bamt

    Bitm[itmid]["stack"] = calc

    currentbank[Aslot] = nil
    currentbank[Bslot][Bitm] = Bitm

    ply:FLK_SaveCharBank(currentbank, charID)

    OpenBank(ply)
end

// Permet d'équipper l'item dans l'inventaire
function EquipItem(len, ply)
    local itmid = net.ReadString()
    local curslot = net.ReadInt(16)
    local charID = ply:FLK_getCurrentChar()
    local currentinv = ply:FLK_getCharInv(charID)
    local itminfo = getItemByID(itmid)
    local itmtype = itminfo["type"]
    local itm = currentinv[curslot]
    
    // On check si l'item existe dans l'inventaire
    if not ply:FLK_FindItemSpecific(itmid, curslot, charID) then ply:ChatPrint("ERREUR : Item non trouvé.") return end
    
    // On check si l'item doit être lié au perso
    // Puis on check si l'item est pas déjà lié
    if itminfo["linked"] then
        if itm != nil and not currentinv[curslot][itmid]["linked"] then
            currentinv[curslot][itmid]["linked"] = true
        end
    end

    // On delete l'item en le mettant 'nil'
    currentinv[curslot] = nil


    // On sauvegarde les data
    ply:FLK_setCharInv(currentinv, charID)
    ply:FLK_setCharEquipped(itmtype, itm, charID)
    ply:FLK_CalculateStats(charID, ply:FLK_getCharStats(charID), false)

    OpenInventory(ply)
end

// Permet de déséquiper l'item
function UnequipItem(len, ply)
    local itmid = net.ReadString()
    local itminfo = getItemByID(itmid)
    local itmtype = itminfo["type"]
    local charID = ply:FLK_getCurrentChar()
    local charEquipped = ply:FLK_getCharEquipped(charID)
    local charInv = ply:FLK_getCharInv(charID)
    local newslot = ply:FindSlot(charID)
    local itm = charEquipped[itmtype]

    if itm == nil then ply:ChatPrint("ERREUR : Item non équippé") return end

    charInv[newslot] = itm

    ply:FLK_setCharInv(charInv, charID)
    ply:FLK_setCharEquipped(itmtype, "", charID)

    OpenInventory(ply)
end

// Permet d'utiliser un item
function UseItem(len, ply)
    local itmid = net.ReadString()
    local curslot = net.ReadInt(16)

    local charID = ply:FLK_getCurrentChar()
    local currentinv = ply:FLK_getCharInv(charID)
    local itminfo = getItemByID(itmid)
    local consumable = itminfo["consumable"]
    local itm = currentinv[curslot]
    
    // On check si l'item existe dans l'inventaire
    if not ply:FLK_FindItemSpecific(itmid, curslot, charID) then ply:ChatPrint("ERREUR : Item non trouvé.") return end

    if consumable then
        currentinv[curslot] = nil
        ply:FLK_setCharInv(currentinv, charID)
    end

    itminfo["onuse"](ply)
end

// Permet de supprimer un item
function DelItem(len, ply)
    local itmid = net.ReadString()
    local curslot = net.ReadInt(16)
    local realm = net.ReadString()
    local isBank = net.ReadBool()

    local charID = ply:FLK_getCurrentChar()
    if realm == "bank" then
        local currentbank = ply:FLK_getCharBank(charID)
        if not ply:FLK_FindItemSpecificBank(itmid, curslot, charID) then ply:ChatPrint("Erreur : Item introuvable.") return end
    
        currentbank[curslot] = nil
    
        ply:FLK_SaveCharBank(currentbank, charID)
    elseif realm == "inventory" then
        local currentinv = ply:FLK_getCharInv(charID)
        if not ply:FLK_FindItemSpecific(itmid, curslot, charID) then ply:ChatPrint("Erreur : Item introuvable.") return end
        
        currentinv[curslot] = nil
        
        ply:FLK_setCharInv(currentinv, charID)
    end
    if isBank then
        OpenBank(ply)
    else
        OpenInventory(ply)
    end
end

// Permet de déplacer la moitié des stacks d'un item de la banque à l'inventaire via clique droit
function MoveToInv(len, ply)
    local itmid = net.ReadString()
    local curslot = net.ReadInt(16)
    local charID = ply:FLK_getCurrentChar()
    local newslot = ply:FindSlot(charID)

    if not ply:FLK_FindItemSpecificBank(itmid, curslot, charID) then ply:ChatPrint("Erreur : Item introuvable.") return end
    local existingslot, found = ply:FLK_FindItem(itmid, charID)

    if found and FLK.RESOURCEITEMS[getRefByID(itmid)] then
        local currentinv = ply:FLK_getCharInv(charID)
        local currentbank = ply:FLK_getCharBank(charID)
        local itmA = currentbank[curslot]
        local curstackA = itmA[itmid]["stack"]
        local itmB = currentinv[existingslot]
        local curstackB = itmB[itmid]["stack"]

        currentbank[curslot] = nil
        currentinv[existingslot][itmid]["stack"] = curstackB + curstackA

        ply:FLK_SaveCharBank(currentbank, charID)
        ply:FLK_setCharInv(currentinv, charID)

        OpenBank(ply)
        return
    end

    local currentinv = ply:FLK_getCharInv(charID)
    local currentbank = ply:FLK_getCharBank(charID)
    local itm = currentbank[curslot]

    currentbank[curslot] = nil
    currentinv[newslot] = itm

    ply:FLK_SaveCharBank(currentbank, charID)
    ply:FLK_setCharInv(currentinv, charID)

    OpenBank(ply)
end

// Permet de déplacer la moitié des stacks d'un item de l'inventaire à la banque via clique droit
function MoveToBank(len, ply)
    local itmid = net.ReadString()
    local curslot = net.ReadInt(16)
    local charID = ply:FLK_getCurrentChar()
    local newslot = ply:FindSlotBank(charID)

    if not ply:FLK_FindItemSpecific(itmid, curslot, charID) then ply:ChatPrint("Erreur : Item introuvable.") return end
    local existingslot, found = ply:FLK_FindItemBank(itmid, charID)

    if found and FLK.RESOURCEITEMS[getRefByID(itmid)] then
        local currentinv = ply:FLK_getCharInv(charID)
        local currentbank = ply:FLK_getCharBank(charID)
        local itmA = currentinv[curslot]
        local curstackA = itmA[itmid]["stack"]
        local itmB = currentbank[existingslot]
        local curstackB = itmB[itmid]["stack"]

        currentinv[curslot] = nil
        currentbank[existingslot][itmid]["stack"] = curstackB + curstackA

        ply:FLK_SaveCharBank(currentbank, charID)
        ply:FLK_setCharInv(currentinv, charID)

        OpenBank(ply)
        return
    end

    local currentinv = ply:FLK_getCharInv(charID)
    local currentbank = ply:FLK_getCharBank(charID)
    local itm = currentinv[curslot]

    currentinv[curslot] = nil
    currentbank[newslot] = itm

    ply:FLK_SaveCharBank(currentbank, charID)
    ply:FLK_setCharInv(currentinv, charID)

    OpenBank(ply)
end

function OpenTradeMenu(len, ply)
    local itmid = net.ReadString()
    local curslot = net.ReadInt(16)
    local charID = ply:FLK_getCurrentChar()
    local currentinv = ply:FLK_getCharInv(charID)
    local swapitm = currentinv[curslot]
    local curstackinv = swapitm[itmid]["stack"]
    local found = ply:FLK_FindItemSpecific(itmid, curslot, charID)

    if not found then ply:ChatPrint("ERREUR : Item non trouvé.") return end

    local nearplys = {}
    local distSqr = 250 * 250

    for _, players in pairs(player.GetAll()) do
        if ply:Alive() and players:Alive() and ply != players and players:IsPlayer() then
            if ply:GetPos():DistToSqr(players:GetPos()) < distSqr then
                table.insert(nearplys, players)
            end
        end
    end

    net.Start("open-trade-menu")
        net.WriteTable(nearplys)
    net.Send(ply)

    net.Receive("trade-item", function(len, ply)
        local selply = net.ReadPlayer()
        local selplycharid = selply:FLK_getCurrentChar()
        local selplyinv = selply:FLK_getCharInv(selplycharid)
        local newslot = selply:FindSlot(selplycharid)
        local _, selplyfound = selply:FLK_FindItem(itmid, selplycharid)

        if selplyfound and getItemByID(itmid)["type"] != "resource" then ply:ChatPrint("ERREUR : Duplication détéctée.") return end

        currentinv[curslot] = nil
        selplyinv[newslot] = swapitm

        ply:FLK_setCharInv(currentinv, charID)
        selply:FLK_setCharInv(selplyinv, selplycharid)

        local itmname = getItemByID(itmid)["name"]

        ply:ChatPrint("Vous avez donné ["..curstackinv.."] "..itmname..".")
        selply:ChatPrint("Vous avez reçu ["..curstackinv.."] "..itmname..".")
    end)
end

// Initialise l'inventaire
InventoryDataInitialize()

// Nets & hooks

net.Receive("inventory-moved-item", InvMoveItm)
net.Receive("bank-moved-item", BankMoveItm)
net.Receive("swap-moved-item", SwapMoveItm)
net.Receive("split-item", SplitItem)
net.Receive("split-item-bank", SplitItemBank)
net.Receive("stack-item", StackItem)
net.Receive("stack-item-bank", StackItemBank)
net.Receive("equip-item", EquipItem)
net.Receive("unequip-item", UnequipItem)
net.Receive("use-item", UseItem)
net.Receive("del-item", DelItem)
net.Receive("move-item-to-inv", MoveToInv)
net.Receive("move-item-to-bank", MoveToBank)
net.Receive("give-item", OpenTradeMenu)
net.Receive("close-inv", function(len, ply)
    timer.Simple(0.1, function()
        ply:SetNWBool("INV_OPEN", false)
    end)
end)

hook.Add("FLK_PlayerChangeChar", "IS.Initiate", CheckBank)

hook.Add("PlayerButtonDown", "IS.InvBindOpen", function(ply, btn)
    local binds = ply:FLK_GetBinds()
    if btn != binds["OpenInv"] then return end
    
    if ply:GetNWBool("INV_OPEN", false) then return end
    ply:SetNWBool("INV_OPEN", true)

    OpenInventory(ply)
end)

hook.Add("PlayerDeath", "IS.LoseItems", function(ply)
    local charID = ply:FLK_getCurrentChar()
    local currentinv = ply:FLK_getCharInv(charID)
    local charEquipped = ply:FLK_getCharEquipped(charID)

    for slot, v in pairs(currentinv) do
        for itmid, itm in pairs(v) do
            if not currentinv[slot][itmid]["linked"] then
                currentinv[slot] = nil
            end
        end
    end

    ply:FLK_setCharInv(currentinv, charID)
    
    for part, v in pairs(charEquipped) do
        if v != "" then
            for itmid, itm in pairs(v) do
                if not charEquipped[part][itmid]["linked"] then
                    ply:FLK_setCharEquipped(part, "", charID)
                end
            end
        end
    end
end)

hook.Add("PlayerSay", "IS.Debug", function(ply, txt)
    if txt != "/give" then return end

    for k, v in pairs(FLK.ITEMS) do
        if v["type"] != "resource" then
            ply:FLK_giveItem(ply:FLK_getCurrentChar() , k, math.random(1, 12))
        end
    end

    --ply:FLK_giveItem(ply:FLK_getCurrentChar() , "item_bois", math.random(3, 8))
    --ply:FLK_giveItem(ply:FLK_getCurrentChar() , "potion_soin", 15)
end)

hook.Add("PlayerSay", "IS.TestDebug", function(ply, txt)
    if txt != "/deb" then return end

    PrintTable(ply:FLK_getCharInv(ply:FLK_getCurrentChar()))

    return ""
end)