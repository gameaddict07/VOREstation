#define SINGLE_CASING 	1	//The gun only accepts ammo_casings. ammo_magazines should never have this as their mag_type.
#define SPEEDLOADER 	2	//Transfers casings from the mag to the gun when used.
#define MAGAZINE 		4	//The magazine item itself goes inside the gun

// The M41A from the Xeno station mission is not yet here. Need to include ASAP.

/obj/item/weapon/gun/projectile/automatic/battlerifle
	name = "\improper BR55 Service Rifle"
	desc = "You had your chance to be afraid before you joined my beloved Corps! But, to guide you back to the true path, I brought this motivational device!"
	icon_state = "battlerifle"
	item_state = "battlerifle"
	w_class = 4
	max_shells = 36
	caliber = "battlerifle"
	origin_tech = "combat=2;materials=2;"
	ammo_type = /obj/item/ammo_casing/a95mm
	magazine_type = /obj/item/ammo_magazine/battlerifle
	fire_sound = 'sound/weapons/battlerifle.ogg'
	load_method = MAGAZINE
	slot_flags = SLOT_BACK

/obj/item/weapon/gun/projectile/shotgun/pump/unsc
	name = "\improper M45E Tactical Shotgun"
	desc = "All you greenhorns who wanted to see Xenomorphs up close... this is your lucky day."
	icon_state = "haloshotgun"
	item_state = "haloshotgun"
	ammo_type = /obj/item/ammo_casing/shotgun
	max_shells = 12
	load_method = SINGLE_CASING


// wankersonofjerkin : Ryan Winz
// ---------------
/obj/item/weapon/gun/projectile/revolver/fluff/ryan_winz_revolver
	name = "Ryan's 'Devilgun'"
	desc = "You notice the serial number on the revolver is 666. The word 'Sin' is engraved on the blood-red wooden grip. Uses .357 ammo."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "ryan_winz"

/obj/item/weapon/gun/projectile/revolver/fluff/ryan_winz_revolver/redemption
	name = "Ryan's 'Redeemer'"
	desc = "You notice the serial number on the revolver is 667. The word 'Redemption' is engraved on dark rosewood grip. Uses .357 ammo."
// ---------------


// jertheace : Jeremiah 'Ace' Acacius
/obj/item/weapon/gun/projectile/shotgun/pump/unsc/fluff/ace
	name = "Ace's M45D Tactical Shotgun" // D-model holds half as many shells as the normal version so as not to be OP as shit. Better than shotgun, worse than cshotgun.
	desc = "Owned by the respected (or feared?) veteran Captain of VORE Station. Inscribed on the barrel are the words \"Speak softly, and carry a big stick.\" It has a folding stock so it can fit into bags."
	w_class = 3 // Because collapsable stock so it fits in backpacks.
	ammo_type = /obj/item/ammo_casing/shotgun/stunshell
	max_shells = 6
	load_method = SINGLE_CASING

/obj/item/weapon/gun/projectile/automatic/stg
	name = "\improper StG-650"
	desc = "Experience the terror of the Siegfried line, redone for the 26th century! With a fire rate of over 1,400 rounds, the Kaiser would be proud. Uses 7.92x33mm Kurz rounds."
	icon_state = "stg60"
	w_class = 3.0
	max_shells = 30
	caliber = "kurz"
	origin_tech = "combat=5;materials=2;syndicate=8"
	ammo_type = /obj/item/ammo_casing/stg
	magazine_type = /obj/item/ammo_magazine/stg
	load_method = MAGAZINE

/obj/item/weapon/gun/energy/gun/eluger
	name = "energy Luger"
	desc = "The finest sidearm produced by RauMauser, this pistol can punch a hole through inch thick steel plating. This ain't your great-grand-daddy's Luger! Can switch between stun and kill."
	icon_state = "elugerstun100"
	fire_sound = 'sound/weapons/Taser.ogg'
	item_state = "gun"
	charge_cost = 100 //How much energy is needed to fire.
	projectile_type = /obj/item/projectile/beam/stun
	modifystate = "elugerstun"

/obj/item/weapon/gun/energy/gun/eluger/attack_self(mob/living/user as mob) // Uses some custom sounds and custom projectiles, so we need this.
	switch(mode)
		if(0)
			mode = 1
			charge_cost = 100
			fire_sound = 'sound/weapons/eluger.ogg'
			user << "<span class='warning'>[src.name] is now set to kill.</span>"
			projectile_type = /obj/item/projectile/beam/eluger
			modifystate = "elugerkill"
		if(1)
			mode = 0
			charge_cost = 200
			fire_sound = 'sound/weapons/Taser.ogg'
			user << "<span class='warning'>[src.name] is now set to stun.</span>"
			projectile_type = /obj/item/projectile/beam/stun
			modifystate = "elugerstun"
	update_icon()
	update_held_icon()


//Ammo//

/obj/item/projectile/beam/eluger
	name = "Laser Beam"
	icon_state = "emitter"

/obj/item/ammo_casing/stg
	desc = "A 7.92×33mm Kurz casing."
	caliber = "kurz"
	projectile_type = /obj/item/projectile/bullet/rifle/a762


/obj/item/ammo_magazine/stg
	name = "box mag (7.92x33mm Kurz)"
	icon_state = "stg_30rnd"
	caliber = "kurz"
	ammo_type = /obj/item/ammo_casing/stg
	max_ammo = 30
	mag_type = MAGAZINE


/obj/item/ammo_magazine/stg/empty
	max_ammo = 0

/obj/item/ammo_casing/a95mm
	desc = "A 9.5x40mm bullet casing."
	caliber = "battlerifle"
	projectile_type = /obj/item/projectile/bullet/rifle/a762

/obj/item/ammo_magazine/battlerifle
	name = "box mag (9.5x40mm)"
	icon_state = "battlerifle"
	caliber = "battlerifle"
	ammo_type = /obj/item/ammo_casing/a95mm
	max_ammo = 36
	mag_type = MAGAZINE


/obj/item/ammo_magazine/battlerifle/empty
	max_ammo = 0
