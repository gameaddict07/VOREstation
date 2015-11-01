/mob/living/simple_animal/fox
	name = "Fox"
	desc = "It's a fox. I wonder what it says?"
	icon_state = "fox"
	icon_living = "fox"
	icon_dead = "fox_dead"
	speak = list("Ack-Ack","Ack-Ack-Ack-Ackawoooo","Geckers","Awoo","Tchoff")
	speak_emote = list("geckers", "barks")
	emote_hear = list("howls","barks")
	emote_see = list("shakes its head", "shivers")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help = "scritches"
	response_disarm = "gently pushes aside"
	response_harm = "kicks"
	var/turns_since_scan = 0
	var/mob/living/simple_animal/mouse/movement_target
	var/mob/flee_target
	min_oxy = 16 			//Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323		//Above 50 Degrees Celcius
	mob_size = 5

// All them complicated fox procedures.
/mob/living/simple_animal/fox/Life()
	//MICE!
	if((loc) && isturf(loc))
		if(!stat && !resting && !buckled)
			for(var/mob/living/simple_animal/mouse/M in loc)
				if(isPredator) //If the fox is a predator,
					movement_target = null
					custom_emote(1, "greedily stuffs [M] into their gaping maw!")
					sleep(30)
					if(M in oview(1, src))
						custom_emote(1, "swallows down [M] into their hungry gut!")
						M.loc = src
						stomach_contents.Add(M)
						playsound(src, 'sound/vore/gulp.ogg', 100, 1)
					else
						M << "You just manage to slip away from [src]'s jaws before you can be sent to a fleshy prison!"
					break
				else
					if(!M.stat)
						M.splat()
						visible_emote(pick("bites \the [M]!","toys with \the [M].","chomps on \the [M]!"))
						movement_target = null
						stop_automated_movement = 0
						break

	..()

	for(var/mob/living/simple_animal/mouse/snack in oview(src,5))
		if(snack.stat < DEAD && prob(15))
			audible_emote(pick("hunkers down!","acts stealthy!","eyes [snack] hungrily."))
		break

	if(!stat && !resting && !buckled) //SEE A MICRO AND ARE A PREDATOR, EAT IT!
		for(var/mob/living/carbon/human/food in oview(src, 3))
			if(food.playerscale <= RESIZE_A_SMALLTINY)
				if(prob(10))
					custom_emote(1, pick("eyes [food] hungrily!","licks their lips and turns towards [food] a little!","pants as they imagine [food] being in their belly."))
					break
				else
					if(prob(2))
						movement_target = food
						break
		for(var/mob/living/carbon/human/bellyfiller in oview(1, src))
			if(bellyfiller.playerscale <= RESIZE_A_SMALLTINY && isPredator)
				movement_target = null
				custom_emote(1, pick("slurps [bellyfiller] with their slimey tongue.","looms over [bellyfiller] with their maw agape.","sniffs at [bellyfiller], their belly grumbling hungrily."))
				sleep(2)

				custom_emote(1, "scoops [bellyfiller] into their maw!")
				sleep(swallowTime)
				if(bellyfiller in oview(1, src))
					custom_emote(1, "swallows down [bellyfiller] with a happy yap!")
					bellyfiller.loc = src
					stomach_contents.Add(bellyfiller)
					msg_admin_attack("[key_name(bellyfiller)] got eaten by [src]!")
					playsound(src, 'sound/vore/gulp.ogg', 100, 1)
				else
					bellyfiller << "You just manage to slip away from [src]'s jaws before you can be sent to a fleshy prison!"
				break

	if(!stat && !resting && !buckled)
		turns_since_scan++
		if (turns_since_scan > 5)
			walk_to(src,0)
			turns_since_scan = 0

			if (flee_target) //fleeing takes precendence
				handle_flee_target()
			else
				handle_movement_target()

/mob/living/simple_animal/fox/proc/handle_movement_target()
	//if our target is neither inside a turf or inside a human(???), stop
	if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
		movement_target = null
		stop_automated_movement = 0
	//if we have no target or our current one is out of sight/too far away
	if( !movement_target || !(movement_target.loc in oview(src, 4)) )
		movement_target = null
		stop_automated_movement = 0
		for(var/mob/living/simple_animal/mouse/snack in oview(src)) //search for a new target
			if(isturf(snack.loc) && !snack.stat)
				movement_target = snack
				break

	if(movement_target)
		stop_automated_movement = 1
		walk_to(src,movement_target,0,3)

/mob/living/simple_animal/fox/proc/handle_flee_target()
	//see if we should stop fleeing
	if (flee_target && !(flee_target.loc in view(src)))
		flee_target = null
		stop_automated_movement = 0

	if (flee_target)
		if(prob(25)) say("GRRRRR!")
		stop_automated_movement = 1
		walk_away(src, flee_target, 7, 2)

/mob/living/simple_animal/fox/proc/set_flee_target(atom/A)
	if(A)
		flee_target = A
		turns_since_scan = 5

/mob/living/simple_animal/fox/attackby(var/obj/item/O, var/mob/user)
	. = ..()
	if(O.force)
		set_flee_target(user? user : src.loc)


/mob/living/simple_animal/fox/attack_hand(mob/living/carbon/human/M as mob)
	. = ..()
	if(M.a_intent == "hurt")
		set_flee_target(M)

/mob/living/simple_animal/fox/ex_act()
	. = ..()
	set_flee_target(src.loc)

/mob/living/simple_animal/fox/bullet_act(var/obj/item/projectile/proj)
	. = ..()
	set_flee_target(proj.firer? proj.firer : src.loc)

/mob/living/simple_animal/fox/hitby(atom/movable/AM)
	. = ..()
	set_flee_target(AM.thrower? AM.thrower : src.loc)

/mob/living/simple_animal/fox/MouseDrop(atom/over_object)

	var/mob/living/carbon/H = over_object
	if(!istype(H) || !Adjacent(H)) return ..()

	if(H.a_intent == "help")
		get_scooped(H)
		return
	else
		return ..()

/mob/living/simple_animal/fox/get_scooped(var/mob/living/carbon/grabber)
	if (stat >= DEAD)
		return //since the holder icon looks like a living cat
	..()

//Basic friend AI
/mob/living/simple_animal/fox/fluff
	var/mob/living/carbon/human/friend
	var/befriend_job = null

/mob/living/simple_animal/fox/fluff/handle_movement_target()
	if (friend)
		var/follow_dist = 5
		if (friend.stat >= DEAD || friend.health <= config.health_threshold_softcrit) //danger
			follow_dist = 1
		else if (friend.stat || friend.health <= 50) //danger or just sleeping
			follow_dist = 2
		var/near_dist = max(follow_dist - 2, 1)
		var/current_dist = get_dist(src, friend)

		if (movement_target != friend)
			if (current_dist > follow_dist && !istype(movement_target, /mob/living/simple_animal/mouse) && (friend in oview(src)))
				//stop existing movement
				walk_to(src,0)
				turns_since_scan = 0

				//walk to friend
				stop_automated_movement = 1
				movement_target = friend
				walk_to(src, movement_target, near_dist, 4)

		//already following and close enough, stop
		else if (current_dist <= near_dist)
			walk_to(src,0)
			movement_target = null
			stop_automated_movement = 0
			if (prob(10))
				say("Yap!")

	if (!friend || movement_target != friend)
		..()

/mob/living/simple_animal/fox/fluff/Life()
	..()
	if (stat || !friend)
		return
	if (get_dist(src, friend) <= 1)
		if (friend.stat >= DEAD || friend.health <= config.health_threshold_softcrit)
			if (prob((friend.stat < DEAD)? 50 : 15))
				var/verb = pick("huffs", "whines", "yowls")
				audible_emote(pick("[verb] in distress.", "[verb] anxiously."))
		else
			if (prob(5))
				visible_emote(pick("nips [friend] affectionately.",
								   "yaps at [friend].",
								   "looks at [friend], wagging.",
								   "wags happily."))
	else if (friend.health <= 50)
		if (prob(10))
			var/verb = pick("huffs", "whines", "yowls")
			audible_emote("[verb] anxiously.")

/mob/living/simple_animal/fox/fluff/verb/friend()
	set name = "Become Friends"
	set category = "IC"
	set src in view(1)

	if(friend && usr == friend)
		set_dir(get_dir(src, friend))
		say("Yap!")
		return

	if (!(ishuman(usr) && befriend_job && usr.job == befriend_job))
		usr << "<span class='notice'>[src] ignores you.</span>"
		return

	friend = usr

	set_dir(get_dir(src, friend))
	say("Yap!")


//Captain fox
/mob/living/simple_animal/fox/fluff/Renault
	name = "Renault"
	desc = "Renault, the Captain's trustworthy fox.I wonder what it says?"
	isPredator = 1
	befriend_job = "Captain"