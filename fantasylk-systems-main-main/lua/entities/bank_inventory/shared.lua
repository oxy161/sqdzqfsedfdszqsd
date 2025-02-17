print("shared")

-- Defines the Entity's type, base, printable name, and author for shared access (both server and client)
ENT.Type = "anim" -- Sets the Entity type to 'anim', indicating it's an animated Entity.
ENT.Base = "base_gmodentity" -- Specifies that this Entity is based on the 'base_gmodentity', inheriting its functionality.
ENT.PrintName = "Banque d'inventaire" -- The name that will appear in the spawn menu.
ENT.Author = "Kepyyy" -- The author's name for this Entity.
ENT.Category = "FLK Inventory System" -- The category for this Entity in the spawn menu.
ENT.Spawnable = true -- Specifies whether this Entity can be spawned by players in the spawn menu.