/turf/simulated/wall/cult
	name = "wall"
	desc = "The patterns engraved on the wall seem to shift as you try to focus on them. You feel sick"
	icon_state = "cult"
	walltype = "cult"

//NIGHT WAS HERE
/turf/simulated/wall/stomach
	name = "stomach wall"
	desc = "Squishy and slimy to the touch!"
	icon = 'icons/turf/stomach.dmi'
	icon_state = "normal_wall"

/turf/simulated/wall/stomach/Rina
	name = "stomach wall"
	desc = "Squishy and slimy to the touch!"
	icon = 'icons/turf/stomach.dmi'
	icon_state = "blue_wall"

/turf/simulated/wall/stomach/xenomorph
	name = "stomach wall"
	desc = "Squishy and slimy to the touch!"
	icon = 'icons/turf/stomach.dmi'
	icon_state = "xeno_wall"

/turf/simulated/wall/stomach/New()
	//..()

	var/list/step_overlays = list("s" = NORTH, "n" = SOUTH, "w" = EAST, "e" = WEST)
	for(var/direction in step_overlays)
		var/turf/turf_to_check = get_step(src,step_overlays[direction])

		if(istype(turf_to_check,/turf/space) || istype(turf_to_check,/turf/simulated/floor))
			turf_to_check.overlays += image('icons/turf/stomach.dmi', "side_[direction]")

//TO BE OPTIMISED
/turf/simulated/wall/stomach/Rina/New()
	//..()

	var/list/step_overlays = list("s" = NORTH, "n" = SOUTH, "w" = EAST, "e" = WEST)
	for(var/direction in step_overlays)
		var/turf/turf_to_check = get_step(src,step_overlays[direction])

		if(istype(turf_to_check,/turf/space) || istype(turf_to_check,/turf/simulated/floor))
			turf_to_check.overlays += image('icons/turf/stomach.dmi', "side_[direction]_blue")

/turf/simulated/wall/stomach/xenomorph/New()
	//..()

	var/list/step_overlays = list("s" = NORTH, "n" = SOUTH, "w" = EAST, "e" = WEST)
	for(var/direction in step_overlays)
		var/turf/turf_to_check = get_step(src,step_overlays[direction])

		if(istype(turf_to_check,/turf/space) || istype(turf_to_check,/turf/simulated/floor))
			turf_to_check.overlays += image('icons/turf/stomach.dmi', "side_[direction]_xeno")

/turf/simulated/wall/stomach/relativewall()
	return 0

/turf/simulated/wall/stomach/relativewall_neighbours()
	return 0