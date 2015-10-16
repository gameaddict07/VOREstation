/area/awaymission/labyrinth
	name = "\improper Unknown Area"
	icon_state = "outline"
	requires_power = 0
	lighting_use_dynamic = 0 // Debug. Change before release.
	ambience = list('sound/ambience/ambicha1.ogg',
					'sound/ambience/ambicha2.ogg',
					'sound/ambience/ambicha3.ogg',
					'sound/ambience/ambicha4.ogg',
					'sound/ambience/ambispace.ogg',
					'sound/music/traitor.ogg',
					'sound/music/main.ogg',
					'sound/music/TheClownChild.ogg')

/turf/unsimulated/wall/exterior
	opacity = 0
	// For the outside of a building, or a massive wall.

/obj/structure/HonkMother
	name = "The Honk Mother"
	desc = "A monolithic effigy of the legendary Honk Mother, adorned with dazzling rainbow bananium."
	icon = 'icons/effects/160x160.dmi'
	pixel_x = -64

/obj/structure/HonkMother/Apex
	icon_state = "HonkMotherApex"

/obj/structure/HonkMother/Base
	icon_state = "HonkMotherBase"

/obj/effect/decal/mecha_wreckage/honker/cluwne
	name = "cluwne mech wreckage"
	icon_state = "cluwne-broken"

/obj/mecha/combat/honker/cluwne // What have I done?
	desc = "A mechanized assault device for juggernaughting against clown killers. It's a militarized variant of the H.O.N.K. mech, never before seen by human eyes!"
	name = "M.A.D. J.A.C.K."
	icon_state = "cluwne"
	initial_icon = "cluwne"
	step_in = 2
	health = 200
	deflect_chance = 60
	internal_damage_threshold = 60
	damage_absorption = list("brute"=1.2,"fire"=1.5,"bullet"=1,"laser"=1,"energy"=1,"bomb"=1)
	max_temperature = 25000
	infra_luminosity = 5
	operation_req_access = list(access_clown)
	wreckage = /obj/effect/decal/mecha_wreckage/honker/cluwne
	max_equip = 4
	var/obj/item/weapon/cell/infinite

/obj/mecha/combat/honker/cluwne/New()
	..()

	weapons += new /datum/mecha_weapon/honker(src)
	weapons += new /datum/mecha_weapon/missile_rack/banana_mortar(src)
	weapons += new /datum/mecha_weapon/missile_rack/explosive(src)
	weapons += new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot(src)
	selected_weapon = weapons[1]
	return
