print(
    [[
    ////////////////////////////////////////////////////////
    /////////////// CHARACTER CREATOR CHARGÉ ///////////////
    //////////////////// DEV PAR KEPYYY ////////////////////
    ////////////////////////////////////////////////////////
    ]]
)

include("flk_config.lua")

surface.CreateFont( "CC_CHARNAME_50", {
	font = "Arial", -- On Windows/macOS, use the font-name which is shown to you by your operating system Font Viewer. On Linux, use the file name
	extended = false,
	size = 50,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "CC_CHARNAME_35", {
	font = "Arial", -- On Windows/macOS, use the font-name which is shown to you by your operating system Font Viewer. On Linux, use the file name
	extended = false,
	size = 35,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

function sw(num)
    return ScrW() * num/2560
end

function sh(num)
    return ScrH() * num/1440
end

// Menu de sélection de faction
function FactionSelectMenu()
    local factAmt = table.Count(FLK.CONFIG_FACTIONSMENU)

    local menu_newp_cc = vgui.Create("DFrame")
    local factgrid_newp_cc = vgui.Create("DGrid", menu_newp_cc)
    local quitbtn_newp_cc = vgui.Create("DButton", menu_newp_cc)

    // Derma principal
    menu_newp_cc:ShowCloseButton(false)
    menu_newp_cc:SetSize(ScrW(), ScrH())
    menu_newp_cc:Center()
    menu_newp_cc:SetSizable(false)
    menu_newp_cc:SetDraggable(false)
    menu_newp_cc:MakePopup()

    // Bouton "Quitter"
    quitbtn_newp_cc:Dock(BOTTOM)
    quitbtn_newp_cc:DockMargin(sw(10), sh(10), sw(10), sh(10))
    quitbtn_newp_cc:SetSize(ScrW()-sw(20), ScrH()/10)
    quitbtn_newp_cc:SetText("Quitter le serveur")
    quitbtn_newp_cc.DoClick = function()
        LocalPlayer():ConCommand("disconnect")
    end
    
    // Grid de boutons des factions
    factgrid_newp_cc:SetPos(sw(20), sh(50))
    factgrid_newp_cc:SetCols(factAmt)
    factgrid_newp_cc:SetColWide(ScrW() / factAmt - sw(10) )
    factgrid_newp_cc:SetRowHeight(ScrH()-sh(70))

    // Création des boutons sur la grid
    for k, v in pairs(FLK.CONFIG_FACTIONSMENU) do
        for a, b in pairs(v) do
            local factbtn_newp_cc = vgui.Create("DButton", menu_newp_cc)
            factbtn_newp_cc:SetSize(ScrW()/ table.Count(FLK.CONFIG_FACTIONSMENU) - sw(30), ScrH() - sh(230))
            factbtn_newp_cc:SetText(a)

            // Clic sur le bouton de la faction, CALL la fonction pour la page suivante
            factbtn_newp_cc.DoClick = function()
                charaCreaMenu(b["comm"], a, b["race"])
                menu_newp_cc:Close()
            end
            factgrid_newp_cc:AddItem(factbtn_newp_cc)
        end

    end
    
end

// Menu de sélection de faction
function newFactionSelectMenu()
    local factAmt = table.Count(FLK.CONFIG_FACTIONSMENU)

    local menu_newp_cc = vgui.Create("DFrame")
    local factgrid_newp_cc = vgui.Create("DGrid", menu_newp_cc)
    local quitbtn_newp_cc = vgui.Create("DButton", menu_newp_cc)

    // Derma principal
    menu_newp_cc:ShowCloseButton(false)
    menu_newp_cc:SetSize(ScrW(), ScrH())
    menu_newp_cc:Center()
    menu_newp_cc:SetSizable(false)
    menu_newp_cc:SetDraggable(false)
    menu_newp_cc:MakePopup()

    // Bouton "Retour"
    quitbtn_newp_cc:Dock(BOTTOM)
    quitbtn_newp_cc:DockMargin(sw(10), sh(10), sw(10), sh(10))
    quitbtn_newp_cc:SetSize(ScrW()-sw(20), ScrH()/10)
    quitbtn_newp_cc:SetText("Retour")
    quitbtn_newp_cc.DoClick = function()
        timer.Simple(0.1, function()
            menu_newp_cc:Close()
        end)
        net.Start("return-charasel")
        net.SendToServer()
    end
    
    // Grid de boutons des factions
    factgrid_newp_cc:SetPos(sw(20), sh(50))
    factgrid_newp_cc:SetCols(factAmt)
    factgrid_newp_cc:SetColWide(ScrW() / factAmt - sw(10) )
    factgrid_newp_cc:SetRowHeight(ScrH()-sh(70))

    // Création des boutons sur la grid
    for k, v in pairs(FLK.CONFIG_FACTIONSMENU) do
        for a, b in pairs(v) do
            local factbtn_newp_cc = vgui.Create("DButton", menu_newp_cc)
            factbtn_newp_cc:SetSize(ScrW()/ table.Count(FLK.CONFIG_FACTIONSMENU) - sw(30), ScrH() - sh(230))
            factbtn_newp_cc:SetText(a)

            // Clic sur le bouton de la faction, CALL la fonction pour la page suivante
            factbtn_newp_cc.DoClick = function()
                charaCreaMenu(b["comm"], a, b["race"])
                timer.Simple(0.1, function()
                    menu_newp_cc:Close()
                end)
            end
            factgrid_newp_cc:AddItem(factbtn_newp_cc)
        end
    end
end

// Menu de création de perso
function charaCreaMenu(comm, faction, race)
    local tb, _ = DarkRP.getJobByCommand(comm) // On get la table du job DarkRP de la faction de base mise dans la config

    local menu_newp_cc = vgui.Create("DFrame") -- Menu derma de fond

    // Derma de base
    menu_newp_cc:ShowCloseButton(false)
    menu_newp_cc:SetSize(ScrW(), ScrH())
    menu_newp_cc:Center()
    menu_newp_cc:SetSizable(false)
    menu_newp_cc:SetDraggable(false)
    menu_newp_cc:MakePopup()

    // Tous les dermas de créations de perso (nom, grid pour model...)
    local labelname_newp_cc = vgui.Create("DLabel", menu_newp_cc)
    local txtname_newp_cc = vgui.Create("DTextEntry", menu_newp_cc)
    local modelselec_newp_cc = vgui.Create("DGrid", menu_newp_cc)
    local playbtn_newp_cc = vgui.Create("DButton", menu_newp_cc)
    local model_newp_cc = vgui.Create("DModelPanel", menu_newp_cc)
    local chosenmodelbg_newp_cc = vgui.Create("DPanel", menu_newp_cc)
    local chosenmodel_newp_cc = vgui.Create("DModelPanel", menu_newp_cc)
    local backbtn_newp_cc = vgui.Create("DButton", menu_newp_cc)
    local bdpanelbg_newp_cc = vgui.Create("DScrollPanel", menu_newp_cc)

    // Label nom
    labelname_newp_cc:SetPos(sw(10), sh(45))
    labelname_newp_cc:SetFont("CC_CHARNAME_35")
    labelname_newp_cc:SetText("Votre nom")
    labelname_newp_cc:SizeToContents()

    // TextEntry pour le nom
    txtname_newp_cc:SetSize(sw(500), sh(75))
    txtname_newp_cc:SetPos(sw(10),sh(85))
    txtname_newp_cc:SetPlaceholderText("Votre nom...")

    // Panel bodygroup
    bdpanelbg_newp_cc:SetPos(sw(10), sh(190))
    bdpanelbg_newp_cc:SetSize(sw(500), ScrH()-sh(590))

    // Bouton retour
    backbtn_newp_cc:SetPos(sw(10), sh(1030))
    backbtn_newp_cc:SetSize(sw(500), sh(190))
    backbtn_newp_cc:SetText("Retour")
    backbtn_newp_cc.DoClick = function()
        timer.Simple(0.1, function()
            menu_newp_cc:Close()
        end)
        newFactionSelectMenu()
    end
    
    // Background pour le model sélectionné (au centre en gros)
    chosenmodelbg_newp_cc:SetPos(sw(520), sh(45))
    chosenmodelbg_newp_cc:SetBackgroundColor(Color(255,255,255,100))
    chosenmodelbg_newp_cc:SetSize((ScrW()/2 - sw(20)) - sw(510), ScrH() - sh(265))
    
    // Model sélec
    chosenmodel_newp_cc:SetPos(sw(520), sh(35))
    chosenmodel_newp_cc:SetModel(tb["model"][1])
    chosenmodel_newp_cc:SetSize((ScrW()/2 - sw(20)) - sw(510), ScrH() - sh(255))
    function chosenmodel_newp_cc:LayoutEntity(ent) return end
    
    // Grid pour les models
    modelselec_newp_cc:SetPos(ScrW()/2, sh(45))
    modelselec_newp_cc:SetCols(math.floor((ScrW()/2)/sw(110)))
    modelselec_newp_cc:SetColWide(sw(110))
    modelselec_newp_cc:SetRowHeight(sh(110))

    local skinval = 0
    local bdsliderskin_newp_cc = bdpanelbg_newp_cc:Add("DNumSlider")
    bdsliderskin_newp_cc:Dock(TOP)
    bdsliderskin_newp_cc:DockMargin(0,0,0,sw(40))
    bdsliderskin_newp_cc:SetSize(sw(500), sh(20))
    bdsliderskin_newp_cc:SetText("Skins")
    bdsliderskin_newp_cc:SetMin(0)
    bdsliderskin_newp_cc:SetMax(chosenmodel_newp_cc:GetEntity():SkinCount())
    bdsliderskin_newp_cc:SetDecimals(0)
    bdsliderskin_newp_cc:SetValue(0)
    bdsliderskin_newp_cc.OnValueChanged = function(self, value)
        chosenmodel_newp_cc:GetEntity():SetSkin(value)
        skinval = value
    end

    // Bodygroups
    local selBdg = {}
    for k, v in pairs(chosenmodel_newp_cc:GetEntity():GetBodyGroups()) do
        if table.Count(v["submodels"]) > 1 then 
            local bdslider_newp_cc = bdpanelbg_newp_cc:Add("DNumSlider")

            bdslider_newp_cc:Dock(TOP)
            bdslider_newp_cc:DockMargin(0,0,0,sw(40))
            bdslider_newp_cc:SetSize(sw(500), sh(20))
            bdslider_newp_cc:SetText(v["name"])
            bdslider_newp_cc:SetMin(0)
            bdslider_newp_cc:SetMax(table.Count(v["submodels"])-1)
            bdslider_newp_cc:SetDecimals(0)
            bdslider_newp_cc:SetValue(0)
            bdslider_newp_cc.OnValueChanged = function(self, value)
                chosenmodel_newp_cc:GetEntity():SetBodygroup(v["id"], value)
                local temptbl = {
                    [v["id"]] = value
                }
                table.remove(selBdg, v["id"])
                table.insert(selBdg, v["id"], value)
            end    
        end
    end

    // Loop autour des models du job DarkRP
    for k, v in pairs(tb["model"]) do

        // Création des DPanel background & DModelPanel pour les models à selectionner (les models à droites)
        local model_newp_ccbg = vgui.Create("DPanel", menu_newp_cc)
        local model_newp_cc = vgui.Create("DModelPanel", model_newp_ccbg)

        // Customization du BG
        model_newp_ccbg:SetBackgroundColor(Color(255,255,255,100))
        model_newp_ccbg:SetSize(sw(100),sh(100))
        model_newp_ccbg:SetPos(sw(10),sh(10))

        // Models
        model_newp_cc:SetSize(sw(100),sh(100))
        model_newp_cc:SetModel(v)
        function model_newp_cc:LayoutEntity( ent ) return end

        // Clic pour choisir son model qui set le model sur le derma model principal
        model_newp_cc.DoClick = function()
            chosenmodel_newp_cc:SetModel(v)

            bdpanelbg_newp_cc:Clear()

            // on update le slider de skin
            skinval = 0
            local bdsliderskin_newp_cc = bdpanelbg_newp_cc:Add("DNumSlider")
            bdsliderskin_newp_cc:Dock(TOP)
            bdsliderskin_newp_cc:DockMargin(0,0,0,sw(40))
            bdsliderskin_newp_cc:SetSize(sw(500), sh(20))
            bdsliderskin_newp_cc:SetText("Skins")
            bdsliderskin_newp_cc:SetMin(0)
            bdsliderskin_newp_cc:SetMax(chosenmodel_newp_cc:GetEntity():SkinCount())
            bdsliderskin_newp_cc:SetDecimals(0)
            bdsliderskin_newp_cc:SetValue(0)
            bdsliderskin_newp_cc.OnValueChanged = function(self, value)
                chosenmodel_newp_cc:GetEntity():SetSkin(value)
                skinval = value
            end

            // on update les sliders bdg
            selBdg = {}
            for a, b in pairs(chosenmodel_newp_cc:GetEntity():GetBodyGroups()) do
                if table.Count(b["submodels"]) > 1 then 
                    local bdslider_newp_cc = bdpanelbg_newp_cc:Add("DNumSlider")

                    bdslider_newp_cc:Dock(TOP)
                    bdslider_newp_cc:DockMargin(0,0,0,sw(40))
                    bdslider_newp_cc:SetSize(sw(500), sh(20))
                    bdslider_newp_cc:SetText(b["name"])
                    bdslider_newp_cc:SetMin(0)
                    bdslider_newp_cc:SetMax(table.Count(b["submodels"])-1)
                    bdslider_newp_cc:SetDecimals(0)
                    bdslider_newp_cc:SetValue(0)
                    bdslider_newp_cc.OnValueChanged = function(self, value)
                        chosenmodel_newp_cc:GetEntity():SetBodygroup(b["id"], value)
                        local temptbl = {
                            [b["id"]] = value
                        }
                        table.remove(selBdg, b["id"])
                        table.insert(selBdg, b["id"], value)
                    end      
                end
            end
        end
        modelselec_newp_cc:AddItem(model_newp_ccbg) // Ajout des models à selectionner à la grid
    end

    // Bouton "Créer"
    playbtn_newp_cc:SetPos(sw(10), ScrH()-sh(210))
    playbtn_newp_cc:SetSize(ScrW()-sw(20), sh(200))
    playbtn_newp_cc:SetText("Créer")
    playbtn_newp_cc.DoClick = function()
        if txtname_newp_cc:GetText() == "" then return end
        local selMdl, _ = chosenmodel_newp_cc:GetModel()
        menu_newp_cc:Close()
        
        net.Start("np-chara-create") // Net pour dire au serveur quel perso on a créer
            net.WriteString(txtname_newp_cc:GetText())
            net.WriteString(selMdl)
            net.WriteTable(selBdg)
            net.WriteInt(skinval, 8)

            // On envois la FACTION (donc l'index de la table dans le dossier config) pour éviter qu'un petit malin fasse un exploit et change la variable "comm" pour un job haut gradé
            net.WriteString(faction) 
        net.SendToServer()
    end

end

// Menu de sélection de perso
function CharaSelectMenu()
    local Chars = net.ReadTable() // choppe l'info du serv sur tous les perso du joueurs
    local charnum = table.Count(Chars) // compte le nombre de persos
    local bind = net.ReadInt(16)

    // Créations derma basique (base, grid pour les perso, bouton quitter...)
    local menu_oldp_cc = vgui.Create("DFrame")
    local chargrid_oldp_cc = vgui.Create("DGrid", menu_oldp_cc)
    local quitbtn_oldp_cc = vgui.Create("DButton", menu_oldp_cc)
    
    // Setup du derma de base
    menu_oldp_cc:ShowCloseButton(false)
    menu_oldp_cc:SetSize(ScrW(), ScrH())
    menu_oldp_cc:Center()
    menu_oldp_cc:SetSizable(false)
    menu_oldp_cc:SetDraggable(false)
    menu_oldp_cc:MakePopup()
    
    // Setup du grid pour la liste des persos à selectionner
    chargrid_oldp_cc:SetPos(sw(20), sh(45))
    chargrid_oldp_cc:SetCols(FLK.CONFIG_MAXCHARACTERS)
    chargrid_oldp_cc:SetColWide(ScrW()/FLK.CONFIG_MAXCHARACTERS-sw(10))
    chargrid_oldp_cc:SetRowHeight(ScrH()- (ScrH()/14) - sh(130))

    // Bouton quitter
    quitbtn_oldp_cc:Dock(BOTTOM)
    quitbtn_oldp_cc:DockMargin(sw(10),sh(10),sw(10),sh(10))
    quitbtn_oldp_cc:SetSize(ScrW()-sw(20), sh(155))
    quitbtn_oldp_cc:SetText("Quitter le serveur")
    quitbtn_oldp_cc.DoClick = function()
        LocalPlayer():ConCommand("disconnect")
    end

    for k, v in pairs(Chars) do // Loop autour des persos pour ajouter les dermas
        for a, b in pairs(v) do
            local charMdl = b["model"]
            local charBdg = b["bodygroup"]
            local charSkin = b["skin"]
            local charName = b["name"]
            local jobtbl, _ = DarkRP.getJobByCommand(b["job"])
            local charJob = jobtbl["name"]
            local charUniqueID = b["uniqueid"]
    
            local charmdlbg_oldp_cc = vgui.Create("DPanel", menu_oldp_cc)
            local charmdl_oldp_cc = vgui.Create("DModelPanel", charmdlbg_oldp_cc)
            local charname_oldp_cc = vgui.Create("DLabel", charmdlbg_oldp_cc)
            local charbtn_oldp_cc = vgui.Create("DButton", charmdlbg_oldp_cc)
    
            // Background du model du perso
            charmdlbg_oldp_cc:SetBackgroundColor(Color(255,255,255,100))
            charmdlbg_oldp_cc:SetSize(ScrW()/FLK.CONFIG_MAXCHARACTERS-sw(30), ScrH() - sh(130))
    
            // Model du perso
            charmdl_oldp_cc:SetPos(sw(10), sh(35))
            charmdl_oldp_cc:SetSize(ScrW()/FLK.CONFIG_MAXCHARACTERS-sw(20), ScrH() - (ScrH()/2))
            charmdl_oldp_cc:SetModel(charMdl)
            if charBdg != "none" then
                for k, v in pairs(charBdg) do
                    charmdl_oldp_cc:GetEntity():SetBodygroup(k, v)
                end
            end
            charmdl_oldp_cc:GetEntity():SetSkin(charSkin)
            function charmdl_oldp_cc:LayoutEntity( ent ) return end
    
            // Nom & job
            charname_oldp_cc:Dock(BOTTOM)
            charname_oldp_cc:DockMargin(sh(10),sh(10),sw(10),sh(230))
            charname_oldp_cc:SetSize(ScrW()/FLK.CONFIG_MAXCHARACTERS-sw(20), ScrH()/14)
            charname_oldp_cc:SetFont("CC_CHARNAME_50")
            charname_oldp_cc:SetText(charName.."    "..charJob)
    
            // Bouton jouer
            charbtn_oldp_cc:Dock(BOTTOM)
            charbtn_oldp_cc:DockMargin(sw(10), sh(10), sw(10), sh(-230))
            charbtn_oldp_cc:SetSize(ScrW()/FLK.CONFIG_MAXCHARACTERS-sw(40), ScrH()/14)
            charbtn_oldp_cc:SetText("Jouer")
            charbtn_oldp_cc.DoClick = function()
                menu_oldp_cc:Close()

                net.Start("selected-char")
                    net.WriteString(charUniqueID)
                net.SendToServer()
            end
    
            chargrid_oldp_cc:AddItem(charmdlbg_oldp_cc) // On add à la grid
        end
    end

    // Compte si il y a moins de max perso, si oui : il créer un bouton "ajouter" pour créer une personnage
    if charnum < FLK.CONFIG_MAXCHARACTERS then
        local addcharbtn_oldp_cc = vgui.Create("DButton", menu_oldp_cc)

        addcharbtn_oldp_cc:SetSize(ScrW()/FLK.CONFIG_MAXCHARACTERS-sw(20), ScrH() - sh(150))
        addcharbtn_oldp_cc:SetText("Ajouter")
        addcharbtn_oldp_cc.DoClick = function()
            menu_oldp_cc:Close()
            newFactionSelectMenu() // On ramène au menu de selection de faction pour créer une nouveau perso
        end

        chargrid_oldp_cc:AddItem(addcharbtn_oldp_cc) // On add à la grid
    end
end

// Menu bodygroup
function BdgMenu()
    local Chars = net.ReadTable()
    local charID = net.ReadString()
    local bind = net.ReadInt(16)

    local menu_bdg_cc = vgui.Create("DFrame")
    local bdpanel_bdg_cc = vgui.Create("DScrollPanel", menu_bdg_cc)
    local plymodelbg_bdg_cc = vgui.Create("DPanel", menu_bdg_cc)
    local plymodel_bdg_cc = vgui.Create("DModelPanel", menu_bdg_cc)
    local btnsave_bdg_cc = vgui.Create("DButton", menu_bdg_cc)

    menu_bdg_cc:SetSize(ScrW()/3, ScrH()-sh(200))
    menu_bdg_cc:SetPos(sw(100),sh(100))
    menu_bdg_cc:MakePopup()
    local menuw, menuh = menu_bdg_cc:GetWide(), menu_bdg_cc:GetTall()

    bdpanel_bdg_cc:SetPos(10, 35)
    bdpanel_bdg_cc:SetSize(menuw/2, menuh-sh(265))

    plymodelbg_bdg_cc:SetPos(menuw/2 + sw(20), sh(35))
    plymodelbg_bdg_cc:SetSize(menuw/2-sw(30), menuh-sh(45))

    plymodel_bdg_cc:SetPos(menuw/2 + sw(20), sh(35))
    plymodel_bdg_cc:SetSize(menuw/2-sw(30), menuh-sh(45))
    plymodel_bdg_cc:SetFOV(25)
    function plymodel_bdg_cc:LayoutEntity(ent) return end
    for k, v in pairs(Chars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == charID then
                local charMdl = b["model"]
                plymodel_bdg_cc:SetModel(charMdl)
            end
        end
    end

    local skinval = 0
    local bdslider_bdg_cc = bdpanel_bdg_cc:Add("DNumSlider")
    bdslider_bdg_cc:Dock(TOP)
    bdslider_bdg_cc:DockMargin(0,0,0,sw(40))
    bdslider_bdg_cc:SetSize(sw(500), sh(20))
    bdslider_bdg_cc:SetText("Skins")
    bdslider_bdg_cc:SetMin(0)
    bdslider_bdg_cc:SetMax(plymodel_bdg_cc:GetEntity():SkinCount())
    bdslider_bdg_cc:SetDecimals(0)
    bdslider_bdg_cc:SetValue(0)
    bdslider_bdg_cc.OnValueChanged = function(self, value)
        plymodel_bdg_cc:GetEntity():SetSkin(value)
        skinval = value
    end

    local selBdg = {}
    for k, v in pairs(Chars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == charID then
                local modelent = plymodel_bdg_cc:GetEntity()
                for c, d in pairs(modelent:GetBodyGroups()) do
                    if table.Count(d["submodels"]) > 1 then
                        local bdslider_bdg_cc = bdpanel_bdg_cc:Add("DNumSlider")

                        bdslider_bdg_cc:Dock(TOP)
                        bdslider_bdg_cc:DockMargin(0,0,0,sw(40))
                        bdslider_bdg_cc:SetSize(sw(500), sh(20))
                        bdslider_bdg_cc:SetText(d["name"])
                        bdslider_bdg_cc:SetMin(0)
                        bdslider_bdg_cc:SetMax(table.Count(d["submodels"])-1)
                        bdslider_bdg_cc:SetDecimals(0)
                        bdslider_bdg_cc:SetValue(0)
                        bdslider_bdg_cc.OnValueChanged = function(self, value)
                            plymodel_bdg_cc:GetEntity():SetBodygroup(d["id"], value)
                            local temptbl = {
                                [d["id"]] = value
                            }
                            table.remove(selBdg, d["id"])
                            table.insert(selBdg, d["id"], value)
                        end
                    end
                end
            end
        end
    end

    btnsave_bdg_cc:SetPos(sw(10), menuh-sh(210))
    btnsave_bdg_cc:SetSize(menuw/2, sh(200))
    btnsave_bdg_cc:SetText("Appliquer")
    btnsave_bdg_cc.DoClick = function()
        net.Start("apply-bdg")
            net.WriteTable(selBdg)
            net.WriteInt(skinval, 8)
        net.SendToServer()
    end

end
    
    

net.Receive("bdg-open", BdgMenu)
net.Receive("new-player", FactionSelectMenu)
net.Receive("old-player", CharaSelectMenu)