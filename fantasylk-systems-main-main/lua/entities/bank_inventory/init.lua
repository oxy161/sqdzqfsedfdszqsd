print("init")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("open-bank-inv")
util.AddNetworkString("move-item-to-bank")
util.AddNetworkString("move-item-to-inv")
util.AddNetworkString("move-half-to-inv")
util.AddNetworkString("move-half-to-bank")

-- Server-side initialization function for the Entity
function ENT:Initialize()
    self:SetModel( FLK.BANKMODEL ) -- Sets the model for the Entity.
    self:PhysicsInit( SOLID_VPHYSICS ) -- Initializes physics for the Entity, making it solid and interactable.
    self:SetMoveType( MOVETYPE_VPHYSICS ) -- Sets how the Entity moves, using physics.
    self:SetSolid( SOLID_VPHYSICS ) -- Makes the Entity solid, allowing for collisions.
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject() -- Retrieves the physics object of the Entity.
    if phys:IsValid() then -- Checks if the physics object is valid.
        phys:Wake() -- Activates the physics object, making the Entity subject to physics (gravity, collisions, etc.).
    end
end

function ENT:Use(ply)
    OpenBank(ply)
end