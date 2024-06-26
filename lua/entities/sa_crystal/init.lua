AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
DEFINE_BASECLASS("base_gmodentity")

ENT.WorldInternal = true

function ENT:Initialize()
	if self:KillIfSpawned() then return end

	self.SkipSBChecks = true
	self.CrystalResistant = true
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
end

function ENT:Think()
	BaseClass.Think(self)
	local pos = self:GetPos()
	for k, v in pairs(ents.FindInSphere(pos, 450)) do
		local myDmg = math.ceil(math.random(1000, 2000) * ((801 - v:GetPos():Distance(pos)) / 100))
		if (v:IsPlayer() or v:IsNPC()) and (not (v.InVehicle and v:InVehicle())) then
			v:TakeDamage(myDmg, self)
		end
	end
	SA.Tiberium.RemoveIntersecting(self, {"sa_crystalroid", "sa_crystaltower", "sa_mining_drill"})
	self:NextThink(CurTime() + 2)
	return true
end

function ENT:StartTouch(ent)
	local eClass = ent:GetClass()
	if ent:IsPlayer() then
		ent:Kill()
	elseif not (ent.CrystalResistant or ent.Autospawned) then
		local skin = self:GetSkin()
		local material
		if skin == 0 then
			material = "ce_mining/tib_blue.vtf"
		elseif skin == 1 then
			material = "ce_mining/tib_green.vtf"
		elseif skin == 2 then
			material = "ce_mining/tib_red.vtf"
		end
		ent:SetMaterial(material)
		constraint.RemoveAll(ent)
		ent:GetPhysicsObject():EnableMotion()
		timer.Simple(3, function()
			if IsValid(ent) then
				ent:Remove()
			end
		end)
	elseif eClass == "sa_crystal" or eClass == "sa_crystaltower" then
		self:Remove()
	end
end

function ENT:OnRemove()
	if (self.MasterTower and self.MasterTower:IsValid()) then
		self.MasterTower:CrystalRemoved()
	end
end
