SWEP.PrintName			= "Melon-Zooka"
SWEP.Instructions		= "Ever played Crash Bandicoot 3? Fire Watermelons at will! Watermelons disappear after 10 seconds"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false 
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false 
SWEP.Secondary.Ammo		= "none"

SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Slot			= 5
SWEP.SlotPos			= 4
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.ViewModel			= "models/weapons/c_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"
SWEP.ShootSound = Sound( "Weapon_MegaPhysCannon.Launch" )
 
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 1.5 )

	self:ThrowMelon( "models/props_junk/watermelon01.mdl" )
end

function SWEP:ThrowMelon( model_file )
	local owner = self:GetOwner()

	if ( not owner:IsValid() ) then return end

	self:EmitSound( self.ShootSound )

	if ( CLIENT ) then return end

	local ent = ents.Create( "prop_physics" )

	if ( not ent:IsValid() ) then return end

	ent:SetModel( model_file )

	local aimvec = owner:GetAimVector()
	local pos = aimvec * 16 
	pos:Add( owner:EyePos() ) 

	ent:SetPos( pos )

	ent:SetAngles( owner:EyeAngles() )
	ent:Spawn()

	local phys = ent:GetPhysicsObject()
	if ( not phys:IsValid() ) then ent:Remove() return end

	aimvec:Mul( 35000 )
	aimvec:Add( VectorRand( -10, 10 ) )
	phys:ApplyForceCenter( aimvec )

	timer.Simple( 10, function() if ent and ent:IsValid() then ent:Remove() end end )
end