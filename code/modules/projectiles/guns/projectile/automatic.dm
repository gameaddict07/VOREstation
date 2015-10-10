/obj/item/weapon/gun/projectile/automatic //Hopefully someone will find a way to make these fire in bursts or something. --Superxpdude
	name = "submachine gun"
	desc = "A lightweight, fast firing gun. Uses 9mm ammo."
	icon_state = "saber"	//ugly
	w_class = 3
	load_method = SPEEDLOADER //yup. until someone sprites a magazine for it. // We HAVE a magazine sprite! Ugh. Lazy Bay. I'll fix this when I have time. -Ace
	max_shells = 22
	caliber = "9mm"
	origin_tech = "combat=4;materials=2"
	slot_flags = SLOT_BELT
	ammo_type = /obj/item/ammo_casing/c9mm
	multi_aim = 1
	fire_delay = 0



/obj/item/weapon/gun/projectile/automatic/mini_uzi
	name = "\improper Uzi"
	desc = "A lightweight, fast firing gun, for when you want someone dead. Uses .45 caliber ammo."
	icon_state = "mini-uzi"
	w_class = 3
	load_method = MAGAZINE
	caliber = ".45"
	origin_tech = "combat=5;materials=2;syndicate=8"
	magazine_type = /obj/item/ammo_magazine/c45uzi
	allowed_magazines = list(/obj/item/ammo_magazine/c45uzi)

/obj/item/weapon/gun/projectile/automatic/mini_uzi/update_icon()
	..()
	icon_state = (ammo_magazine)? "mini-uzi" : "mini-uzi-empty"
	update_held_icon()



/obj/item/weapon/gun/projectile/automatic/m14
	name = "\improper M14 Battle Rifle"
	desc = "Famous for killing commies back in 'Nam. This robust rifle is still produced across the galaxy for both sporting and military use, despite its antique design. Uses 7.62mm ammo."
	icon = 'icons/obj/custom_items.dmi'
	item_state = "boltaction" // Placeholder
	icon_state = "m14"
	w_class = 4
	fire_sound = 'sound/weapons/rifleshot.ogg'
	slot_flags = null // ToDo: Back sprite.
	origin_tech = "combat=2"
	magazine_type = /obj/item/ammo_magazine/m14
	allowed_magazines = list(/obj/item/ammo_magazine/m14)
	ammo_type = /obj/item/ammo_casing/a762
	load_method = MAGAZINE
	caliber = "a762"

/obj/item/weapon/gun/projectile/automatic/m14/update_icon()
	..()
	icon_state = (ammo_magazine)? "m14" : "m14-empty"
	update_held_icon()



/obj/item/weapon/gun/projectile/automatic/c20r
	name = "\improper C-20r SMG"
	desc = "A lightweight, fast firing gun, for when you REALLY need someone dead. Uses 12mm pistol ammo. Has a 'Scarborough Arms - Per falcis, per pravitas' buttstamp"
	icon_state = "c20r"
	item_state = "c20r"
	w_class = 3
	force = 10
	caliber = "12mm"
	origin_tech = "combat=5;materials=2;syndicate=8"
	slot_flags = SLOT_BELT|SLOT_BACK // ToDo: Back and belt sprite.
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a12mm
	allowed_magazines = list(/obj/item/ammo_magazine/a12mm)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

/obj/item/weapon/gun/projectile/automatic/c20r/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "c20r-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "c20r"
	return



/obj/item/weapon/gun/projectile/automatic/sts35
	name = "\improper STS-35 automatic rifle"
	desc = "A durable, rugged looking automatic weapon of a make popular on the frontier worlds. Uses 7.62mm ammo."
	icon_state = "arifle"
	item_state = null
	w_class = 4
	force = 10
	caliber = "a762"
	origin_tech = "combat=6;materials=1;syndicate=4"
	slot_flags = SLOT_BACK // ToDo: Back sprite.
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c762
	allowed_magazines = list(/obj/item/ammo_magazine/c762)

/obj/item/weapon/gun/projectile/automatic/sts35/update_icon()
	..()
	icon_state = (ammo_magazine)? "arifle" : "arifle-empty"
	update_held_icon()



/obj/item/weapon/gun/projectile/automatic/shotgun
	name = "Cybersun Striker-12"
	desc = "A high capacity semi-automatic shotgun produced by Cybersun Industries and banned by the Interstellar Firearms Act of 2534, because if a gun could talk, this gun would shout; <b>\"FUCK YOU AND EVERYONE IN YOUR GENERAL DIRECTION!\"</b>"
	icon_state = "striker"
	item_state = "riotgun" // placeholder
	fire_sound = 'sound/weapons/shotgun.ogg'
	max_shells = 12
	w_class = 4
	caliber = "shotgun"
	origin_tech = "combat=4;materials=2;syndicate=2;"
	slot_flags = null // ToDo: Belt sprite.
	load_method = SINGLE_CASING
	ammo_type = "/obj/item/ammo_casing/shotgun"



/obj/item/weapon/gun/projectile/automatic/wt550
	name = "\improper W-T 550 Saber"
	desc = "A cheap, mass produced Ward-Takahashi PDW. Uses 9mm ammo."
	icon_state = "wt550"
	item_state = "wt550"
	w_class = 3
	caliber = "9mm"
	origin_tech = "combat=5;materials=2"
	slot_flags = SLOT_BELT // ToDo: Belt sprite.
	ammo_type = "/obj/item/ammo_casing/c9mmr"
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mc9mmt/rubber
	allowed_magazines = list(/obj/item/ammo_magazine/mc9mmt)

/obj/item/weapon/gun/projectile/automatic/wt550/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "wt550-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "wt550"
	return



/obj/item/weapon/gun/projectile/automatic/m41a
	name = "\improper M41A Pulse Rifle Mk2"
	desc = "Mid-ranged assault rifle with an electronic pulse action; the MK2 has a lower ammo capacity than previous models, but offers significantly increased stopping power. Uses caseless 10x24mm ammunition."
	icon_state = "M41A_Olive"
	item_state = "M41A_Full"
	w_class = 4
	caliber = "10mmCaseless"
	origin_tech = "combat=5;materials=2;syndicate=8"
	ammo_type = "/obj/item/ammo_casing/a10mmc"
	fire_sound = 'sound/weapons/m41a.ogg'
	load_method = MAGAZINE
	slot_flags = SLOT_BACK
	magazine_type = /obj/item/ammo_magazine/a10mmc
	allowed_magazines = list(/obj/item/ammo_magazine/a10mmc)

/obj/item/weapon/gun/projectile/automatic/m41a/update_icon()
	..()
	icon_state = (ammo_magazine)? "M41A_Olive" : "M41A_Olive_Empty"
	item_state = (ammo_magazine)? "M41A_Full" : "M41A_Empty"
	update_held_icon()
	..()

/*
----------------
Work In Progress
----------------
	var/use_launcher = 0
	var/obj/item/weapon/gun/launcher/grenade/underslung/launcher

/obj/item/weapon/gun/projectile/automatic/m41a/New()
	..()
	launcher = new(src)

/obj/item/weapon/gun/projectile/automatic/m41a/attack_self(mob/user)
	use_launcher = !use_launcher
	user << "<span class='notice'>You switch to [use_launcher? "\the [launcher]" : "firing normally"].</span>"

/obj/item/weapon/gun/projectile/automatic/m41a/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/weapon/grenade)))
		launcher.load(I, user)
	else
		..()

/obj/item/weapon/gun/projectile/automatic/m41a/attack_hand(mob/user)
	if(user.get_inactive_hand() == src && use_launcher)
		launcher.unload(user)
	else
		..()

/obj/item/weapon/gun/projectile/automatic/m41a/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0)
	if(use_launcher)
		launcher.Fire(target, user, params, pointblank, reflex)
		if(!launcher.chambered)
			use_launcher = 0 //switch back automatically
	else
		..()

/obj/item/weapon/gun/projectile/automatic/m41a/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "carbine-[round(ammo_magazine.stored_ammo.len,2)]"
	else
		icon_state = "carbine"
	return

/obj/item/weapon/gun/projectile/automatic/m41a/examine(mob/user)
	..()
	if(launcher.chambered)
		user << "\The [launcher] has \a [launcher.chambered] loaded."
	else
		user << "\The [launcher] is empty."
*/

/obj/item/weapon/gun/projectile/automatic/z8
	name = "\improper Z8 Bulldog"
	desc = "An older model bullpup carbine, designed by the now defunct Zendai Foundries. Makes you feel like a space marine when you hold it. It's equipped with an under-barrel grenade launcher. Uses armor piercing 5.56mm ammo."
	icon_state = "carbine"
	item_state = "z8carbine"
	w_class = 4
	force = 10
	caliber = "a556"
	origin_tech = "combat=8;materials=3"
	ammo_type = "/obj/item/ammo_casing/a556"
	fire_sound = 'sound/weapons/Gunshot.ogg'
	slot_flags = SLOT_BACK // ToDo: Back sprite.
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a556
	allowed_magazines = list(/obj/item/ammo_magazine/a556)
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

	var/use_launcher = 0
	var/obj/item/weapon/gun/launcher/grenade/underslung/launcher

/obj/item/weapon/gun/projectile/automatic/z8/New()
	..()
	launcher = new(src)

/obj/item/weapon/gun/projectile/automatic/z8/attack_self(mob/user)
	use_launcher = !use_launcher
	user << "<span class='notice'>You switch to [use_launcher? "\the [launcher]" : "firing normally"].</span>"

/obj/item/weapon/gun/projectile/automatic/z8/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/weapon/grenade)))
		launcher.load(I, user)
	else
		..()

/obj/item/weapon/gun/projectile/automatic/z8/attack_hand(mob/user)
	if(user.get_inactive_hand() == src && use_launcher)
		launcher.unload(user)
	else
		..()

/obj/item/weapon/gun/projectile/automatic/z8/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0)
	if(use_launcher)
		launcher.Fire(target, user, params, pointblank, reflex)
		if(!launcher.chambered)
			use_launcher = 0 //switch back automatically
	else
		..()

/obj/item/weapon/gun/projectile/automatic/z8/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "carbine-[round(ammo_magazine.stored_ammo.len,2)]"
	else
		icon_state = "carbine"
	return

/obj/item/weapon/gun/projectile/automatic/z8/examine(mob/user)
	..()
	if(launcher.chambered)
		user << "\The [launcher] has \a [launcher.chambered] loaded."
	else
		user << "\The [launcher] is empty."



/obj/item/weapon/gun/projectile/automatic/l6_saw
	name = "\improper L6 SAW"
	desc = "A rather traditionally made light machine gun with a pleasantly lacquered wooden pistol grip. Has 'Aussec Armoury- 2531' engraved on the reciever. Uses 7.62mm ammo."
	icon_state = "l6closed100"
	item_state = "l6closedmag"
	w_class = 4
	force = 10
	slot_flags = 0
	max_shells = 50
	caliber = "a762"
	origin_tech = "combat=6;materials=1;syndicate=2"
	slot_flags = SLOT_BACK // ToDo: Back sprite.
	ammo_type = "/obj/item/ammo_casing/a762"
	fire_sound = 'sound/weapons/machinegun.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a762
	allowed_magazines = list(/obj/item/ammo_magazine/a762)
	var/cover_open = 0

/obj/item/weapon/gun/projectile/automatic/l6_saw/attack_self(mob/user as mob)
	cover_open = !cover_open
	playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
	user << "<span class='notice'>You [cover_open ? "open" : "close"] [src]'s cover.</span>"
	update_icon()

/obj/item/weapon/gun/projectile/automatic/l6_saw/update_icon()
	icon_state = "l6[cover_open ? "open" : "closed"][ammo_magazine ? round(ammo_magazine.stored_ammo.len, 25) : "-empty"]"

/obj/item/weapon/gun/projectile/automatic/l6_saw/special_check(mob/user)
	if(cover_open)
		user << "<span class='warning'>[src]'s cover is open! Close it before firing!</span>"
		return 0
	return ..()

/obj/item/weapon/gun/projectile/automatic/l6_saw/load_ammo(var/obj/item/A, mob/user)
	if(!cover_open)
		user << "<span class='warning'>You need to open the cover to load [src].</span>"
		return
	..()

/obj/item/weapon/gun/projectile/automatic/l6_saw/unload_ammo(mob/user, var/allow_dump=1)
	if(!cover_open)
		return
	..()