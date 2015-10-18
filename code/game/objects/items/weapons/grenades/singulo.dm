/obj/item/weapon/grenade/singulo
	desc = "A superweapon that will unleash unleash a devestating singularity into the vicinity. It is set to detonate in 20 minutes. <font color=red><b>You have a feeling only a trained expert should fuck with this.</b></font>"
	name = "\improper Singularity Bomb"
	icon_state = "singulobomb"
	item_state = "table_parts" // placeholder
	origin_tech = "materials=5;magnets=5;bluespace=10;redspace=10"
	det_time = 12000 // 20 minutes to give sufficient time to run the fuck away.
	w_class = 5 // You can't shove this in any bag. Not even a bluespace bag.

	prime()
		var/turf/T = get_turf(src)
		playsound(T, 'sound/effects/phasein.ogg', 100, 1)
		for(var/mob/living/carbon/human/M in viewers(T, null))
			if(M:eyecheck() <= 0)
				flick("e_flash", M.flash)
		var/obj/machinery/singularity/singulo = new /obj/machinery/singularity
		singulo.loc = T
		singulo.energy = 510 // We want a singulo that at least moves around.
		del(src)
		return