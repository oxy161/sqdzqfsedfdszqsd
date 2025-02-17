print("Config CC")

FLK = {}


///////////////////////
// CHARACTER CREATOR //
///////////////////////

// Les factions qui seront affiché dans le menu de sélection au début, ainsi que la "command" (voir jobs.lua du darkrp) de leur job de base respectif
FLK.CONFIG_FACTIONSMENU = {
    [1] = {
        ["Démons"] = {["comm"] = "demond", ["race"] = "demon"}
    },
    [2] = {
        ["Vampires"] = {["comm"] = "vnee", ["race"] = "vampire"}
    },
    [3] = {
        ["Humain"] = {["comm"] = "humain", ["race"] = "humain"}
    }
}

FLK.RACES = {
    "demon",
    "vampire",
    "humain",
    "fee",
    "ange"
}

// Les usergroups ayant accès aux fonctionnalitées administratives de l'addon
FLK.CONFIG_ADMINUSERGROUPS = {
    ["superadmin"] = true,
    ["admin"] = true
}

// Nombre max de persos
FLK.CONFIG_MAXCHARACTERS = 3

// Argent de base
FLK.BASEMONEY = 500

///////////////////
// SYSTEME BINDS //
///////////////////

FLK.DEFAULTBINDS = {
    ["OpenCC"] = 95,
    ["OpenStats"] = 92,
    ["OpenBDG"] = 12,
    ["OpenInv"] = 19,
    ["OpenComp"] = 26,
    ["ToggleMeleeMagic"] = 17,
    ["ToggleSpeedMode"] = 11,
    ["FirstSpell"] = 0,
    ["SecondSpell"] = 0,
    ["ThirdSpell"] = 0,
    ["FourthSpell"] = 0,
    ["FifthSpell"] = 0,
    ["AdminMenu"] = 100
}

FLK.DEFAULTBINDSNAME = {
    ["OpenCC"] = "Menu personnage",
    ["OpenStats"] = "Menu stats",
    ["OpenBDG"] = "Bodygroups",
    ["OpenInv"] = "Ouvrir l'inventaire",
    ["OpenComp"] = "Menu des compétences",
    ["ToggleMeleeMagic"] = "Toggle entre mêlée/magie",
    ["ToggleSpeedMode"] = "Toggle mode vitesse",
    ["FirstSpell"] = "Première compétence",
    ["SecondSpell"] = "Deuxième compétence",
    ["ThirdSpell"] = "Troisième compétence",
    ["FourthSpell"] = "Quatrième compétence",
    ["FifthSpell"] = "Cinquième compétence",
    ["AdminMenu"] = "Menu admin"
}

//////////////////
// STATS SYSTEM //
//////////////////

// En cas de changement de la stat BASEXP post-ouverture : créer une fonction ou commande permettant de re-set le niveau des joueurs à leur niveau actuel pour palier au décalage d'XP
FLK.BASEXP = 300
FLK.ADDXP = 100
FLK.MAXLEVEL = 1000
FLK.LEVELUP_TIME = 100

FLK.BASEWALKSPEED = 160

FLK.FORMULA = function(lvl)
	--local formula = (lvl^2)*FLK.BASEXP*0.5+lvl*FLK.BASEXP+FLK.BASEXP
    local formula = math.floor(FLK.BASEXP + FLK.BASEXP * (lvl + lvl^1.33)) // Merci chatGPT
	return formula
end

// Calcul des stats = https://www.desmos.com/calculator/ykekwx4kwz?lang=fr

FLK.BASEHP = 500
FLK.BASEMANA = 500
FLK.BASERUNSPEED = 350
FLK.BASECDREDUC = 0
FLK.BASEPHYSDAMAGE = 30
FLK.BASEMAGICDAMAGE = 30
FLK.BASERESISTPHYS = 0
FLK.BASERESISTMAGIC = 0

FLK.COMPCOST = {
    ["hp"] = 1,
    ["mana"] = 1,
    ["speed"] = 5,
    ["cdreduc"] = 3,
    ["physdmg"] = 3,
    ["magicdmg"] = 1,
    ["resistphys"] = 1,
    ["resistmagic"] = 1,
}

FLK.COMPADD = {
    ["hp"] = 100,
    ["mana"] = 76,
    ["speed"] = 5,
    ["cdreduc"] = 5,
    ["physdmg"] = 11,
    ["magicdmg"] = 12,
    ["resistphys"] = 8,
    ["resistmagic"] = 8,
}

FLK.COMPMAX = {                 // Le niveau maximal atteignable (attention : si la stat dépasse le niveau max une fois ajouté, alors elle ne pourra pas être ajoutée)
    ["hp"] = 15000,
    ["mana"] = 10000,
    ["speed"] = 500,
    ["cdreduc"] = 75,           // Ex : si je met "74" ici, le niveau max sera le cran juste en dessous (70), car cette stat s'ajoute 5 par 5 ; or 70 + 5 = 75 > 74.
    ["physdmg"] = 2000,
    ["magicdmg"] = 2000,
    ["resistphys"] = 1000,
    ["resistmagic"] = 1000,
}

////////////////
// INV SYSTEM //
////////////////

FLK.INVSIZE = 32
FLK.BANKSIZE = 256

FLK.BANKMODEL = "models/Items/ammoCrate_Rockets.mdl"