print(
    [[
    ///////////////////////////////////////////////////
    /////////////// ADMIN SYSTEM CHARGÉ ///////////////
    ///////////////// DEV PAR KEPYYY //////////////////
    ///////////////////////////////////////////////////
    ]]
)

function sw(num)
    return ScrW() * num/2560
end

function sh(num)
    return ScrH() * num/1440
end

function AdminMenu()
    local menu_admin_cc = vgui.Create("DFrame")
    local players_admin_cc = vgui.Create("DComboBox", menu_admin_cc)

    // Derma de base
    menu_admin_cc:SetSize(ScrW()/1.5, ScrH()/1.5)
    menu_admin_cc:Center()
    menu_admin_cc:SetSizable(false)
    menu_admin_cc:MakePopup()

    // Liste des joueurs
    players_admin_cc:SetPos(sw(100), sh(100))
    players_admin_cc:SetSize(sw(400), sh(25))
    players_admin_cc:SetText("Sélectionnez un joueur...")
    for k, v in pairs(player.GetAll()) do
        players_admin_cc:AddChoice(v:SteamName().." - "..v:SteamID64(), v)
    end

    // On call le serveur pour demander la data du joueur sélectionné
    function players_admin_cc:OnSelect(ind, val, data)
        if not data:IsValid() then LocalPlayer():ChatPrint("Joueur invalide") menu_admin_cc:Close() return end
        net.Start("admin-sel-char")
            net.WritePlayer(data)
        net.SendToServer()
    end

    // Le serveur nous répond avec les infos
    net.Receive("admin-sel-ply-charsinfo", function()
        local selPlyChars = net.ReadTable() // les infos des persos du joueur
        local chars_admin_cc = vgui.Create("DComboBox", menu_admin_cc)
        local menuw, menuh = menu_admin_cc:GetWide(), menu_admin_cc:GetTall()

        // Liste des persos
        chars_admin_cc:SetPos(sw(100), sh(150))
        chars_admin_cc:SetSize(sw(400), sh(25))
        chars_admin_cc:SetText("Sélectionnez un personnage...")

        for k, v in pairs(selPlyChars) do // On ajoute les persos dans la liste
            for a, b in pairs(v) do
                chars_admin_cc:AddChoice(b["uniqueid"].." : "..b["name"], b)
            end
        end

        // S'il y a moins de 3 perso dans la liste, on ajoute un bouton pour créer un perso nous même
        if table.Count(selPlyChars) < FLK.CONFIG_MAXCHARACTERS then
            chars_admin_cc:AddChoice("+ - Créer un personnage", "create")
        end
        
        local selcharname_admin_cc = vgui.Create("DTextEntry", menu_admin_cc)
        local selcharmdl_admin_cc = vgui.Create("DTextEntry", menu_admin_cc)
        local selcharjob_admin_cc = vgui.Create("DTextEntry", menu_admin_cc)
        local joblabel_admin_cc = vgui.Create("DLabel", menu_admin_cc)
        local selcharrace_admin_cc = vgui.Create("DComboBox", menu_admin_cc)
        local setcharspawnpos_admin_cc = vgui.Create("DButton", menu_admin_cc)
        local delcharspawnpos_admin_cc = vgui.Create("DButton", menu_admin_cc)
        local setchardata_admin_cc = vgui.Create("DButton", menu_admin_cc)
        local delchardata_admin_cc = vgui.Create("DButton", menu_admin_cc)
        local charmodelbg_admin_cc = vgui.Create("DPanel", menu_admin_cc)
        local charmodel_admin_cc = vgui.Create("DModelPanel", charmodelbg_admin_cc)

        selcharname_admin_cc:SetPos(sw(100), sh(200))
        selcharname_admin_cc:SetSize(sw(400), sh(25))
        selcharname_admin_cc:SetPlaceholderText("Nom...")

        selcharmdl_admin_cc:SetPos(sw(100), sh(250))
        selcharmdl_admin_cc:SetSize(sw(400), sh(25))
        selcharmdl_admin_cc:SetPlaceholderText("Model...")

        // bg pour le model selectionné au centre
        charmodelbg_admin_cc:SetPos(ScrW()/2, sh(100))
        charmodelbg_admin_cc:SetSize(ScrW()/5-sw(100), ScrH()/2)

        // model du perso
        charmodel_admin_cc:Dock(FILL)
        charmodel_admin_cc:SetSize(ScrW()/4-sw(100), ScrH()/2)
        charmodel_admin_cc:SetFOV(40)
        function charmodel_admin_cc:LayoutEntity(ent) return end

        // Nom du job mis
        joblabel_admin_cc:SetPos(sw(100), sh(340))
        joblabel_admin_cc:SetText("Entrez la commande du job voulu.")
        joblabel_admin_cc:SizeToContents()

        selcharjob_admin_cc:SetPos(sw(100), sh(300))
        selcharjob_admin_cc:SetSize(sw(400), sh(25))
        selcharjob_admin_cc:SetPlaceholderText("Job command...")

        selcharrace_admin_cc:SetPos(sw(100), sh(370))
        selcharrace_admin_cc:SetSize(sw(400), sh(25))

        setcharspawnpos_admin_cc:SetPos(sw(100), sh(420))
        setcharspawnpos_admin_cc:SetSize(sw(400), sh(25))
        setcharspawnpos_admin_cc:SetText("Appliquer la position de spawn")
        setcharspawnpos_admin_cc:SetEnabled(false)

        delcharspawnpos_admin_cc:SetPos(sw(100), sh(470))
        delcharspawnpos_admin_cc:SetSize(sw(400), sh(25))
        delcharspawnpos_admin_cc:SetText("Supprimer la position de spawn")
        delcharspawnpos_admin_cc:SetEnabled(false)

        setchardata_admin_cc:SetPos(sw(100), ScrH()/2+sh(25))
        setchardata_admin_cc:SetSize(sw(400), sh(25))
        setchardata_admin_cc:SetText("Veuillez sélectionner une action")
        setchardata_admin_cc:SetEnabled(false)

        // Bouton "supprimer un perso"
        delchardata_admin_cc:SetText("Supprimer")
        delchardata_admin_cc:SetEnabled(false)
        delchardata_admin_cc:SetPos(sw(100), ScrH()/2+sh(75))
        delchardata_admin_cc:SetSize(sw(400), sh(25))

        // Quand on sélectionne une option
        function chars_admin_cc:OnSelect(ind, val, data)
            local selcharlvl_admin_sm = vgui.Create("DNumberWang", menu_admin_cc)
            local setcharlvl_admin_sm = vgui.Create("DButton", menu_admin_cc)
            local resetchar_admin_sm = vgui.Create("DButton", menu_admin_cc)
            local _, selPly = players_admin_cc:GetSelected()
            
            selcharlvl_admin_sm:SetPos(menuw/2.5, sh(300))
            selcharlvl_admin_sm:SetSize(sw(400), sh(25))
            selcharlvl_admin_sm:SetDecimals(0)
            selcharlvl_admin_sm:SetMin(0)
            selcharlvl_admin_sm:SetMax(FLK.MAXLEVEL)
            selcharlvl_admin_sm:SetPlaceholderText("Niveau")
            selcharlvl_admin_sm:SetValue(data["level"])
            
            setcharlvl_admin_sm:SetPos(menuw/2.5, ScrH()/2+sh(25))
            setcharlvl_admin_sm:SetSize(sw(400), sh(25))
            setcharlvl_admin_sm:SetText("Appliquer le niveau")
            setcharlvl_admin_sm.DoClick = function() 
                net.Start("setlvl-admin")
                    net.WritePlayer(selPly)
                    net.WriteTable(data)
                    net.WriteInt(selcharlvl_admin_sm:GetValue(), 16)
                net.SendToServer()
            end
            
            resetchar_admin_sm:SetPos(menuw/2.5, ScrH()/2+sh(75))
            resetchar_admin_sm:SetSize(sw(400), sh(25))
            resetchar_admin_sm:SetText("RESET")
            resetchar_admin_sm.DoClick = function()
                net.Start("resetlvl-admin")
                    net.WritePlayer(selPly)
                    net.WriteTable(data)
                net.SendToServer()
            end

            if data != "create" then
                setcharlvl_admin_sm:SetEnabled(true)
                resetchar_admin_sm:SetEnabled(true)
            else
                setcharlvl_admin_sm:SetEnabled(false)
                resetchar_admin_sm:SetEnabled(false)
            end
            function selcharlvl_admin_sm:OnValueChanged(val)
                if data != "create" then
                    if val <= 0 or val > FLK.MAXLEVEL then
                        setcharlvl_admin_sm:SetEnabled(false)
                    else
                        setcharlvl_admin_sm:SetEnabled(true)
                    end
                end
            end

            // Textentry pour le nom
            if data != "create" then // Si on a pas séléctionné "créer un perso"
                selcharname_admin_cc:SetText(data["name"])
            else
                selcharname_admin_cc:SetText("")
                selcharname_admin_cc:SetPlaceholderText("Nom...")
            end

            // pour le model
            if data != "create" then // Si on a pas séléctionné "créer un perso"
                selcharmdl_admin_cc:SetText(data["model"])
                charmodel_admin_cc:SetModel(selcharmdl_admin_cc:GetText())
            else
                selcharmdl_admin_cc:SetText("")
                selcharmdl_admin_cc:SetPlaceholderText("Model...")
                charmodel_admin_cc:SetModel("")
            end
            if charmodel_admin_cc:GetModel() != nil and data["skin"] != nil then
                charmodel_admin_cc:GetEntity():SetSkin(data["skin"])
            end
            if data["bodygroup"] != "none" and charmodel_admin_cc:GetModel() != nil and data != "create" then
                for k, v in pairs(data["bodygroup"]) do
                    charmodel_admin_cc:GetEntity():SetBodygroup(k, v)
                end
            end

            // dès qu'on change le model, on update le model affiché
            function selcharmdl_admin_cc:OnChange()
                charmodel_admin_cc:SetModel(selcharmdl_admin_cc:GetText())
            end

            // textentry pour le job du perso
            if data != "create" then // Si on a pas séléctionné "créer un perso"
                selcharjob_admin_cc:SetText(data["job"])
            else
                selcharjob_admin_cc:SetText("")
                selcharjob_admin_cc:SetPlaceholderText("Job command...")
            end

            joblabel_admin_cc:SetText("Entrez la commande du job voulu.")
            joblabel_admin_cc:SizeToContents()
            function selcharjob_admin_cc:OnChange()
                local jbtbl, _ = DarkRP.getJobByCommand( selcharjob_admin_cc:GetText() )
                if jbtbl != nil then
                    joblabel_admin_cc:SetText( jbtbl["name"] )
                else
                    joblabel_admin_cc:SetText( "COMMANDE INVALIDE" )
                end
                joblabel_admin_cc:SizeToContents()
            end

            local charrace = data["race"]
            selcharrace_admin_cc:AddChoice(charrace or "unassigned", charrace, true)
            for ind, race in ipairs(FLK.RACES) do
                if charrace != race then
                    selcharrace_admin_cc:AddChoice(race, race, false)
                end 
            end

            // Bouton Appliquer/Créer
            if data != "create" then // Si on a pas séléctionné "créer un perso"
                setchardata_admin_cc:SetText("Appliquer")
                setchardata_admin_cc:SetEnabled(true)
                setcharspawnpos_admin_cc:SetEnabled(true)
                delchardata_admin_cc:SetEnabled(true)
                delcharspawnpos_admin_cc:SetEnabled(true)
            else
                setchardata_admin_cc:SetText("Créer")
                setchardata_admin_cc:SetEnabled(true)
                setcharspawnpos_admin_cc:SetEnabled(false)
                delchardata_admin_cc:SetEnabled(false)
                delcharspawnpos_admin_cc:SetEnabled(false)
            end

            setcharspawnpos_admin_cc.DoClick = function()
                local _, selPly = players_admin_cc:GetSelected()

                net.Start("admin-setspawnpos")
                    net.WritePlayer(selPly)
                    net.WriteString(data["uniqueid"])
                net.SendToServer()
            end

            delcharspawnpos_admin_cc.DoClick = function()
                local _, selPly = players_admin_cc:GetSelected()

                net.Start("admin-delspawnpos")
                    net.WritePlayer(selPly)
                    net.WriteString(data["uniqueid"])
                net.SendToServer()
            end

            // fonction du bouton avec double fonctionnalité (selon si on modifie ou créée un perso)
            setchardata_admin_cc.DoClick = function()
                local jb, _ = DarkRP.getJobByCommand(selcharjob_admin_cc:GetText())
                if jb == nil or jb["name"] == nil or selcharmdl_admin_cc:GetText() == "" or selcharname_admin_cc:GetText() == "" then
                    LocalPlayer():ChatPrint("SAISISSEZ DES DONNÉES VALIDES")
                    return
                end
                        
                local _, selPly = players_admin_cc:GetSelected()
                local _, race = selcharrace_admin_cc:GetSelected()
                        
                if not selPly:IsValid() then LocalPlayer():ChatPrint("Joueur invalide") menu_admin_cc:Close() return end

                if data != "create" then // Si on a pas séléctionné "créer un perso"
                    net.Start("admin-set-new-chardata")
                        net.WritePlayer(selPly)
                        net.WriteString(data["uniqueid"])
                        net.WriteString(selcharname_admin_cc:GetText())
                        net.WriteString(selcharmdl_admin_cc:GetText())
                        net.WriteString(selcharjob_admin_cc:GetText())
                        net.WriteString(race)
                    net.SendToServer()

                    LocalPlayer():ChatPrint("Personnage modifié")
                    
                    menu_admin_cc:Close()
                    return // on return car on a fini ici (safeguard pour éviter un "else" inutile)
                end

                net.Start("admin-chara-create")
                    net.WritePlayer(selPly)
                    net.WriteString(selcharname_admin_cc:GetText())
                    net.WriteString(selcharmdl_admin_cc:GetText())
                    net.WriteString(selcharjob_admin_cc:GetText())
                    net.WriteString(race)
                net.SendToServer()

                LocalPlayer():ChatPrint("Personnage créé")
                menu_admin_cc:Close()
            end

            // Fonction du bouton pour supprimer
            delchardata_admin_cc.DoClick = function()
                local _, selPly = players_admin_cc:GetSelected()
                        
                if not selPly:IsValid() then LocalPlayer():ChatPrint("Joueur invalide") menu_admin_cc:Close() return end
                net.Start("admin-del-chardata") // On envois l'info qu'on veut dégager le perso
                    net.WritePlayer(selPly)
                    net.WriteString(data["uniqueid"])
                net.SendToServer()

                menu_admin_cc:Close()
                LocalPlayer():ChatPrint("Personnage supprimé")
            end
        end
    end)
end

net.Receive("admin-menu", AdminMenu)