#define MODKIT_HELMET 1
#define MODKIT_SUIT 2
#define MODKIT_FULL 3

/obj/item/device/modkit
	name = "hardsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a hardsuit for another user."
	icon_state = "modkit"
	var/parts = MODKIT_FULL
	var/target_species = "Human"

	var/list/permitted_types = list(
		/obj/item/clothing/head/helmet/space/void,
		/obj/item/clothing/suit/space/void
		)

/obj/item/device/modkit/afterattack(obj/O, mob/user as mob, proximity)
	if(!proximity)
		return

	if (!target_species)
		return	//it shouldn't be null, okay?

	if(!parts)
		user << "<span class='warning'>This kit has no parts for this modification left.</span>"
		user.drop_from_inventory(src)
		del(src)
		return

	var/allowed = 0
	for (var/permitted_type in permitted_types)
		if(istype(O, permitted_type))
			allowed = 1

	var/obj/item/clothing/I = O
	if (!istype(I) || !allowed)
		user << "<span class='notice'>[src] is unable to modify that.</span>"
		return

	var/excluding = ("exclude" in I.species_restricted)
	var/in_list = (target_species in I.species_restricted)
	if (excluding ^ in_list)
		user << "<span class='notice'>[I] is already modified.</span>"
		return

	if(!isturf(O.loc))
		user << "<span class='warning'>[O] must be safely placed on the ground for modification.</span>"
		return

	playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)

	user.visible_message("\red [user] opens \the [src] and modifies \the [O].","\red You open \the [src] and modify \the [O].")

	I.refit_for_species(target_species)

	if (istype(I, /obj/item/clothing/head/helmet))
		parts &= ~MODKIT_HELMET
	if (istype(I, /obj/item/clothing/suit))
		parts &= ~MODKIT_SUIT

	if(!parts)
		user.drop_from_inventory(src)
		del(src)

/obj/item/device/modkit/examine(mob/user)
	..(user)
	user << "It looks as though it modifies hardsuits to fit [target_species] users."

/obj/item/device/modkit/tajaran
	name = "tajaran hardsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a hardsuit for another user. This one looks like it's meant for Tajaran."
	target_species = "Tajara"



/obj/item/device/modkit_conversion //this is the old one, wich allows you to change from one object to another, instead of just changing races allowed.
	name = "Orbis modification kit"
	desc = "A kit containing all the needed tools and parts to modify an object into another."
	icon_state = "modkit"
	var/parts = MODKIT_FULL
	var/from_helmet = /obj/item/clothing/head/helmet/space/void
	var/from_suit = /obj/item/clothing/suit/space/void
	var/to_helmet = /obj/item/clothing/head/cardborg
	var/to_suit = /obj/item/clothing/suit/cardborg

/obj/item/device/modkit_conversion/afterattack(obj/O, mob/user as mob)
	var/flag
	var/to_type
	if(istype(O,from_helmet))
		flag = MODKIT_HELMET
		to_type = to_helmet
	else if(istype(O,from_suit))
		flag = MODKIT_SUIT
		to_type = to_suit
	else
		return
	if(!(parts & flag))
		user << "<span class='warning'>This kit has no parts for this modification left.</span>"
		return
	if(istype(O,to_type))
		user << "<span class='notice'>[O] is already modified.</span>"
		return
	if(!isturf(O.loc))
		user << "<span class='warning'>[O] must be safely placed on the ground for modification.</span>"
		return
	playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)
	var/N = new to_type(O.loc)
	user.visible_message("\red [user] opens \the [src] and modifies \the [O] into \the [N].","\red You open \the [src] and modify \the [O] into \the [N].")
	del(O)
	parts &= ~flag
	if(!parts)
		del(src)

/obj/item/device/modkit_single
	name = "item modification kit"
	desc = "A kit containing all the needed tools and parts to modify an item to resemble another item."
	icon_state = "modkit"
	var/from_object = /obj/item/clothing/head/helmet/space/void
	var/to_object = /obj/item/clothing/suit/cardborg

/obj/item/device/modkit_single/afterattack(obj/O, mob/user as mob)
	var/to_type
	if(istype(O,to_object))
		user << "<span class='notice'>[O] is already modified.</span>"
		return
	if(!istype(O,from_object))
		user << "<span class='warning'>[O] isn't something you can modify with this kit.</span>"
		return
	if(!isturf(O.loc))
		user << "<span class='warning'>[O] must be safely placed on the ground for modification.</span>"
		return
	if(istype(O,from_object))
		to_type = to_object
		playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		var/N = new to_type(O.loc)
		user.visible_message("\red [user] modifies \the [src] and turns \the [O] into \the [N].","\red You modify \the [src] and turn \the [O] into \the [N].")
		del(O)
		del(src)

// United States Colonial Marines helmet repainting kits.
// This is hacky and bad. What I should be doing is changing their icon states and nothing else. This could delete items currently held by the objects in question.
// ToDo: Make a proper repainting kit for items. See PDA_mods.dm
// Do not make more of these. They're terrible.
/obj/item/device/modkit_single/uscm/helmet
	name = "M10 helmet paint kit (green)"
	desc = "A kit used to paint an M10 helmet olive green."
	from_object = /obj/item/weapon/storage/helmet/m10
	to_object = /obj/item/weapon/storage/helmet/m10

/obj/item/device/modkit_single/uscm/helmet/camo
	name = "M10 helmet paint kit (camo)"
	desc = "A kit used to paint an M10 helmet with desert camo."
	from_object = /obj/item/weapon/storage/helmet/m10
	to_object = /obj/item/weapon/storage/helmet/m10/camo

/obj/item/device/modkit_single/uscm/m3
	name = "M3 armor paint removal kit"
	desc = "A paint kit used to restore a suit of M3 armor and helmet to standard olive green."
	from_object = /obj/item/clothing/suit/armor/tactical/m3
	to_object = /obj/item/clothing/suit/armor/tactical/m3

/obj/item/device/modkit_single/uscm/m3/nco
	name = "M3 armor paint kit (NCO)"
	desc = "A paint kit for the markings of a non-commissioned officer on a suit of M3 armor."
	from_object = /obj/item/clothing/suit/armor/tactical/m3
	to_object = /obj/item/clothing/suit/armor/tactical/m3/nco

/obj/item/device/modkit_single/uscm/m3/medic
	name = "M3 armor paint kit (medic)"
	desc = "A paint kit for the markings of a medic on a suit of M3 armor."
	from_object = /obj/item/clothing/suit/armor/tactical/m3
	to_object = /obj/item/clothing/suit/armor/tactical/m3/medic

/obj/item/device/modkit_single/uscm/m3/engineer
	name = "M3 armor paint kit (engineer)"
	desc = "A paint kit for the markings of a combat engineer on a suit of M3 armor."
	from_object = /obj/item/clothing/suit/armor/tactical/m3
	to_object = /obj/item/clothing/suit/armor/tactical/m3/engineer