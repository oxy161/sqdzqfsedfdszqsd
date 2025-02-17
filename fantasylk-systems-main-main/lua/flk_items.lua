print(
    [[
    /////////////////////////////////////////////
    /////////// ITEMS SHARED CHARGÉ /////////////
    ////////////// DEV PAR KEPYYY ///////////////
    /////////////////////////////////////////////
    ]]
)

include("flk_config.lua")
AddCSLuaFile("flk_config.lua")

/////////////////////////////////////////////////////////////////////////////////////////////////////////

FLK.RESOURCEITEMS = {
    ["item_bois"] = true,
    ["item_roche"] = true,
    ["item_fer"] = true
}

FLK.STATSNAME = {
    ["physdmg"] = "Dégâts physiques",
    ["magicdmg"] = "Dégâts magiques",
    ["hp"] = "Vie",
    ["resistphys"] = "Résistance physique",
    ["resistmagic"] = "Résistance magique",
    ["mana"] = "Mana",
    ["speed"] = "Vitesse",
    ["cdreduc"] = "Réduction de cooldown"
}

FLK.TYPES = {
    // Equipement (unique)
    ["head"] = "Equipement de tête",
    ["chest"] = "Haut de corp",
    ["legs"] = "Bas de corp",
    ["feet"] = "Chaussures/Bottes...",
    ["primary"] = "Arme principale",
    ["unique"] = "Arme unique",
    ["necklace"] = "Collier",
    ["ring"] = "Anneau",
    ["book"] = "Grimoire",
    ["rune"] = "Rune",

    // Consommable (unique)
    ["consumable"] = "Consommable",

    // Ressources (stackable)
    ["resource"] = "Ressources"
}

FLK.EQUIPPABLE = {
    ["head"] = true,
    ["chest"] = true,
    ["legs"] = true,
    ["feet"] = true,
    ["primary"] = true,
    ["unique"] = true,
    ["necklace"] = true,
    ["ring"] = true,
    ["book"] = true,
    ["rune"] = true
}

FLK.EQUIPPABLESLOTS = {
    ["head"] = {["w"] = 370, ["h"] = 83},
    ["chest"] = {["w"] = 370, ["h"] = 372},
    ["legs"] = {["w"] = 370, ["h"] = 662},
    ["feet"] = {["w"] = 370, ["h"] = 949},
    ["primary"] = {["w"] = 543, ["h"] = 1123},
    ["unique"] = {["w"] = 923, ["h"] = 1123},
    ["necklace"] = {["w"] = 1095, ["h"] = 83},
    ["ring"] = {["w"] = 1095, ["h"] = 372},
    ["book"] = {["w"] = 1095, ["h"] = 662},
    ["rune"] = {["w"] = 1095, ["h"] = 949}
}

FLK.TIERSPRITES = {
    ["legendary"] = "tiers/legendary.png"
}

FLK.ITEMS = {
    ["masque_racine"] = {
        ["reference"] = "masque_racine",
        ["name"] = "Masque brisé des racines féériques",
        ["sprite"] = "items/masque_racine.png",
        ["description"] = "Un masque cassé provenant des racines des arbres de la forêt des fées.",
        ["tier"] = "legendary",
        ["type"] = "head",          // doit être le nom exact du slot sur lequel il peut être équipé (head, chest, primary... etc) 
        ["usable"] = false,
        ["consumable"] = false,     // Si lors de l'utilisation, l'item est supprimé
        ["ismask"] = true,
        ["linked"] = true,
        ["statChange"] = {          // STATS A ADDITIONNER
            ["physdmg"] = 0,
            ["magicdmg"] = 0,
            ["hp"] = 0,
            ["resistphys"] = 0,
            ["resistmagic"] = 0,
            ["mana"] = 200,
            ["speed"] = 0,
            ["cdreduc"] = 0
        },
        ["onuse"] = function(ply) end,
        ["reqlvl"] = 35
    }, // ne pas oublier la virgule si ce n'est pas le dernier item

    ["bottes_celerite"] = {
        ["reference"] = "bottes_celerite",
        ["name"] = "Bottes de célérité",
        ["sprite"] = "items/bottes_celerite.png",
        ["description"] = "Des bottes vous rendant plus rapide",
        ["tier"] = "legendary",
        ["type"] = "feet",          // doit être le nom exact du slot sur lequel il peut être équipé (head, chest, primary... etc) 
        ["usable"] = false,
        ["consumable"] = false,
        ["ismask"] = false,
        ["linked"] = true,
        ["statChange"] = {          // STATS A ADDITIONNER
            ["physdmg"] = 0,
            ["magicdmg"] = 0,
            ["hp"] = 0,
            ["resistphys"] = 0,
            ["resistmagic"] = 0,
            ["mana"] = 0,
            ["speed"] = 45,
            ["cdreduc"] = 0
        },
        ["onuse"] = function(ply) end,
        ["reqlvl"] = 50
    },

    ["plastron_saint"] = {
        ["reference"] = "plastron_saint",
        ["name"] = "Plastron Saint",
        ["sprite"] = "items/plastron_saint.png",
        ["description"] = "Un plastron de Grand Chevalier de Liones.",
        ["tier"] = "legendary",
        ["type"] = "chest",          // doit être le nom exact du slot sur lequel il peut être équipé (head, chest, primary... etc) 
        ["usable"] = false,
        ["consumable"] = false,
        ["ismask"] = false,
        ["linked"] = false,
        ["statChange"] = {          // STATS A ADDITIONNER
            ["physdmg"] = 0,
            ["magicdmg"] = 0,
            ["hp"] = 0,
            ["resistphys"] = 45,
            ["resistmagic"] = 0,
            ["mana"] = 0,
            ["speed"] = -20,
            ["cdreduc"] = 0
        },
        ["onuse"] = function(ply) end,
        ["reqlvl"] = 60
    },

    ["item_bois"] = {
        ["reference"] = "item_bois",
        ["name"] = "Bois",
        ["sprite"] = "items/item_bois.png",
        ["description"] = "Du bois pour fabriquer divers objets.",
        ["tier"] = "legendary",
        ["type"] = "resource",          // doit être le nom exact du slot sur lequel il peut être équipé (head, chest, primary... etc) 
        ["usable"] = false,
        ["consumable"] = false,
        ["ismask"] = false,
        ["linked"] = false,
        ["statChange"] = {          // STATS A ADDITIONNER
            ["physdmg"] = 0,
            ["magicdmg"] = 0,
            ["hp"] = 0,
            ["resistphys"] = 0,
            ["resistmagic"] = 0,
            ["mana"] = 0,
            ["speed"] = 0,
            ["cdreduc"] = 0
        },
        ["onuse"] = function(ply) end,
        ["reqlvl"] = 0
    },

    ["item_roche"] = {
        ["reference"] = "item_roche",
        ["name"] = "Roche",
        ["sprite"] = "items/item_roche.png",
        ["description"] = "De la roche pour fabriquer divers objets.",
        ["tier"] = "legendary",
        ["type"] = "resource",          // doit être le nom exact du slot sur lequel il peut être équipé (head, chest, primary... etc) 
        ["usable"] = false,
        ["consumable"] = false,
        ["ismask"] = false,
        ["linked"] = false,
        ["statChange"] = {          // STATS A ADDITIONNER
            ["physdmg"] = 0,
            ["magicdmg"] = 0,
            ["hp"] = 0,
            ["resistphys"] = 0,
            ["resistmagic"] = 0,
            ["mana"] = 0,
            ["speed"] = 0,
            ["cdreduc"] = 0
        },
        ["onuse"] = function(ply) end,
        ["reqlvl"] = 0
    },

    ["item_fer"] = {
        ["reference"] = "item_fer",
        ["name"] = "Fer",
        ["sprite"] = "items/item_fer.png",
        ["description"] = "Du fer pour fabriquer divers objets.",
        ["tier"] = "legendary",
        ["type"] = "resource",          // doit être le nom exact du slot sur lequel il peut être équipé (head, chest, primary... etc) 
        ["usable"] = false,
        ["consumable"] = false,
        ["ismask"] = false,
        ["linked"] = false,
        ["statChange"] = {          // STATS A ADDITIONNER
            ["physdmg"] = 0,
            ["magicdmg"] = 0,
            ["hp"] = 0,
            ["resistphys"] = 0,
            ["resistmagic"] = 0,
            ["mana"] = 0,
            ["speed"] = 0,
            ["cdreduc"] = 0
        },
        ["onuse"] = function(ply) end,
        ["reqlvl"] = 0
    },

    ["potion_soin"] = {
        ["reference"] = "potion_soin",
        ["name"] = "Potion de soin",
        ["sprite"] = "items/potion_soin.png",
        ["description"] = "Une potion de soin.",
        ["tier"] = "legendary",
        ["type"] = "consumable",          // doit être le nom exact du slot sur lequel il peut être équipé (head, chest, primary... etc) 
        ["usable"] = true,
        ["consumable"] = true,
        ["ismask"] = false,
        ["linked"] = false,
        ["statChange"] = {          // STATS A ADDITIONNER
            ["physdmg"] = 0,
            ["magicdmg"] = 0,
            ["hp"] = 0,
            ["resistphys"] = 0,
            ["resistmagic"] = 0,
            ["mana"] = 0,
            ["speed"] = 0,
            ["cdreduc"] = 0
        },
        ["onuse"] = function(ply) 
            local percent = ply:GetMaxHealth() * 0.01

            timer.Create("healing_pot_tick", 0.5, 10, function()
                ply:SetHealth(ply:Health() + percent)

                if ply:Health() > ply:GetMaxHealth() then
                    ply:SetHealth(ply:GetMaxHealth())
                    timer.Remove("healing_pot_tick")
                end
            end)

        end,
        ["reqlvl"] = 0
    }
}
