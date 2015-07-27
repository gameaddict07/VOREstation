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
	for(var/mob/living/M in src.contents)
		if(istype(target,/mob/living/carbon/human) || istype(target,/mob/living/carbon/alien || istype(target,/mob/living/simple_animal)))
			if(M == target)
				return
			if(target.vorifice == "Oral Vore")
				user.visible_message("<span class='danger'>[user] is attempting to stuff [M] down [target]'s throat!</span>")
				if(!do_mob(user, M)||!do_after(user, 100)) return
				user.visible_message("<span class='danger'>[target] swallows the last of [M]!</span>")
				M.loc = target
				src.contents.Remove(M)
				target.stomach_contents.Add(M)
				if(target == user)
					msg_admin_attack("[key_name(user)] oral vored [key_name(M)]")
				else
					msg_admin_attack("[key_name(user)] fed [key_name(M)] to [key_name(target)]")
				playsound(src, 'sound/vore/gulp.ogg', 100, 1) // This is a new feature. Only available for oral vore currently.
			if(target.vorifice == "Unbirth")
				user.visible_message("<span class='danger'>[user] starts to push [M] into [target]'s pussy!</span>")
				if(!do_mob(user, M)||!do_after(user, 100)) return
				user.visible_message("<span class='danger'>The last of [M] vanishes into [target]'s vagina!</span>")
				playsound(src, 'sound/vore/insert.ogg', 100, 1)
				M.loc = target
				src.contents.Remove(M)
				target.womb_contents.Add(M)
				if(target == user)
					msg_admin_attack("[key_name(user)] unbirthed [key_name(M)]")
				else
					msg_admin_attack("[key_name(user)] forced [key_name(target)] to unbirth [key_name(M)]")
			if(target.vorifice == "Cock Vore")
				user.visible_message("<span class='danger'>[user] begins to force [M] down [target]'s shaft!</span>")
				if(!do_mob(user, M)||!do_after(user, 100)) return
				user.visible_message("<span class='danger'>[M] disappears into [target]'s cock!</span>")
				M.loc = target
				src.contents.Remove(M)
				target.cock_contents.Add(M)
				if(target == user)
					msg_admin_attack("[key_name(user)] cock vored [key_name(M)]")
				else
					msg_admin_attack("[key_name(user)] forced [key_name(target)] to cock vore [key_name(M)]")
				playsound(src, 'sound/vore/gulp.ogg', 100, 1)
			if(target.vorifice == "Anal Vore")
				user.visible_message("<span class='danger'>[user] starts sliding [M] up [target]'s ass!</span>")
				if(!do_mob(user, M)||!do_after(user, 100)) return
				user.visible_message("<span class='danger'>[M] fully slides into [target]'s ass!</span>")
				M.loc = target
				src.contents.Remove(M)
				target.stomach_contents.Add(M)
				if(target == user)
					msg_admin_attack("[key_name(user)] anal vored [key_name(M)]")
				else
					msg_admin_attack("[key_name(user)] forced [key_name(target)] to anal vore [key_name(M)]")
				playsound(src, 'sound/vore/schlorp.ogg', 100, 1)
			if(target.vorifice == "Breast Vore")
				user.visible_message("<span class='danger'>[user] is trying to force [M] into [target]'s breasts!</span>")
				if(!do_mob(user, M)||!do_after(user, 100)) return
				user.visible_message("<span class='danger'>[user] stuffs the last of [M] into [target]'s boobs!</span>")
				M.loc = target
				src.contents.Remove(M)
				target.boob_contents.Add(M)
				if(target == user)
					msg_admin_attack("[key_name(user)] breast vored [key_name(M)]")
				else
					msg_admin_attack("[key_name(user)] forced [key_name(target)] to breast vore [key_name(M)]")
				playsound(src, 'sound/vore/insert.ogg', 100, 1)
