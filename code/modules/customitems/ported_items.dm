/*

Everything in this file is from the old VORE station, and has not been properly sorted into correct files yet.
Move everything here to appropriate files when possible. This is just to bring it all in and ensure it works.

Some stuff needs to be converted for the current code and has been commented out. Voidsuits especially.

*/

// UNSC Stuff


/*
/obj/item/clothing/suit/armor/hosnavycoat/tan
	name = "\improper commander's jacket"
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"Commander\"."
	icon_state = "hostanjacket"
	item_state = "johnny_coat"
*/

/*
/obj/item/clothing/head/helmet/space/void/ert/odst
	name = "\improper ODST Helmet"
	desc = "<i>\"... we are glad to plunge feet first into hell in the knowledge that we will rise.\"</i>"
	armor = list(melee = 50, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 60)
	icon_state = "void0-odst"
	item_state = "swat_hel" //Placeholder
	item_color = "odst"

/obj/item/clothing/head/helmet/space/void/ert/odst/attack_self(mob/user)
	if(camera)
		..(user)
	else
		camera = new /obj/machinery/camera(src)
		camera.network = list("SS13")
		cameranet.removeCamera(camera)
		camera.c_tag = "TacCam ODST - [user.name]"
		user << "\blue User scanned as [camera.c_tag]. Camera activated."

/obj/item/clothing/head/helmet/space/void/ert/odst/jertheace
	name = "\improper Ace's ODST Helmet"
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "void0-odst_ace"
	item_color = "odst_ace"
	desc = "Etched under the inner visor is the phrase \"Don’t let your past define you; let it mold you into the person you want to be.\""

/obj/item/clothing/suit/space/void/ert/odst
	name = "ODST Armor"
	desc = "<i>\"... we are glad to plunge feet first into hell in the knowledge that we will rise.\"</i>"
	icon_state = "odst"
	item_state = "swat_suit" // Placeholder
*/

// Nazi stuff.

/*
/obj/item/clothing/head/helmet/space/void/security/nazi
	name = "\improper Raumhelm"
	desc = "A Raumpanzeranzughelm with additional Panzerungsschicht. Not only does it protect you from the Vakuum des Raum, but also akuter Bleivergiftung."
	icon_state = "void0-nazi"
	item_state = "r_head"
	item_color = "nazi"

/obj/item/clothing/suit/space/void/security/nazi
	name = "\improper Raumpanzeranzug"
	desc = "A Raumpanzeranzug with additional Panzerungsschicht. Not only does it protect you from the Vakuum des Raum, but also akuter Bleivergiftung."
	icon_state = "void-nazi"
//	item_state = "void-nazi"
*/

//Soviet Stuff
/*
/obj/item/clothing/head/helmet/space/void/security/soviet
	name = "\improper Soviet hardsuit helmet"
	desc = "To survive harsh cold of space, you must wear helmet as thick as iron curtain! Luckily, Soviet engineering has knack for this..."
	icon_state = "void0-soviet"
//	item_state = "void0-soviet"
	item_color = "soviet"

/obj/item/clothing/suit/space/void/security/soviet
	name = "\improper Soviet hardsuit"
	desc = "To survive harsh cold of space, you must don armor as thick as iron curtain! Luckily, Soviet engineering has knack for this..."
	icon_state = "void-soviet"
	item_state = "syndie_hardsuit"

// Red Faction hardsuit.
/obj/item/clothing/head/helmet/space/void/mining/red
	name = "Soviet mining hardsuit helmet"
	desc = "Better Red than dead!"
	icon_state = "rig0-RedMiner"
	item_state = "RedMiner_helm"
	item_color = "RedMiner"

/obj/item/clothing/suit/space/void/mining/red
	icon_state = "rig-mining"
	name = "Soviet mining hardsuit"
	desc = "Better Red than dead!"
	icon_state = "rig-RedMiner"
	item_state = "RedMining_hardsuit"
*/