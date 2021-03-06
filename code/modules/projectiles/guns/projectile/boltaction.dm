/obj/item/weapon/gun/projectile/shotgun/pump/rifle
	name = "bolt action rifle"
	desc = "A reproduction of an almost ancient weapon design from the early 20th century. Popular among hunters and collectors. Uses 7.62mm ammo."
	item_state = "boltaction"
	icon_state = "boltaction"
	fire_sound = 'sound/weapons/rifleshot.ogg'
	max_shells = 5
	caliber = "a762"
	origin_tech = "combat=2" // Old as shit rifle doesn't have very good tech.
	ammo_type = /obj/item/ammo_casing/a762
	load_method = SINGLE_CASING|SPEEDLOADER
	cocksound = 'sound/weapons/riflebolt.ogg'

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/mosin
	name = "\improper Mosin Nagant"
	desc = "How else are you going to arm five people for just $400? Uses 7.62mm ammo."
	icon_state = "mosin"

// Stolen hacky terrible code from doublebarrel shotgun. -Ace
/obj/item/weapon/gun/projectile/shotgun/pump/rifle/mosin/attackby(var/obj/item/A as obj, mob/user as mob)
	if(istype(A, /obj/item/weapon/circular_saw) || istype(A, /obj/item/weapon/melee/energy) || istype(A, /obj/item/weapon/pickaxe/plasmacutter) && w_class != 3)
		user << "<span class='notice'>You begin to shorten the barrel and stock of \the [src].</span>"
		if(loaded.len)
			afterattack(user, user)	//will this work? //it will. we call it twice, for twice the FUN
			playsound(user, fire_sound, 50, 1)
			user.visible_message("<span class='danger'>The shotgun goes off!</span>", "<span class='danger'>The shotgun goes off in your face!</span>")
			return
		if(do_after(user, 30))	//SHIT IS STEALTHY EYYYYY
			icon_state = "obrez"
			w_class = 3
			recoil = 2 // Owch
			accuracy = -1 // You know damn well why.
			item_state = "gun"
			slot_flags &= ~SLOT_BACK	//you can't sling it on your back
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER) //but you can wear it on your belt (poorly concealed under a trenchcoat, ideally) - or in a holster, why not.
			name = "Obrez"
			desc = "cheeki breeki"
			user << "<span class='warning'>You shorten the barrel and stock of \the [src]!</span>"
	else
		..()



/obj/item/weapon/gun/projectile/shotgun/pump/rifle/chalk // For target practice
	desc = "A bolt-action rifle with a lightweight synthetic wood stock, designed for competitive shooting. Comes shipped with chalk rounds pre-loaded into the gun. Popular among professional marksmen. Uses 7.62mm ammo."
	ammo_type = /obj/item/ammo_casing/a762/chalk

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/ceremonial // For Blueshield
	name = "ceremonial bolt-action rifle"
	desc = "A bolt-action rifle decorated with dazzling engravings across the stock. Usually loaded with blanks, but can fire live rounds. Popular among well-dressed guardsmen. Uses 7.62mm ammo."
	ammo_type = /obj/item/ammo_casing/a762/blank