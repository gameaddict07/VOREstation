//Helper object for picking dionaea (and other creatures) up.
/obj/item/weapon/holder
	name = "holder"
	desc = "You shouldn't ever see this."
	icon = 'icons/obj/objects.dmi'
	slot_flags = SLOT_HEAD
	sprite_sheets = list("Vox" = 'icons/mob/species/vox/head.dmi')

/obj/item/weapon/holder/New()
	item_state = icon_state
	..()
	processing_objects.Add(src)

/obj/item/weapon/holder/Del()
	processing_objects.Remove(src)
	..()

/obj/item/weapon/holder/process()

	if(istype(loc,/turf) || !(contents.len))

		for(var/mob/M in contents)

			var/atom/movable/mob_container
			mob_container = M
			mob_container.forceMove(get_turf(src))
			M.reset_view()

		del(src)

/obj/item/weapon/holder/attackby(obj/item/weapon/W as obj, mob/user as mob)
	for(var/mob/M in src.contents)
		M.attackby(W,user)

/obj/item/weapon/holder/proc/show_message(var/message, var/m_type)
	for(var/mob/living/M in contents)
		M.show_message(message,m_type)

//Mob procs and vars for scooping up
/mob/living/var/holder_type

/mob/living/proc/get_scooped(var/mob/living/carbon/grabber)
	if(!holder_type || buckled || pinned.len)
		return

	var/obj/item/weapon/holder/H = new holder_type(loc)
	src.loc = H
	H.name = loc.name
	H.attack_hand(grabber)

	grabber << "You scoop up [src]."
	src << "[grabber] scoops you up."
	grabber.status_flags |= PASSEMOTES
	return H

//Mob specific holders.

/obj/item/weapon/holder/diona
	name = "diona nymph"
	desc = "It's a tiny plant critter."
	icon_state = "nymph"
	origin_tech = "magnets=3;biotech=5"
	slot_flags = SLOT_HEAD | SLOT_OCLOTHING

/obj/item/weapon/holder/drone
	name = "maintenance drone"
	desc = "It's a small maintenance robot."
	icon_state = "drone"
	origin_tech = "magnets=3;engineering=5"

/obj/item/weapon/holder/cat
	name = "cat"
	desc = "It's a cat. Meow."
	icon_state = "cat"
	origin_tech = null

/obj/item/weapon/holder/borer
	name = "cortical borer"
	desc = "It's a slimy brain slug. Gross."
	icon_state = "borer"
	origin_tech = "biotech=6"


//micro holders
/obj/item/weapon/holder/micro
	name = "micro"
	desc = "Another crewmember, small enough to fit in your hand."
	icon_state = "micro"
	slot_flags = SLOT_FEET | SLOT_HEAD
	w_class = 2

/obj/item/weapon/holder/micro/attack_self(var/mob/living/user)
	for(var/mob/living/carbon/human/M in contents)
		M.help_shake_act(user)

//This should most likely be preattack. Check whenever possible (doing a straight port)
/obj/item/weapon/holder/micro/afterattack(var/mob/living/carbon/target, var/mob/user, var/proximity)
	if(!proximity) return

	// Note! In old code, when feeding to an animal, the animals attackby() proc fired first, and this second.
	// By the time the thread got to this point, the micro had already been removed from contents.
	// That was the only thing preventing a crash due to bad typecast.
	// So lets start out by making sure!
	// TODO LESHANA - Review whether these procs should actually go into the classes of the vore-capable objects instead
	if (!is_vore_predator(target)) return

	for(var/mob/living/M in contents)
		if(M == target)
			return

		// TODO - Do we want to do any size comparisons? "micro" is relative after all, could be normal sized in macro paws!

		// NOTE! Which belly the micro goes into is based on the TARGET's vore setting
		// 	not the attacker's vore setting! This is the same behavior as old code. Keeping it for now -Leshana
		var/datum/voretype/target_voretype = target.vorifice
		if (target_voretype)
			target_voretype.eat_held_mob(user, M, target)

