/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "Standard Security gear. Protects the head from impacts."
	icon_state = "helmet"
	flags = HEADCOVERSEYES | THICKMATERIAL
	item_state = "helmet"
	armor = list(melee = 50, bullet = 15, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = 3

/obj/item/clothing/head/helmet/warden
	name = "warden's hat"
	desc = "It's a special helmet issued to the Warden of a securiy force. Protects the head from impacts."
	icon_state = "policehelm"
	flags_inv = 0
	body_parts_covered = 0

/obj/item/clothing/head/helmet/hop
	name = "crew resource's hat"
	desc = "A stylish hat that both protects you from enraged former-crewmembers and gives you a false sense of authority."
	icon_state = "hopcap"
	flags_inv = 0
	body_parts_covered = 0

/*  Looks like the Nazi hat. Commented out until a better icon is made. Apparently Bay added this. It doesn't even match the Captain's parade outfit.
	Furthermore, why the fuck is this a helmet? -Ace
/obj/item/clothing/head/helmet/formalcaptain
	name = "parade hat"
	desc = "No one in a commanding position should be without a perfect, white hat of ultimate authority."
	icon_state = "officercap"
	flags_inv = 0
	body_parts_covered = 0
*/

/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	desc = "It's a helmet specifically designed to protect against close range attacks."
	icon_state = "riot"
	item_state = "helmet"
	flags = HEADCOVERSEYES
	armor = list(melee = 82, bullet = 15, laser = 5,energy = 5, bomb = 5, bio = 2, rad = 0)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7

/obj/item/clothing/head/helmet/swat
	name = "\improper SWAT helmet"
	desc = "They're often used by highly trained Swat Members."
	icon_state = "swat"
	flags = HEADCOVERSEYES
	item_state = "swat"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5

/obj/item/clothing/head/helmet/thunderdome
	name = "\improper Thunderdome helmet"
	desc = "<i>'Let the battle commence!'</i>"
	icon_state = "thunderdome"
	flags = HEADCOVERSEYES
	item_state = "thunderdome"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 10, bomb = 25, bio = 10, rad = 0)
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/gladiator
	name = "gladiator helmet"
	desc = "Ave, Imperator, morituri te salutant."
	icon_state = "gladiator"
	flags = HEADCOVERSEYES|HEADCOVERSMOUTH|BLOCKHAIR
	item_state = "gladiator"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/tactical //temporary suits.
	name = "tactical helmet"
	desc = "An armored helmet capable of being fitted with a multitude of attachments."
	icon_state = "swathelm"
	item_state = "swat_hel"
	flags = HEADCOVERSEYES
	sprite_sheets = list( // These are here because these species have faces which wouldn't normally fit in these.
		"Tajara" = 'icons/mob/species/tajaran/helmet.dmi',
		"Unathi" = 'icons/mob/species/unathi/helmet.dmi',
		"Sergal" = 'icons/mob/species/sergal/helmet.dmi',
		"Akula" = 'icons/mob/species/akula/helmet.dmi',
		)
	armor = list(melee = 62, bullet = 50, laser = 50,energy = 35, bomb = 10, bio = 2, rad = 0)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7

//UNSC
/obj/item/clothing/head/helmet/tactical/unsc
	name = "\improper CH252 helmet"
	desc = "If you wanna to keep your brain inside your head, you'd best put this on!"
	icon_state = "unsc_helm"
	sprite_sheets = null

//Nazi
/obj/item/clothing/head/helmet/nazi
	name = "\improper Stalhelm"
	desc = "The archetypical symbol for miltary tyranny; this humble-looking steel pot protects against everything from bullets and shrapnel to the occasional loosed Bierglas. Unterseiten oben!"
	icon_state = "stalhelm"
	item_state = "helmet"
	armor = list(melee = 10, bullet = 50, laser = 0, energy = 0, bomb = 20, bio = 0, rad = 10)

// USCM
// Tecnhically these don't belong here in this file but they don't make sense elsewhere.
/obj/item/weapon/storage/helmet/m10 // I had to put it in this directory because otherwise it's a lot of needless code. -Ace
	name = "\improper M10 Ballistic Helmet"
	desc = "A ballistic helmet used primarily by the United States Colonial Marine Corps. It has a mounted camera. You could probably carry a pack of cigarettes in the strap."
	icon = 'icons/obj/clothing/hats.dmi'
	item_color = "m10_pbh"
	icon_state = "m10_pbh"
	item_state = "helmet"
	body_parts_covered = HEAD
	slot_flags = SLOT_HEAD
	storage_slots = 1
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 35, bomb = 10, bio = 2, rad = 0)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7
	can_hold = list("/obj/item/weapon/storage/fancy/cigarettes")
	var/obj/machinery/camera/camera

	attack_self(mob/user)
		if(camera)
			..(user)
		else
			camera = new /obj/machinery/camera(src)
			camera.network = list("SS13")
			cameranet.removeCamera(camera)
			camera.c_tag = "TacCam M10 - [user.name]"
			user << "\blue User scanned as [camera.c_tag]. Camera activated."

	update_icon()
		if(contents.len)
			if (icon_state == "m10_pbh")
				icon_state = "m10_pbh_cig"
			if (icon_state == "m10_pbh_d_camo")
				icon_state = "m10_pbh_d_camo_cig"
		else
			if (icon_state == "m10_pbh_cig")
				icon_state = "m10_pbh"
			if (icon_state == "m10_pbh_d_camo_cig")
				icon_state = "m10_pbh_d_camo"
		usr.update_inv_head()


/obj/item/weapon/storage/helmet/m10/camo
	item_color = "m10_pbh_d_camo"
	icon_state = "m10_pbh_d_camo"

/obj/item/clothing/head/helmet/augment
	name = "Augment Array"
	desc = "A helmet with optical and cranial augments coupled to it."
	icon_state = "v62"
	flags = HEADCOVERSEYES
	item_state = "v62"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5

//Non-hardsuit ERT helmets.
/obj/item/clothing/head/helmet/ert
	name = "emergency response team helmet"
	desc = "An in-atmosphere helmet worn by members of the NanoTrasen Emergency Response Team. Protects the head from impacts."
	icon_state = "erthelmet_cmd"
	item_state = "syndicate-helm-green"
	armor = list(melee = 62, bullet = 50, laser = 50,energy = 35, bomb = 10, bio = 2, rad = 0)

//Commander
/obj/item/clothing/head/helmet/ert/command
	name = "emergency response team commander helmet"
	desc = "An in-atmosphere helmet worn by the commander of a NanoTrasen Emergency Response Team. Has blue highlights."

//Security
/obj/item/clothing/head/helmet/ert/security
	name = "emergency response team security helmet"
	desc = "An in-atmosphere helmet worn by security members of the NanoTrasen Emergency Response Team. Has red highlights."
	icon_state = "erthelmet_sec"

//Engineer
/obj/item/clothing/head/helmet/ert/engineer
	name = "emergency response team engineer helmet"
	desc = "An in-atmosphere helmet worn by engineering members of the NanoTrasen Emergency Response Team. Has orange highlights."
	icon_state = "erthelmet_eng"

//Medical
/obj/item/clothing/head/helmet/ert/medical
	name = "emergency response team medical helmet"
	desc = "A set of armor worn by medical members of the NanoTrasen Emergency Response Team. Has red and white highlights."
	icon_state = "erthelmet_med"