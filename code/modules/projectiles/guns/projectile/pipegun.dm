/obj/item/weapon/gun/projectile/pipegun
	name = "pipe gun"
	desc = "This sketchy homemade weapon was cobbled together a pipe, and an igniter, and some duct tape to hold it together. It will probably explode after repeated use. Uses shotgun ammo."
	icon_state = "pipegun4"
	item_state = "dshotgun"
	caliber = "shotgun"
	origin_tech = "combat=2;materials=2;illegal=2"
	w_class = 4
	slot_flags = null
	handle_casings = CYCLE_CASINGS // Because you need to eject the shells as they are used.
	max_shells = 1
	ammo_type = null // So it starts with no ammunition inside of it.
	var/explode_probability = 5

/obj/item/weapon/gun/projectile/pipegun/handle_post_fire()
	if(prob(explode_probability))
		explode(usr)
	if(prob(50)) // I forgot, gun can get damaged and explode even with no ammo. Need to fix this.
		explode_probability += 5
	..()

/obj/item/weapon/gun/projectile/pipegun/proc/explode(var/mob/living/user)
	flick("e_flash", user.flash)
	user.adjustBruteLoss(rand(10,70))
	user.Weaken(5)
	user.eye_blurry = 10
	playsound(src.loc, 'sound/effects/bang.ogg', 50, 1, 5)
	usr << "\red <font size=3><B>BANG!</B></font>"
	del(src)

// Didn't seem right to put this in construction.dm, so I put it here.
/obj/item/pipe/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/weapon/circular_saw))
		// ToDo: Prevent building assembly with non-simple or non-straight pipes.
		new /obj/item/weapon/pipegun_assembly(get_turf(src))
		user << "<span class='notice'>You cut a section of the pipe to fit an igniter.</span>"
		playsound(src.loc, 'sound/weapons/circsawhit.ogg', 25, -3)
		del(src)
	update_icon(user)

obj/item/weapon/pipegun_assembly
	name = "incomplete pipegun"
	desc = "A makeshift firearm that will be able to fire shotgun shells once it's finished. It needs something to ignite the ammo."
	icon = 'icons/obj/gun.dmi'
	icon_state = "pipegun0"
	item_state = "buildpipe"
	flags = CONDUCT
	force = 8
	throwforce = 10
	w_class = 3
	attack_verb = list("hit", "bludgeoned", "whacked", "bonked")

	var/buildstate = 0

/obj/item/weapon/pipegun_assembly/update_icon()
	icon_state = "pipegun[buildstate]"

/obj/item/weapon/pipegun_assembly/examine(mob/user)
	..(user)
	switch(buildstate)
		if(0) user << "It needs an igniter to fire any bullets."
		if(1) user << "It has an igniter loosely fitted to the pipe. Some tape should secure it."
		if(2) user << "It has an igniter taped firmly to the pipe. It needs a stock."
		if(3) user << "It is loosely sitting on a wooden stock. Some tape should secure it."

/obj/item/weapon/pipegun_assembly/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/device/assembly/igniter))
		if(buildstate == 0)
			var/obj/item/device/assembly/igniter/igniter = W
			if(!igniter.secured)
				playsound(src.loc, 'sound/items/Screwdriver2.ogg', 25, -3)
				user << "<span class='notice'>You attach an igniter to the pipe. It needs tape to secure it.</span>"
				buildstate++
				update_icon()
				del(W)
			else
				user << "<span class='notice'>The igniter cannot be attached.</span>"
			return
	else if(istype(W,/obj/item/weapon/tape_roll))
		if(buildstate == 1)
			playsound(src.loc, 'sound/items/zip.ogg', 25, -3)
			user << "<span class='notice'>You tape the igniter into place. Now it needs a wooden frame.</span>"
			buildstate++
			update_icon()
		else if(buildstate == 3)
			playsound(src.loc, 'sound/items/zip.ogg', 25, -3)
			user << "<span class='notice'>You tape the wooden frame firmly to the pipe gun. It's now ready to shoot.</span>"
			new /obj/item/weapon/gun/projectile/pipegun(get_turf(src))
			del(src)
		return
	else if(istype(W,/obj/item/weapon/crossbowframe))
		var/obj/item/weapon/crossbowframe/frame = W
		if(buildstate == 2 && !frame.buildstate)
			playsound(src.loc, 'sound/items/Screwdriver2.ogg', 25, -3)
			user << "<span class='notice'>You slide the pipegun assembly onto the wooden frame.</span>"
			buildstate++
			update_icon()
			del(W)
		else
			user << "<span class='notice'>The pipe won't fit on the stock because there's already parts in the way.</span>"
		return
	else
		..()

/*
Unused/untested code. I only leave it because this version takes up less lines and accomplishes the same thing.
Probably. I never actually tested it.

It was abandoned in favor of the code above because the vars above are easier to change for mapping or server events.

/obj/item/weapon/pipegun_assembly/attackby(var/obj/item/I, mob/user as mob)
	if(icon_state == "pipegun0" && istype(I, /obj/item/device/assembly/igniter) && !I.secured)
		playsound(src.loc, 'sound/items/Screwdriver2.ogg', 25, -3)
		user << "<span class='notice'>You attach an igniter to the pipe. It needs tape to secure it.</span>"
		desc = "[initial(desc)] It needs a strip of duct tape to secure the igniter."
		icon_state = "pipegun1"
		del(I)
		update_icon()
		return
	if(icon_state == "pipegun1" && istype(I, /obj/item/weapon/ducttape))
		playsound(src.loc, 'sound/items/zip.ogg', 25, -3)
		user << "<span class='notice'>You tape the igniter into place. Now it needs a wood stock.</span>"
		desc = "[initial(desc)] It needs a stock made from wood."
		icon_state = "pipegun2"
		del(I)
		update_icon()
		return
	if(icon_state == "pipegun2" && istype(I, /obj/item/weapon/crossbowframe))
		playsound(src.loc, 'sound/items/zip.ogg', 25, -3)
		user << "<span class='notice'>You tape the igniter into place. Now it needs a stock. Maybe part of a wooden bat could work.</span>"
		desc = "[initial(desc)] It needs a wooden stock."
		del(I)
		update_icon()
		return
	if(icon_state == "pipegun3" && istype(I, /obj/item/weapon/ducttape))
		var/obj/item/weapon/gun/projectile/pipegun/pipegun = new /obj/item/weapon/gun/projectile/pipegun
		user.put_in_hands(pipegun)
		del(I)
		del(src)
	else
		..()
*/