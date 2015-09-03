#define UPGRADE_COOLDOWN	40
#define UPGRADE_KILL_TIMER	100

/obj/item/weapon/grab
	name = "grab"
	flags = NOBLUDGEON
	var/obj/screen/grab/hud = null
	var/mob/affecting = null
	var/mob/assailant = null
	var/state = GRAB_PASSIVE

	var/allow_upgrade = 1
	var/last_upgrade = 0

	layer = 21
	abstract = 1
	item_state = "nothing"
	w_class = 5.0


/obj/item/weapon/grab/New(mob/user, mob/victim)
	..()
	loc = user
	assailant = user
	affecting = victim

	if(affecting.anchored)
		del(src)
		return

	affecting.grabbed_by += src

	hud = new /obj/screen/grab(src)
	hud.icon_state = "reinforce"
	hud.name = "reinforce grab"
	hud.master = src

/obj/item/weapon/grab/Del()
	//make sure the grabbed_by list doesn't fill up with nulls
	if(affecting) affecting.grabbed_by -= src
	..()

//Used by throw code to hand over the mob, instead of throwing the grab. The grab is then deleted by the throw code.
/obj/item/weapon/grab/proc/throw_held()
	if(affecting)
		if(affecting.buckled)
			return null
		if(state >= GRAB_AGGRESSIVE)
			return affecting
	return null


//This makes sure that the grab screen object is displayed in the correct hand.
/obj/item/weapon/grab/proc/synch()
	if(affecting)
		if(assailant.r_hand == src)
			hud.screen_loc = ui_rhand
		else
			hud.screen_loc = ui_lhand


/obj/item/weapon/grab/process()
	confirm()

	if(assailant.client)
		assailant.client.screen -= hud
		assailant.client.screen += hud

	if(assailant.pulling == affecting)
		assailant.stop_pulling()

	if(state <= GRAB_AGGRESSIVE)
		allow_upgrade = 1
		//disallow upgrading if we're grabbing more than one person
		if((assailant.l_hand && assailant.l_hand != src && istype(assailant.l_hand, /obj/item/weapon/grab)))
			var/obj/item/weapon/grab/G = assailant.l_hand
			if(G.affecting != affecting)
				allow_upgrade = 0
		if((assailant.r_hand && assailant.r_hand != src && istype(assailant.r_hand, /obj/item/weapon/grab)))
			var/obj/item/weapon/grab/G = assailant.r_hand
			if(G.affecting != affecting)
				allow_upgrade = 0
		if(state == GRAB_AGGRESSIVE)
			affecting.drop_l_hand()
			affecting.drop_r_hand()
			//disallow upgrading past aggressive if we're being grabbed aggressively
			for(var/obj/item/weapon/grab/G in affecting.grabbed_by)
				if(G == src) continue
				if(G.state >= GRAB_AGGRESSIVE)
					allow_upgrade = 0
		if(allow_upgrade)
			hud.icon_state = "reinforce"
		else
			hud.icon_state = "!reinforce"
	else if(!affecting.buckled)
		affecting.loc = assailant.loc

	if(state >= GRAB_NECK)
		affecting.Stun(3)
		if(isliving(affecting))
			var/mob/living/L = affecting
			L.adjustOxyLoss(1)

	if(state >= GRAB_KILL)
		//affecting.apply_effect(STUTTER, 5) //would do this, but affecting isn't declared as mob/living for some stupid reason.
		affecting.stuttering = max(affecting.stuttering, 5) //It will hamper your voice, being choked and all.
		affecting.Weaken(5)	//Should keep you down unless you get help.
		affecting.losebreath = min(affecting.losebreath + 2, 3)


/obj/item/weapon/grab/proc/s_click(obj/screen/S)
	if(!affecting)
		return
	if(state == GRAB_UPGRADING)
		return
	if(assailant.next_move > world.time)
		return
	if(world.time < (last_upgrade + UPGRADE_COOLDOWN))
		return
	if(!assailant.canmove || assailant.lying)
		del(src)
		return

	last_upgrade = world.time

	if(state < GRAB_AGGRESSIVE)
		if(!allow_upgrade)
			return
		assailant.visible_message("<span class='warning'>[assailant] has grabbed [affecting] aggressively (now hands)!</span>")
		state = GRAB_AGGRESSIVE
		icon_state = "grabbed1"
	else if(state < GRAB_NECK)
		if(isslime(affecting))
			assailant << "<span class='notice'>You squeeze [affecting], but nothing interesting happens.</span>"
			return

		assailant.visible_message("<span class='warning'>[assailant] has reinforced \his grip on [affecting] (now neck)!</span>")
		state = GRAB_NECK
		icon_state = "grabbed+1"
		if(!affecting.buckled)
			affecting.loc = assailant.loc
		affecting.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their neck grabbed by [assailant.name] ([assailant.ckey])</font>"
		assailant.attack_log += "\[[time_stamp()]\] <font color='red'>Grabbed the neck of [affecting.name] ([affecting.ckey])</font>"
		msg_admin_attack("[key_name(assailant)] grabbed the neck of [key_name(affecting)]")
		hud.icon_state = "disarm/kill"
		hud.name = "disarm/kill"
	else if(state < GRAB_UPGRADING)
		assailant.visible_message("<span class='danger'>[assailant] starts to tighten \his grip on [affecting]'s neck!</span>")
		hud.icon_state = "disarm/kill1"
		state = GRAB_UPGRADING
		if(do_after(assailant, UPGRADE_KILL_TIMER))
			if(state == GRAB_KILL)
				return
			if(!affecting)
				del(src)
				return
			if(!assailant.canmove || assailant.lying)
				del(src)
				return
			state = GRAB_KILL
			assailant.visible_message("<span class='danger'>[assailant] has tightened \his grip on [affecting]'s neck!</span>")
			affecting.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been strangled (kill intent) by [assailant.name] ([assailant.ckey])</font>"
			assailant.attack_log += "\[[time_stamp()]\] <font color='red'>Strangled (kill intent) [affecting.name] ([affecting.ckey])</font>"
			msg_admin_attack("[key_name(assailant)] strangled (kill intent) [key_name(affecting)]")

			assailant.next_move = world.time + 10
			affecting.losebreath += 1
		else
			assailant.visible_message("<span class='warning'>[assailant] was unable to tighten \his grip on [affecting]'s neck!</span>")
			hud.icon_state = "disarm/kill"
			state = GRAB_NECK


//This is used to make sure the victim hasn't managed to yackety sax away before using the grab.
/obj/item/weapon/grab/proc/confirm()
	if(!assailant || !affecting)
		del(src)
		return 0

	if(affecting)
		if(!isturf(assailant.loc) || ( !isturf(affecting.loc) || assailant.loc != affecting.loc && get_dist(assailant, affecting) > 1) )
			del(src)
			return 0

	return 1


/obj/item/weapon/grab/attack(mob/M, mob/user)
	if(!affecting)
		return

	//if(M == affecting)
		//s_click(hud)
		//return

	//This was added in by Bay, I don't know how it would work in practice

	//Bay eating code, covered by below proc.
/*	if(M == assailant && state >= GRAB_AGGRESSIVE)

		var/can_eat
		if((FAT in user.mutations) && ismonkey(affecting))
			can_eat = 1
		else
			var/mob/living/carbon/human/H = user
			if(istype(H) && H.species.gluttonous)
				if(H.species.gluttonous == 2)
					can_eat = 2
				else if(!ishuman(affecting) && !ismonkey(affecting) && (affecting.small || iscarbon(affecting)))
					can_eat = 1

		if(can_eat)
			var/mob/living/carbon/attacker = user
			user.visible_message("<span class='danger'>[user] is attempting to devour [affecting]!</span>")
			if(can_eat == 2)
				if(!do_mob(user, affecting)||!do_after(user, 30)) return
			else
				if(!do_mob(user, affecting)||!do_after(user, 100)) return
			user.visible_message("<span class='danger'>[user] devours [affecting]!</span>")
			affecting.loc = user
			attacker.stomach_contents.Add(affecting)
			del(src)*/

//Vore code swallowing emotes, modifying existing alien vore stuff.
	if(state >= GRAB_AGGRESSIVE)
		if((ishuman(user) && !issilicon(affecting)) || (isalien(user) && !issilicon(affecting))) // if( (ishuman(user)&& iscarbon(affecting) ) || ( isalien(user) && iscarbon(affecting) ) )
			// Alright, let's see if we can get this to work for feeding others as well as yourself - NW
			// If you click yourself...
			if(M == assailant)
				var/pronoun
				if (user.gender == "FEMALE")
					pronoun = "her"
				if (user.gender == "MALE")
					pronoun = "his"
				else
					pronoun = "their"
				var/mob/living/carbon/attacker = user
				// I did this commented out bit wrong. Fix ASAP.
				/*if(istype(affecting,/mob/living/simple_animal/hostile) && affecting.health >= 0 && affecting.faction != user.faction) // You can't eat something trying to kill you!
					user << "\red You can't eat that! It's still alive and still VERY PISSED OFF!"
					break*/ //

			//ORAL VORE
				if(attacker.vorifice == "Oral Vore")
					user.visible_message("<span class='danger'>[user] is attempting to swallow down [affecting]!</span>")

					if(!istype(affecting,/mob/living/carbon/human))
						if(!do_mob(user, affecting)||!do_after(user, 30)) return
					else
						if(!do_mob(user, affecting)||!do_after(user, 100)) return

					user.visible_message("<span class='danger'>[user] swallows the last of [affecting]!</span>")

					affecting.loc = user
					attacker.stomach_contents.Add(affecting)

					msg_admin_attack("[key_name(user)] oral vored [key_name(affecting)]")
					playsound(src, 'sound/vore/gulp.ogg', 100, 1)

					del(src)

			//UNBIRTH
				if(attacker.vorifice == "Unbirth")
					user.visible_message("<span class='danger'>[user] is attempting to unbirth [affecting]!</span>")

					if(!istype(affecting,/mob/living/carbon/human))
						if(!do_mob(user, affecting)||!do_after(user, 30)) return
					else
						if(!do_mob(user, affecting)||!do_after(user, 100)) return

					user.visible_message("<span class='danger'>[user] squelches [affecting] into [pronoun] womb!</span>")
					playsound(src, 'sound/vore/insert.ogg', 100, 1)

					affecting.loc = user
					attacker.womb_contents.Add(affecting)

					msg_admin_attack("[key_name(user)] unbirthed [key_name(affecting)]")

					del(src)

			//COCK VORE
				if(attacker.vorifice == "Cock Vore")
					user.visible_message("<span class='danger'>[user] is attempting to slide [affecting] into [pronoun] cock!</span>")

					if(!istype(affecting,/mob/living/carbon/human))
						if(!do_mob(user, affecting)||!do_after(user, 30)) return
					else
						if(!do_mob(user, affecting)||!do_after(user, 100)) return

					user.visible_message("<span class='danger'>[user] swallows [affecting] with [pronoun] cock!</span>")
					playsound(src, 'sound/vore/gulp.ogg', 100, 1)

					affecting.loc = user
					attacker.cock_contents.Add(affecting)

					msg_admin_attack("[key_name(user)] cock vored [key_name(affecting)]")

					del(src)

			//ANAL VORE
				if(attacker.vorifice == "Anal Vore")
					user.visible_message("<span class='danger'>[user] is attempting to push [affecting] up [pronoun] rear!</span>")

					if(!istype(affecting,/mob/living/carbon/human))
						if(!do_mob(user, affecting)||!do_after(user, 30)) return
					else
						if(!do_mob(user, affecting)||!do_after(user, 100)) return

					user.visible_message("<span class='danger'>[user] schlorps [affecting] into [pronoun] rump!</span>")
					playsound(src, 'sound/vore/schlorp.ogg', 100, 1)

					affecting.loc = user
					attacker.stomach_contents.Add(affecting)

					msg_admin_attack("[key_name(user)] anal vored [key_name(affecting)]")

					del(src)

			//BREAST VORE
				if(attacker.vorifice == "Breast Vore")
					user.visible_message("<span class='danger'>[user] is attempting to stuff [affecting] into [pronoun] breasts!</span>")

					if(!istype(affecting,/mob/living/carbon/human))
						if(!do_mob(user, affecting)||!do_after(user, 30)) return
					else
						if(!do_mob(user, affecting)||!do_after(user, 100)) return

					user.visible_message("<span class='danger'>[user] sucks [affecting] into [pronoun] tits!</span>")
					playsound(src, 'sound/vore/insert.ogg', 100, 1)

					affecting.loc = user
					attacker.boob_contents.Add(affecting)

					msg_admin_attack("[key_name(user)] boob vored [key_name(affecting)]")

					del(src)

			// If you click your target...
			if(M == affecting)
				var/mob/living/carbon/attacker = user
				var/mob/living/carbon/target = M

			//ORAL VORE
				if(attacker.vorifice == "Oral Vore")
					user.visible_message("<span class='danger'>[user] is attempting to feed themselves to [affecting]!</span>")

					if(!istype(affecting,/mob/living/carbon/human))
						if(!do_mob(user, affecting)||!do_after(user, 30)) return
					else
						if(!do_mob(user, affecting)||!do_after(user, 100)) return

					user.visible_message("<span class='danger'>[affecting] swallows the last of [user]!</span>")

					user.loc = affecting
					target.stomach_contents.Add(user)

					msg_admin_attack("[key_name(user)] fed themselves to [key_name(affecting)]")
					playsound(src, 'sound/vore/gulp.ogg', 100, 1) // This is a new feature. Only available for oral vore currently.

					del(src)


			//UNBIRTH
				if(attacker.vorifice == "Unbirth")
					user.visible_message("<span class='danger'>[user] is attempting to climb into [affecting]'s pussy!</span>")

					if(!istype(affecting,/mob/living/carbon/human))
						if(!do_mob(user, affecting)||!do_after(user, 30)) return
					else
						if(!do_mob(user, affecting)||!do_after(user, 100)) return

					user.visible_message("<span class='danger'>[user] squelches into [affecting]'s womb!</span>")
					playsound(src, 'sound/vore/insert.ogg', 100, 1)

					user.loc = affecting
					target.womb_contents.Add(user)

					msg_admin_attack("[key_name(user)] forced [key_name(affecting)] to unbirth them")

					del(src)

			//COCK VORE
				if(attacker.vorifice == "Cock Vore")
					user.visible_message("<span class='danger'>[user] is attempting to slide into [affecting]'s cock!</span>")

					if(!istype(affecting,/mob/living/carbon/human))
						if(!do_mob(user, affecting)||!do_after(user, 30)) return
					else
						if(!do_mob(user, affecting)||!do_after(user, 100)) return

					user.visible_message("<span class='danger'>[user] vanishes into [affecting]'s cock!</span>")
					playsound(src, 'sound/vore/gulp.ogg', 100, 1)

					user.loc = affecting
					target.cock_contents.Add(user)

					msg_admin_attack("[key_name(user)] forced [key_name(affecting)] to cock vore them")

					del(src)

			//ANAL VORE
				if(attacker.vorifice == "Anal Vore")
					user.visible_message("<span class='danger'>[user] is attempting to push themselves up [affecting]'s rear!</span>")

					if(!istype(affecting,/mob/living/carbon/human))
						if(!do_mob(user, affecting)||!do_after(user, 30)) return
					else
						if(!do_mob(user, affecting)||!do_after(user, 100)) return

					user.visible_message("<span class='danger'>[user] disappears up [affecting]'s ass!</span>")
					playsound(src, 'sound/vore/schlorp.ogg', 100, 1)

					user.loc = affecting
					target.stomach_contents.Add(user)

					msg_admin_attack("[key_name(user)] forced [key_name(affecting)] to anal vore them")
					del(src)

			//BREAST VORE
				if(attacker.vorifice == "Breast Vore")
					user.visible_message("<span class='danger'>[user] is attempting to stuff themselves into [affecting]'s breasts!</span>")

					if(!istype(affecting,/mob/living/carbon/human))
						if(!do_mob(user, affecting)||!do_after(user, 30)) return
					else
						if(!do_mob(user, affecting)||!do_after(user, 100)) return

					user.visible_message("<span class='danger'>[user] pushes themselves fully into [affecting]'s tits!</span>")
					playsound(src, 'sound/vore/insert.ogg', 100, 1)

					user.loc = affecting
					target.boob_contents.Add(user)

					msg_admin_attack("[key_name(user)] forced [key_name(affecting)] to boob vore them")

					del(src)

			// If you click someone else...
			else
				var/mob/living/carbon/attacker = user
				var/mob/living/carbon/target = M
				// I did this commented out bit wrong. Fix ASAP.
				/*if(istype(M,/mob/living/simple_animal/hostile) && M.health >= 0 && M.faction != user.faction) // You can't feed something to someone while it's trying to kill you!
					user << "\red You can't feed that to [affecting]! It's still alive and still VERY PISSED OFF!"
					break*/
			//ORAL VORE
				if(attacker.vorifice == "Oral Vore")
					user.visible_message("<span class='danger'>[user] is attempting to feed [affecting] to [M]!</span>")

					if(!istype(affecting,/mob/living/carbon/human))
						if(!do_mob(user, affecting)||!do_after(user, 30)) return
					else
						if(!do_mob(user, affecting)||!do_after(user, 100)) return

					user.visible_message("<span class='danger'>[M] swallows the last of [affecting]!</span>")

					affecting.loc = target
					target.stomach_contents.Add(affecting)

					msg_admin_attack("[key_name(user)] fed [key_name(affecting)] to [key_name(M)]")
					playsound(src, 'sound/vore/gulp.ogg', 100, 1) // This is a new feature. Only available for oral vore currently.

					del(src)

			//UNBIRTH
				if(attacker.vorifice == "Unbirth")
					user.visible_message("<span class='danger'>[user] is attempting to push [affecting] into [M]'s pussy!</span>")

					if(!istype(affecting,/mob/living/carbon/human))
						if(!do_mob(user, affecting)||!do_after(user, 30)) return
					else
						if(!do_mob(user, affecting)||!do_after(user, 100)) return

					user.visible_message("<span class='danger'>[affecting] squelches into [M]'s womb!</span>")
					playsound(src, 'sound/vore/insert.ogg', 100, 1)

					affecting.loc = target
					target.womb_contents.Add(affecting)

					msg_admin_attack("[key_name(user)] forced [key_name(M)] to unbirth [key_name(affecting)]")

					del(src)

			//COCK VORE
				if(attacker.vorifice == "Cock Vore")
					user.visible_message("<span class='danger'>[user] is attempting to slide [affecting] into [M]'s cock!</span>")

					if(!istype(affecting,/mob/living/carbon/human))
						if(!do_mob(user, affecting)||!do_after(user, 30)) return
					else
						if(!do_mob(user, affecting)||!do_after(user, 100)) return

					user.visible_message("<span class='danger'>[affecting] vanishes into [M]'s cock!</span>")
					playsound(src, 'sound/vore/gulp.ogg', 100, 1)

					affecting.loc = target
					target.cock_contents.Add(affecting)

					msg_admin_attack("[key_name(user)] forced [key_name(M)] to cock vore [key_name(affecting)]")

					del(src)

			//ANAL VORE
				if(attacker.vorifice == "Anal Vore")
					user.visible_message("<span class='danger'>[user] is attempting to push [affecting] up [M]'s rear!</span>")

					if(!istype(affecting,/mob/living/carbon/human))
						if(!do_mob(user, affecting)||!do_after(user, 30)) return
					else
						if(!do_mob(user, affecting)||!do_after(user, 100)) return

					user.visible_message("<span class='danger'>[affecting] disappears up [M]'s ass!</span>")
					playsound(src, 'sound/vore/schlorp.ogg', 100, 1)

					affecting.loc = target
					target.stomach_contents.Add(affecting)

					msg_admin_attack("[key_name(user)] forced [key_name(M)] to anal vore [key_name(affecting)]")

					del(src)

			//BREAST VORE
				if(attacker.vorifice == "Breast Vore")
					user.visible_message("<span class='danger'>[user] is attempting to stuff [affecting] into [M]'s breasts!</span>")

					if(!istype(affecting,/mob/living/carbon/human))
						if(!do_mob(user, affecting)||!do_after(user, 30)) return
					else
						if(!do_mob(user, affecting)||!do_after(user, 100)) return

					user.visible_message("<span class='danger'>[M] sucks [affecting] into her tits!</span>")
					playsound(src, 'sound/vore/insert.ogg', 100, 1)

					affecting.loc = target
					target.boob_contents.Add(affecting)

					msg_admin_attack("[key_name(user)] forced [key_name(M)] to boob vore [key_name(affecting)]")

					del(src)
//End vore code.

/obj/item/weapon/grab/dropped()
	del(src)

/obj/item/weapon/grab/Del()
	del(hud)
	..()
