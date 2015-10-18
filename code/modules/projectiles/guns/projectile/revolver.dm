/obj/item/weapon/gun/projectile/revolver
	name = "revolver"
	desc = "A classic revolver. Uses .357 ammo."
	icon_state = "revolver"
	item_state = "revolver"
	caliber = "357"
	origin_tech = "combat=2;materials=2"
	fire_sound = 'sound/weapons/pistol.ogg'
	handle_casings = CYCLE_CASINGS
	max_shells = 6
	ammo_type = /obj/item/ammo_casing/a357

/obj/item/weapon/gun/projectile/revolver/mateba
	name = "\improper Mateba Autorevolver"
	desc = "This unique looking handgun is named after an Italian company famous for the manufacture of these revolvers, and pasta kneading machines. Uses .357 ammo."
	icon_state = "mateba"
	origin_tech = "combat=2;materials=2"

/obj/item/weapon/gun/projectile/revolver/shotgun
	name = "\"The Judge\""
	desc = "A revolving hand-shotgun by Cybersun Industries that packs the power of a 12 guage in the palm of your hand. It's never been easier to be Judge, Jury, and Executioner. Uses shotgun ammo."
	icon_state = "judge"
	caliber = "shotgun"
	max_shells = 5
	w_class = 3
	recoil = 2 // Kicks like a mule.
	accuracy = -1 // You know damn well why.
	origin_tech = "combat=4;materials=3;syndicate=4"
	ammo_type = /obj/item/ammo_casing/shotgun

/obj/item/weapon/gun/projectile/revolver/detective
	name = "revolver"
	desc = "A cheap Martian knock-off of a Smith & Wesson Model 10. Uses .38-Special ammo."
	icon_state = "detective"
	max_shells = 6
	caliber = "38"
	origin_tech = "combat=2;materials=2"
	ammo_type = /obj/item/ammo_casing/c38

/obj/item/weapon/gun/projectile/revolver/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Click to rename your gun. If you're the detective."

	var/mob/M = usr
	if(!M.mind)	return 0
	if(!M.mind.assigned_role == "Detective")
		M << "<span class='notice'>You don't feel cool enough to name this gun, chump.</span>"
		return 0

	var/input = stripped_input(usr,"What do you want to name the gun?", ,"", MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		name = input
		M << "You name the gun [input]. Say hello to your new friend."
		return 1

/obj/item/weapon/gun/projectile/revolver/derringer
	name = "\improper Derringer"
	desc = "It's not size that matters. Just the caliber of your load. Uses .357 ammo."
	icon_state = "derringer"
	item_state = "concealed" // A deliberately blank icon for extra stealthy.
	max_shells = 2
	w_class = 2
	accuracy = -2
	origin_tech = "combat=2;syndicate=2"
	ammo_type = /obj/item/ammo_casing/a357