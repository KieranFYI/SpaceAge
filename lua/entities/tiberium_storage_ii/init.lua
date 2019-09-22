AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include("shared.lua")
local RD = CAF.GetAddon("Resource Distribution")

GLOBALTIMETILDELETE = {}

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	
	local ply = self:GetTable().Founder
	
	if not ply:IsAdmin() then self:SetModel("models/slyfo/sat_resourcetank.mdl") end
	
	self:CalcVars(ply)
	if not (WireAddon == nil) then
		self.WireDebugName = self.PrintName
		self.Outputs = Wire_CreateOutputs(self, { "Tiberium", "Max Tiberium" })
	end
	
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()	
		phys:SetMass(500)
	end
end

function ENT:CalcVars(ply)
	if not (ply.tibstoragemod > 0 and (ply.UserGroup == "legion" or ply.UserGroup == "alliance")) then self:Remove() return end
	self.IsTiberiumStorage = true
	RD.AddResource(self, "tiberium", (1550000 + (ply.tiberiummod * 10000)) * ply.devlimit, 0)
end

function ENT:Think()
	if WireAddon ~= nil then 
		self:UpdateWireOutput()
	end	
	self:NextThink(CurTime() + 1)
	return true
end

function ENT:UpdateWireOutput()
        Wire_TriggerOutput(self, "Tiberium", RD.GetResourceAmount( self, "tiberium" ))
        Wire_TriggerOutput(self, "Max Tiberium", RD.GetNetworkCapacity( self, "tiberium" ))
end

function ENT:OnTakeDamage(dmginfo)
	local dmg = dmginfo:GetDamage()
	if math.Rand(0,(dmg*0.3)+18) >= 20 then self:Remove() end
end

function ENT:OnRemove()
	if RD.GetResourceAmount( self, "tiberium" ) < 1000 then return self.BaseClass.OnRemove(self) end

	local wreck = ents.Create( "wreckedstuff" )
	wreck:SetSolid(SOLID_NONE)
	wreck:SetModel( self:GetModel() )
	wreck:SetAngles( self:GetAngles() )
	wreck:SetPos( self:GetPos() )
	wreck:Spawn()
	wreck:Activate()
	wreck.deathtype = 1
	
	self:Leak()
	
	self.BaseClass.OnRemove(self)
end

function ENT:Leak()
	for i = 1,math.Rand(1,4) do
		if #ents.FindByClass("sa_tibcrystal_rep") >= 100 then return end
		local Pos = FindWorldFloor(self:GetPos()+Vector(math.Rand(-500,500),math.Rand(-500,500),500),nil,{self})
		if Pos then
			local crystal = ents.Create("sa_tibcrystal_rep")
			GLOBALTIMETILDELETE[crystal:EntIndex()] = CurTime()+math.Rand(10,30)
			//print("Delete after "..GLOBALTIMETILDELETE[crystal:EntIndex()])
			crystal:SetModel( "models/ce_ls3additional/tiberium/tiberium_normal.mdl" )
			local Height = math.abs(crystal:OBBMaxs().z - crystal:OBBCenter().z)
			crystal:SetPos(Pos-Vector(0,0,Height-5))
			crystal:SetAngles(Angle(0,math.Rand(0,359),0))
			PropMoveSlow(crystal,crystal:GetPos()+Vector(0,0,Height-5),math.Rand(10,45))
			crystal:Spawn()
			crystal.MainSpawnedBy = crystal
		end
	end
end

local function XXXThink()
	for _,ent in pairs(ents.FindByClass("sa_tibcrystal_rep")) do
		if ent:IsValid() then
			if math.floor(GLOBALTIMETILDELETE[ent.MainSpawnedBy:EntIndex()]) < CurTime() then
				ent:Remove()
			end
		end
	end
end
hook.Add("Think","TibExtraRemoveThink",XXXThink)