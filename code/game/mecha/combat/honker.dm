// ARISE, HONK! ARISE! DEATH TO BAYDEVS! LONG LIVE THE HONK!

/*
All of the objects and datums that go with this mech are deliberately kept here in honker.dm because
they are never intended for use by any other mech.
*/

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/banana_mortar
	name = "Banana Mortar"
	icon_state = "mecha_bananamrtr"
	projectile = /obj/item/weapon/bananapeel
	fire_sound = 'sound/items/bikehorn.ogg'
	projectiles = 15
	missile_speed = 1.5
	projectile_energy_cost = 100
	equip_cooldown = 20
	construction_time = 300
	construction_cost = list("metal"=20000,"bananium"=5000)

	can_attach(obj/mecha/combat/honker/M as obj)
		if(!istype(M))
			return 0
		return ..()

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/banana_mortar/mousetrap_mortar
	name = "Mousetrap Mortar"
	icon_state = "mecha_mousetrapmrtr"
	projectile = /obj/item/device/assembly/mousetrap
	equip_cooldown = 10

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/banana_mortar/mousetrap_mortar/Fire(atom/movable/AM, atom/target, turf/aimloc)
	var/obj/item/device/assembly/mousetrap/M = AM
	M.secured = 1
	..()

/obj/item/mecha_parts/mecha_equipment/weapon/honker
	name = "\improper HoNkER BlAsT 5000"
	icon_state = "mecha_honker"
	energy_drain = 200
	equip_cooldown = 150
	range = MELEE|RANGED
	construction_time = 500
	construction_cost = list("metal"=20000,"bananium"=10000)

	can_attach(obj/mecha/combat/honker/M as obj)
		if(!istype(M))
			return 0
		return ..()

	action(target)
		if(!chassis)
			return 0
		if(energy_drain && chassis.get_charge() < energy_drain)
			return 0
		if(!equip_ready)
			return 0

		playsound(chassis, 'sound/items/AirHorn.ogg', 100, 1)
		chassis.occupant_message("<font color='red' size='5'>HONK</font>")
		for(var/mob/living/carbon/M in ohearers(6, chassis))
			if(istype(M, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(istype(H.l_ear, /obj/item/clothing/ears/earmuffs) || istype(H.r_ear, /obj/item/clothing/ears/earmuffs))
					continue
			M << "<font color='red' size='7'>HONK</font>"
			M.sleeping = 0
			M.stuttering += 20
			M.ear_deaf += 30
			M.Weaken(3)
			if(prob(30))
				M.Stun(10)
				M.Paralyse(4)
			else
				M.make_jittery(500)
		chassis.use_power(energy_drain)
		log_message("Honked from [src.name]. HONK!")
		do_after_cooldown()
		return


/obj/effect/decal/mecha_wreckage/honker
	name = "Honker wreckage"
	icon_state = "honker-broken"

	New()
		..()
		var/list/parts = list(
								/obj/item/mecha_parts/chassis/honker,
								/obj/item/mecha_parts/part/honker_torso,
								/obj/item/mecha_parts/part/honker_head,
								/obj/item/mecha_parts/part/honker_left_arm,
								/obj/item/mecha_parts/part/honker_right_arm,
								/obj/item/mecha_parts/part/honker_left_leg,
								/obj/item/mecha_parts/part/honker_right_leg)
		for(var/i=0;i<2;i++)
			if(!isemptylist(parts) && prob(40))
				var/part = pick(parts)
				welder_salvage += part
				parts -= part
		return

/obj/mecha/combat/honker
	desc = "Produced by \"Tyranny of Honk, INC\", this exosuit is designed as heavy clown-support. Used to spread the fun and joy of life. HONK!"
	name = "H.O.N.K"
	icon_state = "honker"
	initial_icon = "honker"
	step_in = 2
	health = 140
	deflect_chance = 60
	internal_damage_threshold = 60
	damage_absorption = list("brute"=1.2,"fire"=1.5,"bullet"=1,"laser"=1,"energy"=1,"bomb"=1)
	max_temperature = 25000
	infra_luminosity = 5
//	operation_req_access = list(access_clown)
	wreckage = /obj/effect/decal/mecha_wreckage/honker
	add_req_access = 0
	max_equip = 3
	var/squeak = 0

/*
/obj/mecha/combat/honker/New()
	..()

	weapons += new /datum/mecha_weapon/honker(src)
	weapons += new /datum/mecha_weapon/missile_rack/banana_mortar(src)
	weapons += new /datum/mecha_weapon/missile_rack/banana_mortar/mousetrap_mortar(src)
	selected_weapon = weapons[1]
	return
*/


/obj/mecha/combat/honker/melee_action(target)
	if(!melee_can_hit)
		return
	else if(istype(target, /mob))
		step_away(target,src,15)
	return

/obj/mecha/combat/honker/get_stats_part()
	var/integrity = health/initial(health)*100
	var/cell_charge = get_charge()
	var/tank_pressure = internal_tank ? round(internal_tank.return_pressure(),0.01) : "None"
	var/tank_temperature = internal_tank ? internal_tank.return_temperature() : "Unknown"
	var/cabin_pressure = round(return_pressure(),0.01)
	var/output = {"[report_internal_damage()]
						[integrity<30?"<font color='red'><b>DAMAGE LEVEL CRITICAL</b></font><br>":null]
						[internal_damage&MECHA_INT_TEMP_CONTROL?"<font color='red'><b>CLOWN SUPPORT SYSTEM MALFUNCTION</b></font><br>":null]
						[internal_damage&MECHA_INT_TANK_BREACH?"<font color='red'><b>GAS TANK HONK</b></font><br>":null]
						[internal_damage&MECHA_INT_CONTROL_LOST?"<font color='red'><b>HONK-A-DOODLE</b></font> - <a href='?src=\ref[src];repair_int_control_lost=1'>Recalibrate</a><br>":null]
						<b>IntegriHONK: </b> [integrity]%<br>
						<b>PowerHONK charge: </b>[isnull(cell_charge)?"No powercell installed":"[cell.percent()]%"]<br>
						<b>Air source: </b>[use_internal_tank?"Internal Airtank":"Environment"]<br>
						<b>AirHONK pressure: </b>[tank_pressure]kPa<br>
						<b>AirHONK temperature: </b>[tank_temperature]&deg;K|[tank_temperature - T0C]&deg;C<br>
						<b>HONK pressure: </b>[cabin_pressure>WARNING_HIGH_PRESSURE ? "<font color='red'>[cabin_pressure]</font>": cabin_pressure]kPa<br>
						<b>HONK temperature: </b> [return_temperature()]&deg;K|[return_temperature() - T0C]&deg;C<br>
						<b>Lights: </b>[lights?"on":"off"]<br>
						[src.dna?"<b>DNA-locked:</b><br> <span style='font-size:10px;letter-spacing:-1px;'>[src.dna]</span> \[<a href='?src=\ref[src];reset_dna=1'>Reset</a>\]<br>":null]
					"}
	return output

/obj/mecha/combat/honker/get_stats_html()
	var/output = {"<html>
						<head><title>[src.name] data</title>
						<style>
						body {color: #00ff00; background: #32CD32; font-family:"Courier",monospace; font-size: 12px;}
						hr {border: 1px solid #0f0; color: #fff; background-color: #000;}
						a {padding:2px 5px;;color:#0f0;}
						.wr {margin-bottom: 5px;}
						.header {cursor:pointer;}
						.open, .closed {background: #32CD32; color:#000; padding:1px 2px;}
						.links a {margin-bottom: 2px;padding-top:3px;}
						.visible {display: block;}
						.hidden {display: none;}
						</style>
						<script language='javascript' type='text/javascript'>
						[js_byjax]
						[js_dropdowns]
						function ticker() {
						    setInterval(function(){
						        window.location='byond://?src=\ref[src]&update_content=1';
						        document.body.style.color = get_rand_color_string();
						      document.body.style.background = get_rand_color_string();
						    }, 1000);
						}

						function get_rand_color_string() {
						    var color = new Array;
						    for(var i=0;i<3;i++){
						        color.push(Math.floor(Math.random()*255));
						    }
						    return "rgb("+color.toString()+")";
						}

						window.onload = function() {
							dropdowns();
							ticker();
						}
						</script>
						</head>
						<body>
						<div id='content'>
						[src.get_stats_part()]
						</div>
						<div id='eq_list'>
						[src.get_equipment_list()]
						</div>
						<hr>
						<div id='commands'>
						[src.get_commands()]
						</div>
						</body>
						</html>
					 "}
	return output

/obj/mecha/combat/honker/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Sounds of HONK:</div>
						<div class='links'>
						<a href='?src=\ref[src];play_sound=sadtrombone'>Sad Trombone</a>
						</div>
						</div>
						"}
	output += ..()
	return output


/obj/mecha/combat/honker/get_equipment_list()
	if(!equipment.len)
		return
	var/output = "<b>Honk-ON-Systems:</b><div style=\"margin-left: 15px;\">"
	for(var/obj/item/mecha_parts/mecha_equipment/MT in equipment)
		output += "[selected==MT?"<b id='\ref[MT]'>":"<a id='\ref[MT]' href='?src=\ref[src];select_equip=\ref[MT]'>"][MT.get_equip_info()][selected==MT?"</b>":"</a>"]<br>"
	output += "</div>"
	return output



/obj/mecha/combat/honker/mechstep(direction)
	var/result = step(src,direction)
	if(result)
		if(!squeak)
			playsound(src, "clownstep", 70, 1)
			squeak = 1
		else
			squeak = 0
	return result

obj/mecha/combat/honker/Topic(href, href_list)
	..()
	if (href_list["play_sound"])
		switch(href_list["play_sound"])
			if("sadtrombone")
				playsound(src, 'sound/misc/sadtrombone.ogg', 50)
	return

proc/rand_hex_color()
	var/list/colors = list("0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f")
	var/color=""
	for (var/i=0;i<6;i++)
		color = color+pick(colors)
	return color



////////// HONK parts

/obj/item/mecha_parts/chassis/honker
	name = "H.O.N.K Chassis"

	New()
		..()
		construct = new /datum/construction/mecha/honker_chassis(src)

/obj/item/mecha_parts/part/honker_torso
	name="H.O.N.K Torso"
	icon_state = "honker_harness"
//	construction_time = 300
//	construction_cost = list("metal"=35000,"glass"=10000,"bananium"=10000)

/obj/item/mecha_parts/part/honker_head
	name="H.O.N.K Head"
	icon_state = "honker_head"
//	construction_time = 200
//	construction_cost = list("metal"=15000,"glass"=5000,"bananium"=5000)

/obj/item/mecha_parts/part/honker_left_arm
	name="H.O.N.K Left Arm"
	icon_state = "honker_l_arm"
//	construction_time = 200
//	construction_cost = list("metal"=20000,"bananium"=5000)

/obj/item/mecha_parts/part/honker_right_arm
	name="H.O.N.K Right Arm"
	icon_state = "honker_r_arm"
//	construction_time = 200
//	construction_cost = list("metal"=20000,"bananium"=5000)

/obj/item/mecha_parts/part/honker_left_leg
	name="H.O.N.K Left Leg"
	icon_state = "honker_l_leg"
//	construction_time = 200
//	construction_cost = list("metal"=20000,"bananium"=5000)

/obj/item/mecha_parts/part/honker_right_leg
	name="H.O.N.K Right Leg"
	icon_state = "honker_r_leg"
//	construction_time = 200
//	construction_cost = list("metal"=20000,"bananium"=5000)


// HONK construction datums

/datum/construction/mecha/honker
	result = "/obj/mecha/combat/honker"
	steps = list(list("key"=/obj/item/weapon/bikehorn),//1
					 list("key"=/obj/item/clothing/shoes/clown_shoes),//2
					 list("key"=/obj/item/weapon/bikehorn),//3
					 list("key"=/obj/item/clothing/mask/gas/clown_hat),//4
					 list("key"=/obj/item/weapon/bikehorn),//5
					 list("key"=/obj/item/weapon/circuitboard/mecha/honker/targeting),//6
					 list("key"=/obj/item/weapon/bikehorn),//7
					 list("key"=/obj/item/weapon/circuitboard/mecha/honker/peripherals),//8
					 list("key"=/obj/item/weapon/bikehorn),//9
					 list("key"=/obj/item/weapon/circuitboard/mecha/honker/main),//10
					 list("key"=/obj/item/weapon/bikehorn),//11
					 )

	action(atom/used_atom,mob/user as mob)
		return check_step(used_atom,user)

	custom_action(step, atom/used_atom, mob/user)
		if(!..())
			return 0

		if(istype(used_atom, /obj/item/weapon/bikehorn))
			playsound(holder, 'sound/items/bikehorn.ogg', 50, 1)
			user.visible_message("HONK!")

		//TODO: better messages.
		switch(step)
			if(10)
				user.visible_message("[user] installs the central control module into [holder].", "You install the central control module into [holder].")
				del used_atom
			if(8)
				user.visible_message("[user] installs the peripherals control module into [holder].", "You install the peripherals control module into [holder].")
				del used_atom
			if(6)
				user.visible_message("[user] installs the weapon control module into [holder].", "You install the weapon control module into [holder].")
				del used_atom
			if(4)
				user.visible_message("[user] puts clown wig and mask on [holder].", "You put clown wig and mask on [holder].")
				del used_atom
			if(2)
				user.visible_message("[user] puts clown boots on [holder].", "You put clown boots on [holder].")
				del used_atom
		return 1

	spawn_result()
		..()
		feedback_inc("mecha_honker_created",1)
		return

/datum/construction/mecha/honker_chassis
	steps = list(list("key"=/obj/item/mecha_parts/part/honker_torso),//1
					 list("key"=/obj/item/mecha_parts/part/honker_left_arm),//2
					 list("key"=/obj/item/mecha_parts/part/honker_right_arm),//3
					 list("key"=/obj/item/mecha_parts/part/honker_left_leg),//4
					 list("key"=/obj/item/mecha_parts/part/honker_right_leg),//5
					 list("key"=/obj/item/mecha_parts/part/honker_head)
					)

	action(atom/used_atom,mob/user as mob)
		return check_all_steps(used_atom,user)

	custom_action(step, atom/used_atom, mob/user)
		user.visible_message("[user] has connected [used_atom] to [holder].", "You connect [used_atom] to [holder]")
		holder.overlays += used_atom.icon_state+"+o"
		del used_atom
		return 1

	spawn_result()
		var/obj/item/mecha_parts/chassis/const_holder = holder
		const_holder.construct = new /datum/construction/mecha/honker(const_holder)
		const_holder.density = 1
		spawn()
			del src
		return