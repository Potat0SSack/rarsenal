AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )

include( 'shared.lua' )

timer.Destroy( 'HostnameThink' )

hook.Add( 'PreGamemodeLoaded', 'widgets_disabler_cpu', function()
	function widgets.PlayerTick()
	end

	hook.Remove( 'PlayerTick', 'TickWidgets' )
end )

if ( not file.IsDir( 'dm', 'DATA' ) ) then 
	file.CreateDir( 'dm' )
end

timer.Create("weaponSpawn", 17, 0,  function()

	math.randomseed(os.time()) //i fucking hate .357 and the crossbow after this
	local weapon = {1, 2, 3, 4, 5, 6, 7, 8}
	local spawns = ents.FindByClass("prop_physics") //For those who want to modify this, just change prop_physics to whatever other entitity you want the game to spawn weapons on, some might not work like env_cubemap and info_node
	local random_entry = math.random(#spawns)
	local wpn = ents.Create("weapon_crowbar") //The game doesn't like it when i don't do this

	local weapon_pick = math.random(#weapon)
	//A professional would beat me up for this unholy mess
	//HL2 Weapon picks
	if weapon_pick == 1 then
		wpn = ents.Create("weapon_smg1")
	elseif weapon_pick == 2 then
		wpn = ents.Create("weapon_shotgun")
	elseif weapon_pick == 3 then
		wpn = ents.Create("weapon_crossbow")
	elseif weapon_pick == 4 then
		wpn = ents.Create("weapon_physcannon")
	elseif weapon_pick == 5 then
		wpn = ents.Create("weapon_357")
	elseif weapon_pick == 6 then
		wpn = ents.Create("weapon_rpg")
	//Rarsenal Weapon picks
	elseif weapon_pick == 7 then
		wpn = ents.Create("weapon_rar_crabgun")
	elseif weapon_pick == 8 then
		wpn = ents.Create("weapon_rar_melon-zooka")
	end

	wpn:SetPos(spawns[random_entry]:GetPos() + Vector(0,0,5))
	wpn:Spawn()

	PrintMessage(HUD_PRINTTALK, "A new weapon has been spawned somewhere!")

end)

-------------------------------------------------------------------------------------------------

--Dev Test stuff
hook.Add("PlayerSay", "CommandIdent", function(ply, text, bteam)
    if text == "!devWeapon" then

        local weapon = {1, 2, 3}
        local spawns = ents.FindByClass("prop_physics")
        local random_entry = math.random(#spawns)
        local wpn = ents.Create("weapon_crowbar")

        local weapon_pick = math.random(#weapon)

        if weapon_pick == 1 then
            wpn = ents.Create("weapon_smg1")
        elseif weapon_pick == 2 then
            wpn = ents.Create("weapon_shotgun")
        elseif weapon_pick == 3 then
            wpn = ents.Create("weapon_crossbow")
        end

        wpn:SetPos(spawns[random_entry]:GetPos() + Vector(0,0,5))
        wpn:Spawn()
    end
	
	if text == "!devWeaponRar" then
	
		local weapon = {1, 2, 3}
		local spawns = ents.FindByClass("prop_physics")
		local random_entry = math.random(#spawns)
		local wpn = ents.Create("weapon_crowbar")

		local weapon_pick = math.random(#weapon)

		if weapon_pick == 1 then
			wpn = ents.Create("weapon_rar_crabgun")
		elseif weapon_pick == 2 then
			wpn = ents.Create("weapon_rar_melon-zooka")
		elseif weapon_pick == 3 then
			wpn = ents.Create("weapon_rar_melon-zooka")
		end

		wpn:SetPos(spawns[random_entry]:GetPos() + Vector(0,0,5))
		wpn:Spawn()
	end
end)
