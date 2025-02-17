print(
    [[
    /////////////////////////////////////////////
    /////////// INV SYSTEMS CHARGÉ /////////////
    ////////////// DEV PAR KEPYYY ///////////////
    /////////////////////////////////////////////
    ]]
)

include("flk_config.lua")
include("flk_items.lua")

/////////////////////////////////////////////////////
// Metafunctions // Metafunctions // Metafunctions //
/////////////////////////////////////////////////////

local _PANEL = FindMetaTable("Panel")

// Ces metafunctions servent à attribuer des values persos dans les metatables des panels (inutilisé pour l'instant)
function _PANEL:SetWearValue(val)
    self.wearvalue = val
end

function _PANEL:GetWearValue()
    return self.wearvalue
end

function _PANEL:SetSlot(val)
    self.slot = val
end

function _PANEL:GetSlot()
    return self.slot
end

function _PANEL:SetSlotPnl(pnl)
    self.slotpanel = pnl
end

function _PANEL:GetSlotPnl()
    return self.slotpanel
end

function _PANEL:SetItem(itm)
    self.item = itm
end

function _PANEL:GetItem()
    return self.item
end

function _PANEL:SetItemRef(itmref)
    self.itemref = itmref
end

function _PANEL:GetItemRef()
    return self.itemref
end

function _PANEL:SetItemInfo(itminfo)
    self.itminfo = itminfo
end

function _PANEL:GetItemInfo()
    return self.itminfo
end

function _PANEL:SetPersistence(bool)
    self.stayopen = bool
end

function _PANEL:GetPersistence(bool)
    return self.stayopen
end

function _PANEL:SetRealm(realm)
    self.realm = realm
end

function _PANEL:GetRealm()
    return self.realm
end

//////////////////////////////////////////////////////////////////////
// Pré-fonctions // Pré-fonctions // Pré-fonctions // Pré-fonctions //
//////////////////////////////////////////////////////////////////////

// Ces fonctions permettent de scale l'UI à tous les écrans
function sw(num)
    return ScrW() * num/2560
end

function sh(num)
    return ScrH() * num/1440
end

function sv(w, h)
    return ScrW() * w/2560, ScrH() * h/1440
end

local slotW, slotH = sw(163), sh(163)
local SCROLLTOBANK = nil
local SCROLLTOINV = nil

////////////////////////////////////////////////////////////////////////
// Inventaire // Inventaire // Inventaire // Inventaire // Inventaire //
////////////////////////////////////////////////////////////////////////
// Inventaire // Inventaire // Inventaire // Inventaire // Inventaire //
////////////////////////////////////////////////////////////////////////
// Inventaire // Inventaire // Inventaire // Inventaire // Inventaire //
////////////////////////////////////////////////////////////////////////

// Fonction pour dessiner le panel d'inventaire avec toutes les variables nécessaires en argument
function DrawInv(inventory, invgrid, charInv, charEquipped, charLvl, isBank, bankscroll, invscroll)
    
    // On répète le code suivant pours tous les slots
    for slot = 1, FLK.INVSIZE do
        
        // Créations des slots de l'inventaire (carrés vides)
        local invslot = vgui.Create("DPanel")
        invslot:SetSize(slotW, slotH)
        invslot:SetSlot(slot)
        invslot:SetItem("none")

        -- On créer ensuite la fonction receiver pour recevoir le drag n drop.
        invslot:Receiver("global_item", function(self, panels, dropped)
            if not dropped then return end

            local itm_dropped = panels[1]
            local prev_slot = itm_dropped:GetSlotPnl()
            if prev_slot == self then return end
            
            // D'abord on vérifie que le slot actuel est libre.
            if self:GetItem() != "none" then
                if self:GetItem() == itm_dropped:GetItem() and FLK.ITEMS[itm_dropped:GetItemRef()]["type"] == "resource" then
                    StackItem(inventory, self, prev_slot, itm_dropped, isBank, itm_dropped:GetRealm())
                    if isBank then SCROLLTOBANK = bankscroll:GetVBar():GetScroll() end
                    SCROLLTOINV = invscroll:GetVBar():GetScroll()
                    return
                else
                    return
                end
            end

            if isBank then
                SCROLLTOBANK = bankscroll:GetVBar():GetScroll()
            end
            SCROLLTOINV = invscroll:GetVBar():GetScroll()

            // Puis on envois au serveur la mise à jour
            if itm_dropped:GetRealm() == "bank" then
                net.Start("swap-moved-item")
                    net.WriteInt(prev_slot:GetSlot(), 16)
                    net.WriteInt(self:GetSlot(), 16)
                    net.WriteString(itm_dropped:GetItem())
                    net.WriteString(itm_dropped:GetRealm())
                net.SendToServer()
            elseif itm_dropped:GetRealm() == "inventory" then
                net.Start("inventory-moved-item")
                    net.WriteInt(prev_slot:GetSlot(), 16)
                    net.WriteInt(self:GetSlot(), 16)
                    net.WriteString(itm_dropped:GetItem())
                    net.WriteBool(isBank)
                net.SendToServer()
            end

            timer.Simple(0.1, function() inventory:Close() end)
        end)

        
        // On définis des variables
        -- D'abord les variable définissable
        local itm = charInv[slot]
        
        -- Puis celles indéfinissable sans loop
        local itm_id
        local itm_ref
        local itm_stack
        local itm_linked
        
        /////////////////////////////////////////////
        // Maintenant, on créer le panel de l'item //
        /////////////////////////////////////////////

        if itm != nil then
            
            // On définie les variables via la loop
            for id, itminfo in pairs(itm) do
                itm_id = id
                itm_ref = itminfo["ref"]
                itm_stack = itminfo["stack"]
                itm_linked = itminfo["linked"]
            end

            // Ensuite, on précréer des panels pour plus tards
            local infopnl = vgui.Create("DFrame", inventory)
            infopnl:ShowCloseButton(false)
            infopnl:SetTitle(FLK.ITEMS[itm_ref]["name"])
            infopnl:SetPersistence(false)
            infopnl:Hide()

            
            // On ajoute un panel pour l'item en question
            local itm_panel = vgui.Create("DButton", invslot)
            itm_panel:Dock(FILL)
            itm_panel:SetText("")
            itm_panel.Paint = function(s, w, h)
                surface.SetDrawColor(color_white)
                surface.SetMaterial( Material(FLK.ITEMS[itm_ref]["sprite"]) )
                surface.DrawTexturedRect(0, 0, w, h)
            end
            if FLK.ITEMS[itm_ref]["type"] == "resource" then
                local stacklbl = vgui.Create("DLabel", itm_panel)
                stacklbl:SetPos(sv(10, 140))
                stacklbl:SetText(itm_stack)
            end
            if itm_linked then
                local linkedlbl = vgui.Create("DLabel", itm_panel)
                linkedlbl:SetPos(sv(5, 5))
                linkedlbl:SetText("Item lié")
            end        
            
            CreateInfoPnl(inventory, invslot, itm_panel, infopnl, itm_id, itm_ref, itm_stack, itm_linked, charEquipped, charLvl, isBank)
            -- A ce niveau, l'item dans l'inventaire n'est qu'on bouton. On doit encore ajouter
            -- les fonctionnalités pour intéragir avec l'item dans l'inventaire.
            -- On va commencer par incorporer le drag n drop et des paramètres utiles dans
            -- la metatable du/des panels.

            invslot:SetItem(itm_id)                 -- Insert l'ID de l'item dans le slot
            itm_panel:SetItem(itm_id)               -- Insert l'ID de l'item dans l'item
            itm_panel:SetItemRef(itm_ref)           -- Insert la ref de l'item...
            itm_panel:SetItemInfo(itm)              -- Insert les infos de l'item joueur
            itm_panel:SetSlot(slot)                 -- Insert l'info du slot dans l'item
            itm_panel:SetSlotPnl(invslot)           -- Insert le panel du slot dans l'item
            itm_panel:SetRealm("inventory")         -- Définis si l'item est dans l'inv ou la bank
            itm_panel:Droppable("global_item")
            itm_panel:Droppable(FLK.ITEMS[itm_ref]["type"])

            -- Puis on va ajouter des fonctionnalitées :
            -- Quand on hover
            itm_panel.Think = function(s)
                if s:IsHovered() then
                    if s:GetParent() == nil then return end
                    if dragndrop.IsDragging() then return end
                    local px, py = s:GetParent():GetPos()
    
                    infopnl:SetSize(sw(250), sh(300))
                    infopnl:SetPos(px + sw(180), py - invscroll:GetVBar():GetScroll())
                    infopnl:Show()
                elseif not s:IsHovered() and not infopnl:GetPersistence() then
                    infopnl:Hide()
                end
            end

            -- Pour le clic
            itm_panel.DoClick = function()
                if not infopnl:GetPersistence() then
                    infopnl:SetPersistence(true)
                else
                    infopnl:SetPersistence(false)
                end
            end

            -- Pour le clic droit
            itm_panel.DoRightClick = function()
                if not isBank then
                    if charEquipped[FLK.ITEMS[itm_ref]["type"]] != "" then return end

                    if charLvl < FLK.ITEMS[itm_ref]["reqlvl"] then
                        LocalPlayer():ChatPrint("Vous n'avez pas le niveau requis.")
                        net.Start("close-inv")
                        net.SendToServer()
                        inventory:Close()
                        return
                    end


                    if FLK.ITEMS[itm_ref]["linked"] and not itm_linked then
                        infopnl:Hide()
                        infopnl:SetPersistence(false)
                        
                        local confirm = vgui.Create("DFrame", inventory)
                        confirm:SetSize(sw(500), sh(200))
                        confirm:Center()
                        confirm:SetTitle("Confirmer")
                        confirm:MakePopup()
                        confirm:SetBackgroundBlur(true)
                        
                        local yesbtn = vgui.Create("DButton", confirm)
                        yesbtn:Dock(LEFT)
                        yesbtn:DockMargin(10,10,10,10)
                        yesbtn:SetText("Oui")
                        yesbtn.DoClick = function()
                            EquipItem(itm_id, itm_ref, invslot, charLvl)

                            timer.Simple(0.1, function() inventory:Close() end)
                        end
                    
                        local nobtn = vgui.Create("DButton", confirm)
                        nobtn:Dock(RIGHT)
                        nobtn:DockMargin(10,10,10,10)
                        nobtn:SetText("Non")
                        nobtn.DoClick = function()
                            confirm:Close()
                        end
        
                        return
                    end

                    EquipItem(itm_id, itm_ref, invslot, charLvl)

                    timer.Simple(0.1, function() inventory:Close() end)
                else
                    SCROLLTOBANK = bankscroll:GetVBar():GetScroll()
                    SCROLLTOINV = invscroll:GetVBar():GetScroll()
                    net.Start("move-item-to-bank")
                        net.WriteString(itm_id)
                        net.WriteInt(slot, 16)
                    net.SendToServer()

                    timer.Simple(0.1, function() inventory:Close() end)
                end
            end

            -- Pour le double clic
            itm_panel.DoDoubleClick = function()
                if isBank then return end
                if not FLK.ITEMS[itm_ref]["usable"] then return end

                infopnl:Hide()
                infopnl:SetPersistence(false)
    
                local confirm = vgui.Create("DFrame", inventory)
                confirm:SetSize(sw(500), sh(200))
                confirm:Center()
                confirm:SetTitle("Confirmer")
                confirm:MakePopup()
                confirm:SetBackgroundBlur(true)
    
                local yesbtn = vgui.Create("DButton", confirm)
                yesbtn:Dock(LEFT)
                yesbtn:DockMargin(10,10,10,10)
                yesbtn:SetText("Oui")
                yesbtn.DoClick = function()
                    if not FLK.ITEMS[itm_ref]["usable"] then return end
                    net.Start("use-item")
                        net.WriteString(itm_id)
                        net.WriteInt(itm_panel:GetSlot(), 16)
                    net.SendToServer()
                        
                    net.Start("close-inv")
                    net.SendToServer()
                    inventory:Close()
                end
    
                local nobtn = vgui.Create("DButton", confirm)
                nobtn:Dock(RIGHT)
                nobtn:DockMargin(10,10,10,10)
                nobtn:SetText("Non")
                nobtn.DoClick = function()
                    confirm:Close()
                end
            end

            -- Pour le clic molette
            itm_panel.DoMiddleClick = function()
                if FLK.ITEMS[itm_ref]["type"] != "resource" then return end
                if isBank then SCROLLTOBANK = bankscroll:GetVBar():GetScroll() end
                SCROLLTOINV = invscroll:GetVBar():GetScroll()
                
                SplitItem(itm_id, itm_panel:GetSlot(), isBank)

                timer.Simple(0.1, function() inventory:Close() end)
            end
        end

        // Ajoute l'item au slot d'inventaire
        invgrid:AddItem(invslot)
    end
end

function OpenInv()
    local charid = net.ReadString()
    local chars = net.ReadTable()
    local charInv = net.ReadTable()
    local charEquipped = net.ReadTable()
    local bind = net.ReadInt(16)
    local charMdl
    local charBdg
    local charSkin
    local charLvl

    for ind, char in pairs(chars) do
        for id, charinfo in pairs(char) do
            if id == charid then
                charMdl = char[charid]["model"]
                charBdg = char[charid]["bodygroup"]
                charSkin = char[charid]["skin"]
                charLvl = char[charid]["level"]
            end
        end
    end

    local inventory = vgui.Create("DFrame")
    local rightpartbg = vgui.Create("DPanel", inventory)
    local modelbg = vgui.Create("DPanel", rightpartbg)
    local model = vgui.Create("DModelPanel", modelbg)
    local invpanel = vgui.Create("DPanel", inventory)
    local invscroll = vgui.Create("DScrollPanel", invpanel)
    local invgrid = vgui.Create("DGrid", invscroll)
    local quitbtn = vgui.Create("DButton", inventory)

    // Panel d'inventaire
    inventory:SetSize(ScrW(), ScrH())
    inventory:SetPos(0,0)
    inventory:MakePopup()
    inventory.OnKeyCodePressed = function(s, key)
        if key == bind then
            net.Start("close-inv")
            net.SendToServer()
            inventory:Close()
        end
    end

    local w, h = inventory:GetWide(), inventory:GetTall()

    // Partie droite de l'inventaire
    rightpartbg:SetPos(sw(720), sh(35))
    rightpartbg:SetSize(sw(1630), sh(1395))
    rightpartbg:SetBackgroundColor(Color(255,255,255,100))
    local rw, rh = rightpartbg:GetSize()

    // Model
    modelbg:SetPos(sw(543), sh(83))
    modelbg:SetSize(sw(543), sh(1030))

    model:Dock(FILL)
    model:SetFOV(35)
    model:SetModel(charMdl)
    function model:LayoutEntity(ent) return end
    if charBdg != "none" then
        for id, bd in pairs(charBdg) do
            model:GetEntity():SetBodygroup(id, bd)
        end
    end
    model:GetEntity():SetSkin(charSkin)

    // Panel d'inventaire
    invpanel:SetPos(sw(10), sh(35))
    invpanel:SetSize(sw(700), sh(1395))
    invpanel:SetBackgroundColor(Color(255,255,255,100))
    local invW, invH = invpanel:GetSize()
    
    invscroll:Dock(FILL)
    if SCROLLTOINV != nil then
        invscroll:GetVBar():AnimateTo(SCROLLTOINV, 0, 0, 0)
    end

    // Grille d'inventaire
    invgrid:Dock(FILL)
    invgrid:DockMargin(sw(10), sh(10), sw(10), sh(10))
    invgrid:SetCols(4)
    invgrid:SetColWide(sw(173))
    invgrid:SetRowHeight(sh(173))

    //////////////////////
    // SLOTS INVENTAIRE //
    //////////////////////

    // Créer le slot puis ajoute la valeur perso "WearValue" et ajoute le panel dans une table
    // Pour tous les panels équippables, on vérifie tous les items équippés
    // Si le WearValue du panel correspond à la partie du joueur équippée
    // Alors on ajoute l'item dans le panel
    
    for part, pos in pairs(FLK.EQUIPPABLESLOTS) do
        
        local wearpnl = vgui.Create("DPanel", rightpartbg)
        wearpnl:SetPos(sw(pos["w"]), sh(pos["h"]))
        wearpnl:SetSize(slotW, slotH)
        wearpnl:SetWearValue(part)
        wearpnl:Receiver(part, function(self, panels, dropped)
            if dropped then
                local itm_dropped = panels[1]
                local itm_id = itm_dropped:GetItem()
                local itm_ref = itm_dropped:GetItemRef()
                local itm_info = itm_dropped:GetItemInfo()
                local itm_linked = itm_info[itm_id]["linked"]
                local invslot = itm_dropped:GetSlotPnl()

                if charEquipped[FLK.ITEMS[itm_ref]["type"]] != "" then return end

                if charLvl < FLK.ITEMS[itm_ref]["reqlvl"] then
                    LocalPlayer():ChatPrint("Vous n'avez pas le niveau requis.")
                    net.Start("close-inv")
                    net.SendToServer()
                    inventory:Close()
                    return
                end

                if FLK.ITEMS[itm_ref]["linked"] and not itm_linked then
                    
                    local confirm = vgui.Create("DFrame", inventory)
                    confirm:SetSize(sw(500), sh(200))
                    confirm:Center()
                    confirm:SetTitle("Confirmer")
                    confirm:MakePopup()
                    confirm:SetBackgroundBlur(true)
                    
                    local yesbtn = vgui.Create("DButton", confirm)
                    yesbtn:Dock(LEFT)
                    yesbtn:DockMargin(10,10,10,10)
                    yesbtn:SetText("Oui")
                    yesbtn.DoClick = function()
                        EquipItem(itm_id, itm_ref, invslot, charLvl)
                        SCROLLTOINV = invscroll:GetVBar():GetScroll()

                        timer.Simple(0.1, function() inventory:Close() end)
                    end
                
                    local nobtn = vgui.Create("DButton", confirm)
                    nobtn:Dock(RIGHT)
                    nobtn:DockMargin(10,10,10,10)
                    nobtn:SetText("Non")
                    nobtn.DoClick = function()
                        confirm:Close()
                    end

    
                    return
                end

                EquipItem(itm_id, itm_ref, invslot, charLvl)
                SCROLLTOINV = invscroll:GetVBar():GetScroll()

                timer.Simple(0.1, function() inventory:Close() end)
            end
        end)

        local itm
        for bpart, eq in pairs(charEquipped) do
            if part == bpart and eq != "" then
                local itm_id
                local itm_ref
                local itm_linked

                for id, itminfo in pairs(eq) do
                    itm_id = id
                    itm_ref = itminfo["ref"]
                    itm_linked = itminfo["linked"]
                end
    
                // Ensuite, on précréer des panels pour plus tards
                local infopnl = vgui.Create("DFrame", inventory)
                infopnl:ShowCloseButton(false)
                infopnl:SetTitle(FLK.ITEMS[itm_ref]["name"])
                infopnl:SetPersistence(false)
                infopnl:Hide()
    
                
                // On ajoute un panel pour l'item en question
                local itm_panel = vgui.Create("DButton", wearpnl)
                itm_panel:Dock(FILL)
                itm_panel:SetText("")
                itm_panel:SetItem(itm_id)
                itm_panel:SetItemInfo(eq)
                itm_panel:SetItemRef(itm_ref)

                if itm_linked then
                    local linkedlbl = vgui.Create("DLabel", itm_panel)
                    linkedlbl:SetPos(sv(5, 5))
                    linkedlbl:SetText("Item lié")
                end  
                
                CreateInfoPnl(inventory, invslot, itm_panel, infopnl, itm_id, itm_ref, itm_stack, itm_linked, charEquipped, charLvl, isBank, true)
                
                itm_panel.Paint = function(s, w, h)
                    surface.SetDrawColor(color_white)
                    surface.SetMaterial( Material(FLK.ITEMS[itm_ref]["sprite"]) )
                    surface.DrawTexturedRect(0, 0, w, h)
                end

                itm_panel.Think = function(s)
                    if s:IsHovered() then
                        if s:GetParent() == nil then return end
                        local px, py = s:GetParent():GetPos()
        
                        infopnl:SetSize(sw(250), sh(300))
                        infopnl:SetPos(px + sw(880), py)
                        infopnl:Show()
                    elseif not s:IsHovered() and not infopnl:GetPersistence() then
                        infopnl:Hide()
                    end
                end
    
                -- Pour le clic
                itm_panel.DoClick = function()
                    if not infopnl:GetPersistence() then
                        infopnl:SetPersistence(true)
                    else
                        infopnl:SetPersistence(false)
                    end
                end

                itm_panel.DoRightClick = function()
                    SCROLLTOINV = invscroll:GetVBar():GetScroll()

                    net.Start("unequip-item")
                        net.WriteString(itm_id)
                    net.SendToServer()

                    timer.Simple(0.1, function() inventory:Close() end)
                end
            end
        end
    end


    // On dessine l'inventaire
    DrawInv(inventory, invgrid, charInv, charEquipped, charLvl, false, _, invscroll)
    
    // Bouton pour quitter
    quitbtn:SetPos(sw(2360), sh(35))
    quitbtn:SetSize(sw(190), sh(1395))
    quitbtn:SetText("Fermer")
    quitbtn.DoClick = function()
        net.Start("close-inv")
        net.SendToServer()
        inventory:Close()
    end
end

// Banque
function OpenBank()
    local charid = net.ReadString()
    local charInv = net.ReadTable()
    local charBank = net.ReadTable()

    local bankmenu = vgui.Create("DFrame")
    local inv = vgui.Create("DPanel", bankmenu)
    local invscroll = vgui.Create("DScrollPanel", inv)
    local invgrid = vgui.Create("DGrid", invscroll)
    local bank = vgui.Create("DPanel", bankmenu)
    local bankscroll = vgui.Create("DScrollPanel", bank)
    local bankgrid = vgui.Create("DGrid", bankscroll)

    // Menu de banque
    bankmenu:SetSize(ScrW(), ScrH())
    bankmenu:Center()
    bankmenu:MakePopup()

    // Inventaire à gauche
    inv:SetPos(sv(10,35))
    inv:SetSize(sv(700, 1395))
    inv:SetBackgroundColor(Color(255,255,255,100))

    // Banque à droite
    bank:SetPos(sv(1140, 35))
    bank:SetSize(sv(1410, 1395))
    bank:SetBackgroundColor(Color(255,255,255,100))

    // ScrollPanel pour les deux
    bankscroll:Dock(FILL)
    invscroll:Dock(FILL)
    if SCROLLTOBANK != nil then
        bankscroll:GetVBar():AnimateTo(SCROLLTOBANK, 0, 0, 0)
        SCROLLTOBANK = nil
    end
    if SCROLLTOINV != nil then
        invscroll:GetVBar():AnimateTo(SCROLLTOINV, 0, 0, 0)
        SCROLLTOINV = nil
    end

    // Grille d'inventaire et de banque
    invgrid:Dock(FILL)
    invgrid:DockMargin(sw(10), sh(10), sw(10), sh(10))
    invgrid:SetCols(4)
    invgrid:SetColWide(sw(173))
    invgrid:SetRowHeight(sh(173))

    bankgrid:Dock(FILL)
    bankgrid:DockMargin(sw(10), sh(10), sw(10), sh(10))
    bankgrid:SetCols(8)
    bankgrid:SetColWide(sw(173))
    bankgrid:SetRowHeight(sh(173))

    // On dessine l'inventaire
    DrawInv(bankmenu, invgrid, charInv, charEquipped, charLvl, true, bankscroll, invscroll)

    // On dessine la banque (très similaire à l'inventaire donc pas besoin de commenter)
    for bslot = 1, FLK.BANKSIZE do
        local invslot = vgui.Create("DPanel")
        invslot:SetSize(slotW, slotH)
        invslot:SetSlot(bslot)
        invslot:SetItem("none")

        invslot:Receiver("global_item", function(self, panels, dropped)
            if not dropped then return end

            local itm_dropped = panels[1]
            local prev_slot = itm_dropped:GetSlotPnl()
            if prev_slot == self then return end
            
            // D'abord on vérifie que le slot actuel est libre.
            if self:GetItem() != "none" then
                if self:GetItem() == itm_dropped:GetItem() and FLK.ITEMS[itm_dropped:GetItemRef()]["type"] == "resource" then
                    StackItemBank(bankmenu, self, prev_slot, itm_dropped, itm_dropped:GetRealm())
                    SCROLLTOBANK = bankscroll:GetVBar():GetScroll()
                    SCROLLTOINV = invscroll:GetVBar():GetScroll()
                    return
                else
                    return
                end
            end

            SCROLLTOBANK = bankscroll:GetVBar():GetScroll()
            SCROLLTOINV = invscroll:GetVBar():GetScroll()

            // Puis on envois au serveur la mise à jour
            if itm_dropped:GetRealm() == "bank" then
                net.Start("bank-moved-item")
                    net.WriteInt(prev_slot:GetSlot(), 16)
                    net.WriteInt(self:GetSlot(), 16)
                    net.WriteString(itm_dropped:GetItem())
                net.SendToServer()
            elseif itm_dropped:GetRealm() == "inventory" then
                net.Start("swap-moved-item")
                    net.WriteInt(prev_slot:GetSlot(), 16)
                    net.WriteInt(self:GetSlot(), 16)
                    net.WriteString(itm_dropped:GetItem())
                    net.WriteString(itm_dropped:GetRealm())
                net.SendToServer()
            end

            timer.Simple(0.1, function() bankmenu:Close() end)
        end)
        
        // On définis des variables
        -- D'abord les variable définissable
        local itm = charBank[bslot]
        
        -- Puis celles indéfinissable sans loop
        local itm_id
        local itm_ref
        local itm_stack
        local itm_linked

        /////////////////////////////////////////////
        // Maintenant, on créer le panel de l'item //
        /////////////////////////////////////////////

        if itm != nil then
            
            // On définie les variables via la loop
            for id, itminfo in pairs(itm) do
                itm_id = id
                itm_ref = itminfo["ref"]
                itm_stack = itminfo["stack"]
                itm_linked = itminfo["linked"]
            end

            // Ensuite, on précréer des panels pour plus tards
            local infopnl = vgui.Create("DFrame", bankmenu)
            infopnl:ShowCloseButton(false)
            infopnl:SetTitle(FLK.ITEMS[itm_ref]["name"])
            infopnl:SetPersistence(false)
            infopnl:Hide()

            
            // On ajoute un panel pour l'item en question
            local itm_panel = vgui.Create("DButton", invslot)
            itm_panel:Dock(FILL)
            itm_panel:SetText("")
            itm_panel.Paint = function(s, w, h)
                surface.SetDrawColor(color_white)
                surface.SetMaterial( Material(FLK.ITEMS[itm_ref]["sprite"]) )
                surface.DrawTexturedRect(0, 0, w, h)
            end
            if FLK.ITEMS[itm_ref]["type"] == "resource" then
                local stacklbl = vgui.Create("DLabel", itm_panel)
                stacklbl:SetPos(sv(10, 140))
                stacklbl:SetText(itm_stack)
            end  
            if itm_linked then
                local linkedlbl = vgui.Create("DLabel", itm_panel)
                linkedlbl:SetPos(sv(5, 5))
                linkedlbl:SetText("Item lié")
            end         
            
            CreateInfoPnl(bankmenu, invslot, itm_panel, infopnl, itm_id, itm_ref, itm_stack, itm_linked, charEquipped, charLvl, true)
            -- A ce niveau, l'item dans l'inventaire n'est qu'on bouton. On doit encore ajouter
            -- les fonctionnalités pour intéragir avec l'item dans l'inventaire.
            -- On va commencer par incorporer le drag n drop et des paramètres utiles dans
            -- la metatable du/des panels.

            invslot:SetItem(itm_id)                 -- Insert l'ID de l'item dans le slot
            itm_panel:SetItem(itm_id)               -- Insert l'ID de l'item dans l'item
            itm_panel:SetItemRef(itm_ref)           -- Insert la ref de l'item...
            itm_panel:SetItemInfo(itm)
            itm_panel:SetSlot(bslot)                 -- Insert l'info du slot dans l'item
            itm_panel:SetSlotPnl(invslot)           -- Insert le panel du slot dans l'item
            itm_panel:SetRealm("bank")         -- Définis si l'item est dans l'inv ou la bank
            itm_panel:Droppable("global_item")

            -- Puis on va ajouter des fonctionnalitées :
            -- Quand on hover
            itm_panel.Think = function(s)
                if s:IsHovered() then
                    if s:GetParent() == nil then return end
                    if dragndrop.IsDragging() then return end
                    local px, py = s:GetParent():GetPos()
    
                    infopnl:SetSize(sw(250), sh(300))
                    infopnl:SetPos(px + sw(900), py - bankscroll:GetVBar():GetScroll())
                    infopnl:Show()
                elseif not s:IsHovered() and not infopnl:GetPersistence() then
                    infopnl:Hide()
                end
            end

            -- Pour le clic
            itm_panel.DoClick = function()
                if not infopnl:GetPersistence() then
                    infopnl:SetPersistence(true)
                else
                    infopnl:SetPersistence(false)
                end
            end

            itm_panel.DoRightClick = function()
                SCROLLTOBANK = bankscroll:GetVBar():GetScroll()
                SCROLLTOINV = invscroll:GetVBar():GetScroll()
                net.Start("move-item-to-inv")
                    net.WriteString(itm_id)
                    net.WriteInt(bslot, 16)
                net.SendToServer()

                timer.Simple(0.1, function() bankmenu:Close() end)
            end

            itm_panel.DoMiddleClick = function()
                SCROLLTOBANK = bankscroll:GetVBar():GetScroll()
                SCROLLTOINV = invscroll:GetVBar():GetScroll()
                SplitItemBank(itm_id, itm_panel:GetSlot())

                timer.Simple(0.1, function() bankmenu:Close() end)
            end

        end
        bankgrid:AddItem(invslot)
    end
end

function OpenTradeMenu()
    local players = net.ReadTable()

    local trade = vgui.Create("DFrame")
    trade:SetSize(sv(500,300))
    trade:Center()
    trade:SetDraggable(false)
    trade:SetBackgroundBlur(true)
    trade:ShowCloseButton(false)
    trade:MakePopup()

    local plylist = vgui.Create("DComboBox", trade)
    plylist:Dock(TOP)
    plylist:SetTall(30)
    for _, ply in pairs(players) do
        plylist:AddChoice(ply:Name(), ply)
    end

    local cancel = vgui.Create("DButton", trade)
    cancel:Dock(BOTTOM)
    cancel:SetTall(30)
    cancel:SetText("Annuler")
    cancel.DoClick = function()
        trade:Close()
    end

    local givebtn = vgui.Create("DButton", trade)
    givebtn:Dock(BOTTOM)
    givebtn:SetTall(30)
    givebtn:SetText("Donner")
    givebtn.DoClick = function()
        local _, selply = plylist:GetSelected()
        if not selply then LocalPlayer():ChatPrint("Aucun joueur.") return end

        net.Start("trade-item")
            net.WritePlayer(selply)
        net.SendToServer()

        trade:Close()
    end
end

// Fonctiones utilitaires
function CreateInfoPnl(inventory, invslot, itm_panel, infopnl, itm_id, itm_ref, itm_stack, itm_linked, charEquipped, charLvl, isBank, isEq)

    // On ajoute la description de l'item
    local statdesc = vgui.Create("RichText", infopnl)
    statdesc:Dock(TOP)
    statdesc:DockMargin(0,0,0,10)
    statdesc:SetText(FLK.ITEMS[itm_ref]["description"])
    statdesc:SizeToContents()

    // Pour toutes les stats de l'items, on ajoute un label décrivant la stat
    for stat, change in pairs(FLK.ITEMS[itm_ref]["statChange"]) do
        if change != 0 then
            local statlbl = vgui.Create("DLabel", infopnl)
            statlbl:Dock(TOP)

            // Si la stat est positive, alors on rajoute simplement un "+"
            if change > 0 then
                statlbl:SetText(FLK.STATSNAME[stat].." : +"..change)
            else
                statlbl:SetText(FLK.STATSNAME[stat].." : "..change)
            end
            statlbl:SizeToContents()
        end
    end

    // On créer le bouton pour supprimer
    if not isEq then
        local delbtn = vgui.Create("DButton", infopnl)
        delbtn:Dock(BOTTOM)
        delbtn:SetTall(sh(25))
        delbtn:SetText("Supprimer")
        delbtn.DoClick = function()
            // On cache le panel d'information
            infopnl:Hide()
            infopnl:SetPersistence(false)
    
            // On demande la confirmation pour supprimer l'item
            local confirm = vgui.Create("DFrame", inventory)
            confirm:SetSize(sw(500), sh(200))
            confirm:Center()
            confirm:SetTitle("Confirmer")
            confirm:MakePopup()
            confirm:SetBackgroundBlur(true)
    
            local yesbtn = vgui.Create("DButton", confirm)
            yesbtn:Dock(LEFT)
            yesbtn:DockMargin(10,10,10,10)
            yesbtn:SetText("Oui")
            yesbtn.DoClick = function()
                net.Start("del-item")
                    net.WriteString(itm_id)
                    net.WriteInt(invslot:GetSlot(), 16)
                    net.WriteString(itm_panel:GetRealm())
                    net.WriteBool(isBank)
                net.SendToServer()
    
                timer.Simple(0.1, function() inventory:Close() end)
            end
    
            local nobtn = vgui.Create("DButton", confirm)
            nobtn:Dock(RIGHT)
            nobtn:DockMargin(10,10,10,10)
            nobtn:SetText("Non")
            nobtn.DoClick = function()
                confirm:Close()
            end
        end
        // Si nous ne sommes pas dans le menu de banque alors on ajoute d'autres fonctionnalitées
        if not isBank then
            local givebtn = vgui.Create("DButton", infopnl)
            givebtn:Dock(BOTTOM)
            givebtn:SetTall(sh(25))
            givebtn:SetText("Donner")
            if itm_linked then
                givebtn:SetEnabled(false)
            else
                givebtn:SetEnabled(true)
            end
            givebtn.DoClick = function()
                net.Start("give-item")
                    net.WriteString(itm_id)
                    net.WriteInt(itm_panel:GetSlot(), 16)
                net.SendToServer()

                net.Start("close-inv")
                net.SendToServer()
                inventory:Close()
            end
    
            // Bouton pour équiper
            if FLK.EQUIPPABLE[FLK.ITEMS[itm_ref]["type"]] then
                local eqbtn = vgui.Create("DButton", infopnl)
                eqbtn:Dock(BOTTOM)
                eqbtn:SetTall(sh(25))
                eqbtn:SetText("Équiper (niv. "..FLK.ITEMS[itm_ref]["reqlvl"].." requis)")
        
                // Si on a le niveau requis alors on peut l'équiper
                if charLvl >= FLK.ITEMS[itm_ref]["reqlvl"] then
                    eqbtn:SetEnabled(true)
                else
                    eqbtn:SetEnabled(false)    
                end
                // Equipe l'item
                eqbtn.DoClick = function()

                    if FLK.ITEMS[itm_ref]["linked"] and not itm_linked then
                        infopnl:Hide()
                        infopnl:SetPersistence(false)
                        
                        local confirm = vgui.Create("DFrame", inventory)
                        confirm:SetSize(sw(500), sh(200))
                        confirm:Center()
                        confirm:SetTitle("Confirmer")
                        confirm:MakePopup()
                        confirm:SetBackgroundBlur(true)
                        
                        local yesbtn = vgui.Create("DButton", confirm)
                        yesbtn:Dock(LEFT)
                        yesbtn:DockMargin(10,10,10,10)
                        yesbtn:SetText("Oui")
                        yesbtn.DoClick = function()
                            EquipItem(itm_id, itm_ref, invslot, charLvl)

                            timer.Simple(0.1, function() inventory:Close() end)
                        end
                    
                        local nobtn = vgui.Create("DButton", confirm)
                        nobtn:Dock(RIGHT)
                        nobtn:DockMargin(10,10,10,10)
                        nobtn:SetText("Non")
                        nobtn.DoClick = function()
                            confirm:Close()
                        end
        
                        return
                    end

                    EquipItem(itm_id, itm_ref, invslot, charLvl)

                    timer.Simple(0.1, function() inventory:Close() end)
                end
            end
    
            // Bouton pour utiliser l'item
            if FLK.ITEMS[itm_ref]["usable"] then
                local usebtn = vgui.Create("DButton", infopnl)
                usebtn:Dock(BOTTOM)
                usebtn:SetTall(sh(25))
                usebtn:SetText("Utiliser")
        
                // Utilise l'item avec confirmation
                usebtn.DoClick = function()
                    infopnl:Hide()
                    infopnl:SetPersistence(false)
        
                    local confirm = vgui.Create("DFrame", inventory)
                    confirm:SetSize(sw(500), sh(200))
                    confirm:Center()
                    confirm:SetTitle("Confirmer")
                    confirm:MakePopup()
                    confirm:SetBackgroundBlur(true)
        
                    local yesbtn = vgui.Create("DButton", confirm)
                    yesbtn:Dock(LEFT)
                    yesbtn:DockMargin(10,10,10,10)
                    yesbtn:SetText("Oui")
                    yesbtn.DoClick = function()
                        if not FLK.ITEMS[itm_ref]["usable"] then return end

                        net.Start("use-item")
                            net.WriteString(itm_id)
                            net.WriteInt(itm_panel:GetSlot(), 16)
                        net.SendToServer()

                        net.Start("close-inv")
                        net.SendToServer()
                        inventory:Close()
                    end
        
                    local nobtn = vgui.Create("DButton", confirm)
                    nobtn:Dock(RIGHT)
                    nobtn:DockMargin(10,10,10,10)
                    nobtn:SetText("Non")
                    nobtn.DoClick = function()
                        confirm:Close()
                    end
                end
            end
        end
    else
        local uneq = vgui.Create("DButton", infopnl)
        uneq:Dock(BOTTOM)
        uneq:SetTall(sh(25))
        uneq:SetText("Déséquiper")
        uneq.DoClick = function()
            net.Start("unequip-item")
                net.WriteString(itm_id)
            net.SendToServer()

            timer.Simple(0.1, function() inventory:Close() end)
        end
    end
end

function SplitItem(itm_id, slot, isBank)
    net.Start("split-item")
        net.WriteInt(slot, 16)
        net.WriteString(itm_id)
        net.WriteBool(isBank)
    net.SendToServer()
end

function SplitItemBank(itm_id, slot)
    net.Start("split-item-bank")
        net.WriteInt(slot, 16)
        net.WriteString(itm_id)
    net.SendToServer()
end

function StackItem(inventory, self, prev_slot, itm_dropped, isBank, realm)
    net.Start("stack-item")
        net.WriteInt(prev_slot:GetSlot(), 16)
        net.WriteInt(self:GetSlot(), 16)
        net.WriteString(itm_dropped:GetItem())
        net.WriteBool(isBank)
        net.WriteString(realm)
    net.SendToServer()

    timer.Simple(0.1, function() inventory:Close() end)
end

function StackItemBank(inventory, self, prev_slot, itm_dropped, realm)
    net.Start("stack-item-bank")
        net.WriteInt(prev_slot:GetSlot(), 16)
        net.WriteInt(self:GetSlot(), 16)
        net.WriteString(itm_dropped:GetItem())
        net.WriteString(realm)
    net.SendToServer()

    timer.Simple(0.1, function() inventory:Close() end)
end

function EquipItem(itmid, itmref, invslot, charLvl)
    if FLK.ITEMS[itmref]["type"] == "resource" then return end
    if charLvl < FLK.ITEMS[itmref]["reqlvl"] then return end

    local curslot = invslot:GetSlot()

    net.Start("equip-item")
        net.WriteString(itmid)
        net.WriteInt(curslot, 16)
    net.SendToServer()
end

//

net.Receive("inv-open", OpenInv)
net.Receive("open-bank-inv", OpenBank)
net.Receive("open-trade-menu", OpenTradeMenu)