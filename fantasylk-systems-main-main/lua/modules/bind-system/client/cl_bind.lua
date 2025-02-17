print(
    [[
    /////////////////////////////////////////////
    /////////// BIND SYSTEMS CHARGÉ /////////////
    ////////////// DEV PAR KEPYYY ///////////////
    /////////////////////////////////////////////
    ]]
)

include("flk_config.lua")

function BindOpenMenu()
    local binds = net.ReadTable()

    local menu_bind = vgui.Create("DFrame")
    local scroll_bind = vgui.Create("DScrollPanel", menu_bind)

    menu_bind:SetSize(ScrW()/4, ScrH()/2)
    menu_bind:Center()
    menu_bind:MakePopup()
    local w, h = menu_bind:GetWide(), menu_bind:GetTall()

    scroll_bind:SetPos(10,35)
    scroll_bind:SetSize(w-20, h-45)

    // On met manuellement les Add pour avoir l'ordre voulu

    /////////////////////////////////////////////////////////
    local opencc_bind_panel = scroll_bind:Add("DPanel")
    local opencc_bind_label = vgui.Create("DLabel", opencc_bind_panel)
    local opencc_bind_btn = vgui.Create("DBinder", opencc_bind_panel)

    opencc_bind_panel:Dock(TOP)
    opencc_bind_panel:DockMargin(10,10,10,0)
    opencc_bind_panel:SetSize(0, 100)

    opencc_bind_label:Dock(LEFT)
    opencc_bind_label:DockMargin(10, 0,0,0)
    opencc_bind_label:SetColor(color_black)
    opencc_bind_label:SetText(FLK.DEFAULTBINDSNAME["OpenCC"])
    opencc_bind_label:SizeToContents()

    opencc_bind_btn:Dock(RIGHT)
    opencc_bind_btn:DockMargin(10,10,10,10)
    opencc_bind_btn:SetValue(binds["OpenCC"])
    
    function opencc_bind_btn:OnChange(num)
        binds["OpenCC"] = num

        net.Start("new-bind")
            net.WriteTable(binds)
        net.SendToServer()
    end
    /////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////
    local stats_bind_panel = scroll_bind:Add("DPanel")
    local stats_bind_label = vgui.Create("DLabel", stats_bind_panel)
    local stats_bind_btn = vgui.Create("DBinder", stats_bind_panel)

    stats_bind_panel:Dock(TOP)
    stats_bind_panel:DockMargin(10,10,10,0)
    stats_bind_panel:SetSize(0, 100)

    stats_bind_label:Dock(LEFT)
    stats_bind_label:DockMargin(10, 0,0,0)
    stats_bind_label:SetColor(color_black)
    stats_bind_label:SetText(FLK.DEFAULTBINDSNAME["OpenStats"])
    stats_bind_label:SizeToContents()

    stats_bind_btn:Dock(RIGHT)
    stats_bind_btn:DockMargin(10,10,10,10)
    stats_bind_btn:SetValue(binds["OpenStats"])
    
    function stats_bind_btn:OnChange(num)
        binds["OpenStats"] = num

        net.Start("new-bind")
            net.WriteTable(binds)
        net.SendToServer()
    end
    /////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////
    local inv_bind_panel = scroll_bind:Add("DPanel")
    local inv_bind_label = vgui.Create("DLabel", inv_bind_panel)
    local inv_bind_btn = vgui.Create("DBinder", inv_bind_panel)

    inv_bind_panel:Dock(TOP)
    inv_bind_panel:DockMargin(10,10,10,0)
    inv_bind_panel:SetSize(0, 100)

    inv_bind_label:Dock(LEFT)
    inv_bind_label:DockMargin(10, 0,0,0)
    inv_bind_label:SetColor(color_black)
    inv_bind_label:SetText(FLK.DEFAULTBINDSNAME["OpenInv"])
    inv_bind_label:SizeToContents()

    inv_bind_btn:Dock(RIGHT)
    inv_bind_btn:DockMargin(10,10,10,10)
    inv_bind_btn:SetValue(binds["OpenInv"])
    
    function inv_bind_btn:OnChange(num)
        binds["OpenInv"] = num

        net.Start("new-bind")
            net.WriteTable(binds)
        net.SendToServer()
    end
    /////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////
    local comp_bind_panel = scroll_bind:Add("DPanel")
    local comp_bind_label = vgui.Create("DLabel", comp_bind_panel)
    local comp_bind_btn = vgui.Create("DBinder", comp_bind_panel)

    comp_bind_panel:Dock(TOP)
    comp_bind_panel:DockMargin(10,10,10,0)
    comp_bind_panel:SetSize(0, 100)

    comp_bind_label:Dock(LEFT)
    comp_bind_label:DockMargin(10, 0,0,0)
    comp_bind_label:SetColor(color_black)
    comp_bind_label:SetText(FLK.DEFAULTBINDSNAME["OpenComp"])
    comp_bind_label:SizeToContents()

    comp_bind_btn:Dock(RIGHT)
    comp_bind_btn:DockMargin(10,10,10,10)
    comp_bind_btn:SetValue(binds["OpenComp"])
    
    function comp_bind_btn:OnChange(num)
        binds["OpenComp"] = num

        net.Start("new-bind")
            net.WriteTable(binds)
        net.SendToServer()
    end
    /////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////
    local bdg_bind_panel = scroll_bind:Add("DPanel")
    local bdg_bind_label = vgui.Create("DLabel", bdg_bind_panel)
    local bdg_bind_btn = vgui.Create("DBinder", bdg_bind_panel)

    bdg_bind_panel:Dock(TOP)
    bdg_bind_panel:DockMargin(10,10,10,0)
    bdg_bind_panel:SetSize(0, 100)

    bdg_bind_label:Dock(LEFT)
    bdg_bind_label:DockMargin(10, 0,0,0)
    bdg_bind_label:SetColor(color_black)
    bdg_bind_label:SetText(FLK.DEFAULTBINDSNAME["OpenBDG"])
    bdg_bind_label:SizeToContents()

    bdg_bind_btn:Dock(RIGHT)
    bdg_bind_btn:DockMargin(10,10,10,10)
    bdg_bind_btn:SetValue(binds["OpenBDG"])
    
    function bdg_bind_btn:OnChange(num)
        binds["OpenBDG"] = num

        net.Start("new-bind")
            net.WriteTable(binds)
        net.SendToServer()
    end
    /////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////
    local tgmm_bind_panel = scroll_bind:Add("DPanel")
    local tgmm_bind_label = vgui.Create("DLabel", tgmm_bind_panel)
    local tgmm_bind_btn = vgui.Create("DBinder", tgmm_bind_panel)

    tgmm_bind_panel:Dock(TOP)
    tgmm_bind_panel:DockMargin(10,10,10,0)
    tgmm_bind_panel:SetSize(0, 100)

    tgmm_bind_label:Dock(LEFT)
    tgmm_bind_label:DockMargin(10, 0,0,0)
    tgmm_bind_label:SetColor(color_black)
    tgmm_bind_label:SetText(FLK.DEFAULTBINDSNAME["ToggleMeleeMagic"])
    tgmm_bind_label:SizeToContents()

    tgmm_bind_btn:Dock(RIGHT)
    tgmm_bind_btn:DockMargin(10,10,10,10)
    tgmm_bind_btn:SetValue(binds["ToggleMeleeMagic"])
    
    function tgmm_bind_btn:OnChange(num)
        binds["ToggleMeleeMagic"] = num

        net.Start("new-bind")
            net.WriteTable(binds)
        net.SendToServer()
    end
    /////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////
    local tgsm_bind_panel = scroll_bind:Add("DPanel")
    local tgsm_bind_label = vgui.Create("DLabel", tgsm_bind_panel)
    local tgsm_bind_btn = vgui.Create("DBinder", tgsm_bind_panel)

    tgsm_bind_panel:Dock(TOP)
    tgsm_bind_panel:DockMargin(10,10,10,0)
    tgsm_bind_panel:SetSize(0, 100)

    tgsm_bind_label:Dock(LEFT)
    tgsm_bind_label:DockMargin(10, 0,0,0)
    tgsm_bind_label:SetColor(color_black)
    tgsm_bind_label:SetText(FLK.DEFAULTBINDSNAME["ToggleSpeedMode"])
    tgsm_bind_label:SizeToContents()

    tgsm_bind_btn:Dock(RIGHT)
    tgsm_bind_btn:DockMargin(10,10,10,10)
    tgsm_bind_btn:SetValue(binds["ToggleSpeedMode"])
    
    function tgsm_bind_btn:OnChange(num)
        binds["ToggleSpeedMode"] = num

        net.Start("new-bind")
            net.WriteTable(binds)
        net.SendToServer()
    end
    /////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////
    local firsts_bind_panel = scroll_bind:Add("DPanel")
    local firsts_bind_label = vgui.Create("DLabel", firsts_bind_panel)
    local firsts_bind_btn = vgui.Create("DBinder", firsts_bind_panel)

    firsts_bind_panel:Dock(TOP)
    firsts_bind_panel:DockMargin(10,10,10,0)
    firsts_bind_panel:SetSize(0, 100)

    firsts_bind_label:Dock(LEFT)
    firsts_bind_label:DockMargin(10, 0,0,0)
    firsts_bind_label:SetColor(color_black)
    firsts_bind_label:SetText(FLK.DEFAULTBINDSNAME["FirstSpell"])
    firsts_bind_label:SizeToContents()

    firsts_bind_btn:Dock(RIGHT)
    firsts_bind_btn:DockMargin(10,10,10,10)
    firsts_bind_btn:SetValue(binds["FirstSpell"])
    
    function firsts_bind_btn:OnChange(num)
        binds["FirstSpell"] = num

        net.Start("new-bind")
            net.WriteTable(binds)
        net.SendToServer()
    end
    /////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////
    local secs_bind_panel = scroll_bind:Add("DPanel")
    local secs_bind_label = vgui.Create("DLabel", secs_bind_panel)
    local secs_bind_btn = vgui.Create("DBinder", secs_bind_panel)

    secs_bind_panel:Dock(TOP)
    secs_bind_panel:DockMargin(10,10,10,0)
    secs_bind_panel:SetSize(0, 100)

    secs_bind_label:Dock(LEFT)
    secs_bind_label:DockMargin(10, 0,0,0)
    secs_bind_label:SetColor(color_black)
    secs_bind_label:SetText(FLK.DEFAULTBINDSNAME["SecondSpell"])
    secs_bind_label:SizeToContents()

    secs_bind_btn:Dock(RIGHT)
    secs_bind_btn:DockMargin(10,10,10,10)
    secs_bind_btn:SetValue(binds["SecondSpell"])
    
    function secs_bind_btn:OnChange(num)
        binds["SecondSpell"] = num

        net.Start("new-bind")
            net.WriteTable(binds)
        net.SendToServer()
    end
    /////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////
    local thrs_bind_panel = scroll_bind:Add("DPanel")
    local thrs_bind_label = vgui.Create("DLabel", thrs_bind_panel)
    local thrs_bind_btn = vgui.Create("DBinder", thrs_bind_panel)

    thrs_bind_panel:Dock(TOP)
    thrs_bind_panel:DockMargin(10,10,10,0)
    thrs_bind_panel:SetSize(0, 100)

    thrs_bind_label:Dock(LEFT)
    thrs_bind_label:DockMargin(10, 0,0,0)
    thrs_bind_label:SetColor(color_black)
    thrs_bind_label:SetText(FLK.DEFAULTBINDSNAME["ThirdSpell"])
    thrs_bind_label:SizeToContents()

    thrs_bind_btn:Dock(RIGHT)
    thrs_bind_btn:DockMargin(10,10,10,10)
    thrs_bind_btn:SetValue(binds["ThirdSpell"])
    
    function thrs_bind_btn:OnChange(num)
        binds["ThirdSpell"] = num

        net.Start("new-bind")
            net.WriteTable(binds)
        net.SendToServer()
    end
    /////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////
    local frths_bind_panel = scroll_bind:Add("DPanel")
    local frths_bind_label = vgui.Create("DLabel", frths_bind_panel)
    local frths_bind_btn = vgui.Create("DBinder", frths_bind_panel)

    frths_bind_panel:Dock(TOP)
    frths_bind_panel:DockMargin(10,10,10,0)
    frths_bind_panel:SetSize(0, 100)

    frths_bind_label:Dock(LEFT)
    frths_bind_label:DockMargin(10, 0,0,0)
    frths_bind_label:SetColor(color_black)
    frths_bind_label:SetText(FLK.DEFAULTBINDSNAME["FourthSpell"])
    frths_bind_label:SizeToContents()

    frths_bind_btn:Dock(RIGHT)
    frths_bind_btn:DockMargin(10,10,10,10)
    frths_bind_btn:SetValue(binds["FourthSpell"])
    
    function frths_bind_btn:OnChange(num)
        binds["FourthSpell"] = num

        net.Start("new-bind")
            net.WriteTable(binds)
        net.SendToServer()
    end
    /////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////
    local ffths_bind_panel = scroll_bind:Add("DPanel")
    local ffths_bind_label = vgui.Create("DLabel", ffths_bind_panel)
    local ffths_bind_btn = vgui.Create("DBinder", ffths_bind_panel)

    ffths_bind_panel:Dock(TOP)
    ffths_bind_panel:DockMargin(10,10,10,0)
    ffths_bind_panel:SetSize(0, 100)

    ffths_bind_label:Dock(LEFT)
    ffths_bind_label:DockMargin(10, 0,0,0)
    ffths_bind_label:SetColor(color_black)
    ffths_bind_label:SetText(FLK.DEFAULTBINDSNAME["FifthSpell"])
    ffths_bind_label:SizeToContents()

    ffths_bind_btn:Dock(RIGHT)
    ffths_bind_btn:DockMargin(10,10,10,10)
    ffths_bind_btn:SetValue(binds["FifthSpell"])
    
    function ffths_bind_btn:OnChange(num)
        binds["FifthSpell"] = num

        net.Start("new-bind")
            net.WriteTable(binds)
        net.SendToServer()
    end
    /////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////
    local adm_bind_panel = scroll_bind:Add("DPanel")
    local adm_bind_label = vgui.Create("DLabel", adm_bind_panel)
    local adm_bind_btn = vgui.Create("DBinder", adm_bind_panel)

    adm_bind_panel:Dock(TOP)
    adm_bind_panel:DockMargin(10,10,10,0)
    adm_bind_panel:SetSize(0, 100)

    adm_bind_label:Dock(LEFT)
    adm_bind_label:DockMargin(10, 0,0,0)
    adm_bind_label:SetColor(color_black)
    adm_bind_label:SetText(FLK.DEFAULTBINDSNAME["AdminMenu"])
    adm_bind_label:SizeToContents()

    adm_bind_btn:Dock(RIGHT)
    adm_bind_btn:DockMargin(10,10,10,10)
    adm_bind_btn:SetValue(binds["AdminMenu"])
    
    function adm_bind_btn:OnChange(num)
        binds["AdminMenu"] = num

        net.Start("new-bind")
            net.WriteTable(binds)
        net.SendToServer()
    end
    /////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////
    local resetbtn_bind = scroll_bind:Add("DButton")

    resetbtn_bind:Dock(TOP)
    resetbtn_bind:DockMargin(10,10,10,10)
    resetbtn_bind:SetText("Remettre tout par défaut")
    resetbtn_bind:SetSize(0, 100)
    resetbtn_bind.DoClick = function()
        net.Start("reset-binds")
        net.SendToServer()

        menu_bind:Close()
    end

    /////////////////////////////////////////////////////////
end

net.Receive("open-binds", BindOpenMenu)