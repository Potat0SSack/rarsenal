SWEP.PrintName			= "Fastcrab Can"
SWEP.Instructions		= "Upon using spawns 3 Fast Headcrabs, but it can only be used once!"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Delay         = 1.0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "AR2AltFire"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo		= "none"

SWEP.Slot = 5
SWEP.SlotPos = 3
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel	= "models/weapons/w_grenade.mdl"

SWEP.ShootSound = Sound("GrenadeBugBait.Splat")

function SWEP:PrimaryAttack()
	self:ThrowCrab()
end

function SWEP:CanSecondaryAttack()
	return false 
end

function SWEP:ShouldDropOnDie()
	return true 
end

function SWEP:ThrowCrab()
	
	timer.Create("headcrapLoop", 0.1, 3, function()
		local owner = self:GetOwner()

		if ( not owner:IsValid() ) then return end

		self:EmitSound( self.ShootSound )

		if ( CLIENT ) then return end

		local ent = ents.Create("npc_headcrab_fast")

		-- Always make sure that created entities are actually created!
		if ( not ent:IsValid() ) then return end

		local aimvec = owner:GetAimVector()
		local pos = aimvec * 60
		pos:Add( owner:EyePos() )

		ent:SetPos( pos )
		ent:Spawn()

		if timer.RepsLeft("headcrapLoop") == 0 then self.Owner:StripWeapon("weapon_rar_crabgun")  end

	end)
end