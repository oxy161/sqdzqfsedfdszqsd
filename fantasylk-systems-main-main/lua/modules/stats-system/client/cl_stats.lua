print(
    [[
    ///////////////////////////////////////////////////
    /////////////// STATS SYSTEM CHARGÉ ///////////////
    ///////////////// DEV PAR KEPYYY //////////////////
    ///////////////////////////////////////////////////
    ]]
)

local flkdebug = true

surface.CreateFont( "Arial_one", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 20,
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

surface.CreateFont( "Arial_two", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 15,
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

local statNames = {}
local statCompName = {}

function StatsMenu()
    local ply = LocalPlayer()
    local Chars = net.ReadTable()
    local charID = net.ReadString()
    local charStats = net.ReadTable()
    local charPts = net.ReadInt(16)
    local bind = net.ReadInt(16)

    for i = 1, table.Count(charStats) do // On réorganise les stats, et on attribut le nom de la stat
        if i == 1 then
            table.insert(statNames, i, "Vie")
            table.insert(statCompName, i, "hp")
        elseif i == 2 then
            table.insert(statNames, i, "Mana")
            table.insert(statCompName, i, "mana")
        elseif i == 3 then
            table.insert(statNames, i, "Vitesse")
            table.insert(statCompName, i, "speed")
        elseif i == 4 then
            table.insert(statNames, i, "Réduc. cooldown")
            table.insert(statCompName, i, "cdreduc")
        elseif i == 5 then
            table.insert(statNames, i, "Dégâts physique")
            table.insert(statCompName, i, "physdmg")
        elseif i == 6 then
            table.insert(statNames, i, "Dégâts magique")
            table.insert(statCompName, i, "magicdmg")
        elseif i == 7 then
            table.insert(statNames, i, "Résist. physique")
            table.insert(statCompName, i, "resistphys")
        elseif i == 8 then
            table.insert(statNames, i, "Résist. magique")
            table.insert(statCompName, i, "resistmagic")
        end
    end

    local menu_sm = vgui.Create("DFrame")
    local modelbg_sm = vgui.Create("DPanel", menu_sm)
    local model_sm = vgui.Create("DModelPanel", modelbg_sm)

    menu_sm:SetSize(ScrW(), ScrH())
    menu_sm:Center()
    menu_sm:SetSizable(false)
    menu_sm:SetDraggable(false)
    menu_sm:MakePopup()
    local menu_sm_w, menu_sm_h = menu_sm:GetWide(), menu_sm:GetTall()

    ///////////////////////
    // PLAYERMODEL PANEL //
    ///////////////////////

    modelbg_sm:SetPos(menu_sm_w/1.5, 35)
    modelbg_sm:SetSize(menu_sm_w/3-10, menu_sm_h-45)
    modelbg_sm:SetBackgroundColor(Color(255,255,255,100))

    local modelbg_sm_w, modelbg_sm_h = modelbg_sm:GetWide(), modelbg_sm:GetTall()
    model_sm:SetPos(10,10)
    model_sm:SetSize(modelbg_sm_w-20, modelbg_sm_h-20)
    model_sm:SetFOV(40)
    function model_sm:LayoutEntity(ent) return end
    for k, v in pairs(Chars) do
        for a, b in pairs(v) do
            if b["uniqueid"] == charID then
                local charMdl = b["model"]
                local charBdg = b["bodygroup"]
                local charSkin = b["skin"]
                model_sm:SetModel(charMdl)
                model_sm:GetEntity():SetSkin(charSkin)
                if charBdg != "none" then
                    for c, d in pairs(charBdg) do
                        model_sm:GetEntity():SetBodygroup(c, d)
                    end
                end
            end
        end
    end

    //////////////////////
    // PLAYERINFO PANEL //
    //////////////////////

    local pname_sm = vgui.Create("DLabel", menu_sm)
    local plvl_sm = vgui.Create("DLabel", menu_sm)
    local ppts_sm = vgui.Create("DLabel", menu_sm)

    pname_sm:SetPos(10, 35)
    pname_sm:SetText(ply:Name())
    pname_sm:SetFont("CC_CHARNAME_50")
    pname_sm:SizeToContents()

    plvl_sm:SetPos(10, 80)
    plvl_sm:SetText("Level : "..ply:GetNWInt("clientLvl", -1))
    plvl_sm:SetFont("CC_CHARNAME_50")
    plvl_sm:SizeToContents()

    ppts_sm:SetPos(10, 130)
    ppts_sm:SetText("Points : "..charPts)
    ppts_sm:SetFont("CC_CHARNAME_50")
    ppts_sm:SizeToContents()

    /////////////////
    // STATS PANEL //
    /////////////////

    local statsbg_sm = vgui.Create("DPanel", menu_sm)
    
    statsbg_sm:SetPos(10, menu_sm_h/1.5)
    statsbg_sm:SetSize(menu_sm_w/1.5-20, menu_sm_h/3-10)
    statsbg_sm:SetBackgroundColor(Color(255,255,255,100))
    local stats_w, stats_h = statsbg_sm:GetWide(), statsbg_sm:GetTall()
    
    local statsgrid_sm = vgui.Create("DGrid", statsbg_sm)
    statsgrid_sm:SetPos(10,10)
    statsgrid_sm:SetCols(4)
    statsgrid_sm:SetColWide(stats_w/4)
    statsgrid_sm:SetRowHeight(stats_h/2)

    for ind = 1, 8 do
        local statpanel = vgui.Create("DPanel", menu_sm)
        local statlb = vgui.Create("DLabel", statpanel)
        local statbtn = vgui.Create("DButton", statpanel)
        local statbtnten = vgui.Create("DButton", statpanel)

        statpanel:SetSize(stats_w/4-20, stats_h/2-20)
        statpanel:SetBackgroundColor(Color(255,255,255,100))

        statlb:Dock(FILL)
        statlb:SetFont("CC_CHARNAME_35")
        statlb:SetColor(color_white)
        for StatName, StatVal in pairs(charStats) do
            if statCompName[ind] == StatName then
                statlb:SetText(statNames[ind].." : ".. StatVal)
            end
        end
        statlb:SizeToContents()

        statbtn:Dock(BOTTOM)
        statbtn:SetSize(0, 50)
        statbtn:SetText("Augmenter (Coûte : "..FLK.COMPCOST[statCompName[ind]]..")")
        statbtn.DoClick = function()          
            net.Start("upgrade-stat")
                net.WriteInt(1, 8)
                net.WriteString(statCompName[ind])
            net.SendToServer()

            net.Receive("stat-authorized", function()
                local newCharStats = net.ReadTable()
                local newCharPts = net.ReadInt(16)

                for newStatName, newStatVal in pairs(newCharStats) do
                    if statCompName[ind] == newStatName then
                        statlb:SetText(statNames[ind].." : "..newStatVal)
                    end
                end

                ppts_sm:SetText("Points : "..newCharPts)
                ppts_sm:SizeToContents()
            end)
        end

        statbtnten:Dock(BOTTOM)
        statbtnten:SetSize(0, 50)
        statbtnten:SetText("Augmenter (Coûte : "..(FLK.COMPCOST[statCompName[ind]]*10)..")")
        statbtnten.DoClick = function()          
            net.Start("upgrade-stat")
                net.WriteInt(10, 8)
                net.WriteString(statCompName[ind])
            net.SendToServer()

            net.Receive("stat-authorized", function()
                local newCharStats = net.ReadTable()
                local newCharPts = net.ReadInt(16)

                for newStatName, newStatVal in pairs(newCharStats) do
                    if statCompName[ind] == newStatName then
                        statlb:SetText(statNames[ind].." : "..newStatVal)
                    end
                end

                ppts_sm:SetText("Points : "..newCharPts)
                ppts_sm:SizeToContents()
            end)
        end

        statsgrid_sm:AddItem(statpanel)
    end
end

net.Receive("stats-open", StatsMenu)

hook.Add("HUDPaint", "SS.Hud", function()
    local ply = LocalPlayer()
    local lvl = ply:GetNWInt("clientLvl", -1)
	local exp = ply:GetNWInt("clientExp", -1)
    local pts = ply:GetNWInt("clientPts", -1)
    if lvl == -1 or exp == -1 then return end
    local prev_lvl = lvl-1
    local orange = Color(255,125,0)
	local base = FLK.BASEXP

    local prev_reqxp = FLK.FORMULA(prev_lvl)
    local reqxp = FLK.FORMULA(lvl)

    local percent
    if lvl == 0 then
        percent = exp / reqxp
    else
        percent = (exp - prev_reqxp) / (reqxp - prev_reqxp)
    end
    local max_w = 400
    local bar_w = percent*max_w

    draw.RoundedBox(5, ScrW()/2 - max_w/2-4, 0-6, max_w+8, 30+10, color_black)
    draw.RoundedBox(5, ScrW()/2 - max_w/2-2, 0-8, max_w+4, 30+10, color_white)
    if ply:GetNWInt("clientLvl", -1) == FLK.MAXLEVEL then
        draw.RoundedBox(5, ScrW()/2 - max_w/2, 2, 400, 30-2, orange)
    else
        draw.RoundedBox(5, ScrW()/2 - max_w/2, 2, math.Clamp(bar_w, 0, 400), 30-2, orange)
    end

    draw.SimpleText("Level : "..lvl, "Arial_two", ScrW()/2-10, 15, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    if flkdebug then
        draw.SimpleText("[DEBUG] Points : "..pts, "Arial_two", ScrW()/2+max_w/2-10, 15, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText("Exp : "..exp.." / "..reqxp, "Arial_two", ScrW()/2-max_w/2+10, 15, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end)

hook.Add("OnPlayerChat", "SS.Debug", function(ply, txt)
    if txt != "/debugc" then return end

    ply:SetNWInt("clientPts", 9999)

    return ""
end)