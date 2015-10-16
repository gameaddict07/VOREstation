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

/*
/obj/mecha/combat/honker/cluwne/New()
	..()

	weapons += new /datum/mecha_weapon/honker(src)
	weapons += new /datum/mecha_weapon/missile_rack/banana_mortar(src)
	weapons += new /datum/mecha_weapon/missile_rack/explosive(src)
	weapons += new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot(src)
	selected_weapon = weapons[1]
	return
*/

/obj/effect/landmark/loot_spawn
	name = "loot spawner"
	icon_state = "grabbed1"
	var/live_cargo = 1 // So you can turn off aliens.
	var/low_probability = 0
	New()

		switch(pick( \
		low_probability * 1000;"nothing", \
		200 - low_probability * 175;"treasure", \
		25 + low_probability * 75;"remains", \
/*		25 + low_probability * 75;"plants", \
		5; "blob", \*/
		50 + low_probability * 50;"clothes", \
		"glasses", \
		100 - low_probability * 50;"weapons", \
		100 - low_probability * 50;"spacesuit", \
		"health", \
		25 + low_probability * 75;"snacks", \
		25;"alien", \
		"lights", \
		25 - low_probability * 25;"engineering", \
		25 - low_probability * 25;"coffin", \
/*		25;"mimic", \*/
		25;"viscerator", \
		))
			if("treasure")
				var/obj/structure/closet/crate/C = new(src.loc)
				if(prob(33))
					//coins

					var/amount = rand(2,6)
					var/list/possible_spawns = list()
					for(var/coin_type in typesof(/obj/item/weapon/coin))
						possible_spawns += coin_type

					var/coin_type = pick(possible_spawns)
					for(var/i=0,i<amount,i++)
						new coin_type(C)
				else if(prob(50))
					//bars

					var/amount = rand(2,6)
					var/quantity = rand(10,50)
					var/list/possible_spawns = list()
					for(var/bar_type in typesof(/obj/item/stack/sheet/mineral) - /obj/item/stack/sheet/mineral)
						possible_spawns += bar_type

					var/bar_type = pick(possible_spawns)
					for(var/i=0,i<amount,i++)
						var/obj/item/stack/sheet/mineral/M = new bar_type(C)
						M.amount = quantity
				else
					//credits

					var/amount = rand(2,6)
					var/list/possible_spawns = list()
					for(var/cash_type in typesof(/obj/item/stack/sheet/mineral))
						possible_spawns += cash_type

					var/cash_type = pick(possible_spawns)
					for(var/i=0,i<amount,i++)
						new cash_type(C)
			if("remains")
				if(prob(50))
					new /obj/effect/decal/remains/human(src.loc)
				else
					new /obj/effect/decal/remains/xeno(src.loc)
			if("plants")
				if(prob(25))
					var/list/possible_plant_spawns = list()
					for(var/food_type in typesof(/obj/item/weapon/reagent_containers/food/snacks/grown) - /obj/item/weapon/reagent_containers/food/snacks/grown)
					var/food_type = pick(possible_spawns)
					for(var/i=0,i<amount,i++)
						var/obj/item/stack/sheet/mineral/M = new bar_type(C)
						M.amount = quantity
			if("blob")
				new /obj/effect/blob/core(src.loc)
			if("clothes")
				var/obj/structure/closet/C = new(src.loc)
				C.icon_state = "blue"
				C.icon_closed = "blue"
				if(prob(33))
					new /obj/item/clothing/under/rainbow(C)
					new /obj/item/clothing/shoes/rainbow(C)
					new /obj/item/clothing/head/soft/rainbow(C)
					new /obj/item/clothing/gloves/rainbow(C)
				else if(prob(50))
					new /obj/item/clothing/under/chameleon(C)
				else
					new /obj/item/clothing/under/syndicate/combat(C)
					new /obj/item/clothing/shoes/swat(C)
					new /obj/item/clothing/gloves/swat(C)
					new /obj/item/clothing/mask/balaclava(C)
			if("glasses")
				var/obj/structure/closet/C = new(src.loc)
				var/new_type = pick(
				/obj/item/clothing/glasses/material, \
				/obj/item/clothing/glasses/thermal, \
				/obj/item/clothing/glasses/meson, \
				/obj/item/clothing/glasses/night, \
				/obj/item/clothing/glasses/hud/health, \
				/obj/item/clothing/glasses/hud/health \
				)
				new new_type(C)
			if("weapons")
				var/obj/structure/closet/crate/secure/weapon/C = new(src.loc)
				var/new_type = pick(
				////////// Melee //////////
				/obj/item/weapon/hatchet,\
				/obj/item/weapon/hatchet)
				new new_type(C)
			if("spacesuit")
				var/obj/structure/closet/syndicate/C = new(src.loc)
				if(prob(25))
					new /obj/item/clothing/suit/space/syndicate/black(C)
					new /obj/item/clothing/head/helmet/space/syndicate/black(C)
					new /obj/item/weapon/tank/oxygen/red(C)
					new /obj/item/clothing/mask/breath(C)
				else if(prob(33))
					new /obj/item/clothing/suit/space/syndicate/blue(C)
					new /obj/item/clothing/head/helmet/space/syndicate/blue(C)
					new /obj/item/weapon/tank/oxygen/red(C)
					new /obj/item/clothing/mask/breath(C)
				else if(prob(50))
					new /obj/item/clothing/suit/space/syndicate/green(C)
					new /obj/item/clothing/head/helmet/space/syndicate/green(C)
					new /obj/item/weapon/tank/oxygen/red(C)
					new /obj/item/clothing/mask/breath(C)
				else
					new /obj/item/clothing/suit/space/syndicate/orange(C)
					new /obj/item/clothing/head/helmet/space/syndicate/orange(C)
					new /obj/item/weapon/tank/oxygen/red(C)
					new /obj/item/clothing/mask/breath(C)
			if("health")
				//hopefully won't be necessary, but there were an awful lot of traps to get through...
				var/obj/structure/closet/crate/medical/C = new(src.loc)
				if(prob(50))
					new /obj/item/weapon/storage/firstaid/regular(C)
				if(prob(50))
					new /obj/item/weapon/storage/firstaid/fire(C)
				if(prob(50))
					new /obj/item/weapon/storage/firstaid/o2(C)
				if(prob(50))
					new /obj/item/weapon/storage/firstaid/toxin(C)
			if("snacks")
				//you're come so far, you must be in need of refreshment
				var/obj/structure/closet/crate/freezer/C = new(src.loc)
				var/num = rand(2,6)
				var/new_type = pick(
				/obj/item/weapon/reagent_containers/food/drinks/cans/beer, \
				/obj/item/weapon/reagent_containers/food/drinks/tea, \
				/obj/item/weapon/reagent_containers/food/drinks/dry_ramen, \
				/obj/item/weapon/reagent_containers/food/snacks/candiedapple, \
				/obj/item/weapon/reagent_containers/food/snacks/chocolatebar, \
				/obj/item/weapon/reagent_containers/food/snacks/cookie, \
				/obj/item/weapon/reagent_containers/food/snacks/meatball, \
				/obj/item/weapon/reagent_containers/food/snacks/plump_pie, \
				)
				for(var/i=0,i<num,i++)
					new new_type(C)
			if("alien")
				//ancient aliens
				var/obj/structure/closet/acloset/C = new(src.loc)
				if(prob(33))
					if(live_cargo) // Facehuggers!
						var/num = rand(1,3)
						for(var/i=0,i<num,i++)
							new /obj/item/clothing/mask/facehugger(C)
					else // Just a hat.
						new /obj/item/clothing/head/collectable/slime(C)
				else if(prob(50))
					if(live_cargo) // Something else very much alive and angry.
						var/spawn_type = pick(/mob/living/simple_animal/hostile/alien, /mob/living/simple_animal/hostile/alien/drone, /mob/living/simple_animal/hostile/alien/sentinel)
						new spawn_type(C)
					else // Just a costume.
						new /obj/item/clothing/head/xenos(C)
						new /obj/item/clothing/suit/xenos(C)

				//33% chance of nothing

			if("lights")
				//flares, candles, matches
				var/obj/structure/closet/crate/secure/gear/C = new(src.loc)
				var/num = rand(2,6)
				for(var/i=0,i<num,i++)
					var/spawn_type = pick(/obj/item/device/flashlight/flare, /obj/item/trash/candle, /obj/item/weapon/storage/box/matches)
					new spawn_type(C)
			if("engineering")
				var/obj/structure/closet/crate/secure/gear/C = new(src.loc)

				//chance to have any combination of up to two electrical/mechanical toolboxes and one cell
				if(prob(33))
					new /obj/item/weapon/storage/toolbox/electrical(C)
				else if(prob(50))
					new /obj/item/weapon/storage/toolbox/mechanical(C)

				if(prob(33))
					new /obj/item/weapon/storage/toolbox/mechanical(C)
				else if(prob(50))
					new /obj/item/weapon/storage/toolbox/electrical(C)

				if(prob(25))
					new /obj/item/weapon/cell(C)

			if("coffin")
				new /obj/structure/closet/coffin(src.loc)
				if(prob(33))
					new /obj/effect/decal/remains/human(src)
				else if(prob(50))
					new /obj/effect/decal/remains/xeno(src)
			if("mimic")
				//a guardian of the tomb!
				new /mob/living/simple_animal/hostile/mimic/crate(src.loc)
			if("viscerator")
				//more tomb guardians!
				var/num = rand(1,3)
				var/obj/structure/closet/crate/secure/gear/C = new(src.loc)
				for(var/i=0,i<num,i++)
					new /mob/living/simple_animal/hostile/viscerator(C)

		del(src)

/obj/effect/landmark/loot_spawn/low
	name = "low prob loot spawner"
	icon_state = "grabbed"
	low_probability = 1