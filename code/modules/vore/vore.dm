

// All living things can potentially eat you now!
/mob/living
	var/datum/voretype/vorifice = null // Default to no vore capability.
	// TODO - Rename this! It is too conflicty with belly.internal_contents
	var/list/internal_contents = list()

/mob/living/carbon
	var/digestable = 1	// Players get to decide if they are digestable or not  (TODO - Can we shoved this down to :human?)
						// Set to 1 so you are digestable by default

//
//	This is an "interface" type.  No instances of this type will exist, but any type which is supposed
//  to be vore capable should implement the vars and procs defined here to be vore-compatible!
/vore/pred_capable
	var/list/internal_contents
	var/datum/voretype/vorifice

//
//	Check if an object is capable of eating things.
//	For now this is just simple_animals and carbons
//
/proc/is_vore_predator(var/mob/O)
	return (O != null && (istype(O, /mob/living/simple_animal) || istype(O, /mob/living/carbon)) && O:vorifice)

//
//	Verb for toggling which orifice you eat people with!
//
/mob/living/carbon/human/proc/orifice_toggle()
	set name = "Choose Vore Mode"
	set category = "Vore"

	var/type = input("Choose Vore Mode") in list("Oral Vore", "Unbirth", "Anal Vore", "Cock Vore", "Breast Vore")
	// This is hard coded for now, but should be fixed later!
	vorifice = SINGLETON_VORETYPE_INSTANCES[type];

	// TODO LESHANA - This is bad!
	// Vorifice objects have no member vars, so are effectively immutable!
	// Given this, we shouldn't be creating new instances for every mob!  Instead we should have global singletons.
	// TODO - Implement this.  even better would be function pointers, but eh.
	src << "<span class='notice'>[vorifice.name] selected.</span>"

/mob/living/carbon/human/proc/vore_release()
	set name = "Release"
	set category = "Vore"
	var/releaseorifice = input("Choose Orifice") in list("Stomach (by Mouth)", "Stomach (by Anus)", "Womb", "Cock", "Breasts")

	// TODO LESHANA - This should all be refactored into procs on voretype that are overriden...
	switch(releaseorifice)
		if("Stomach (by Mouth)")
			var/datum/belly/belly = internal_contents["Stomach"]
			if (belly.release_all_contents())
				visible_message("<font color='green'><b>[src] hurls out the contents of their stomach!</b></font>")
				playsound(loc, 'sound/effects/splat.ogg', 50, 1)

		if("Stomach (by Anus)")
			var/datum/belly/belly = internal_contents["Stomach"]
			if (belly.release_all_contents())
				visible_message("<font color='green'><b>[src] releases their stomach contents out of their rear!</b></font>")
				playsound(loc, 'sound/effects/splat.ogg', 50, 1)

		if("Womb")
			var/datum/belly/belly = internal_contents["Womb"]
			if (belly.release_all_contents())
				visible_message("<font color='green'><b>[src] gushes out the contents of their womb!</b></font>")
				playsound(loc, 'sound/effects/splat.ogg', 50, 1)
			else if (belly.is_full)
				belly.is_full = 0
				visible_message("<span class='danger'>[src] gushes out a puddle of liquid from their folds!</span>")
				playsound(loc, 'sound/effects/splat.ogg', 50, 1)

		if("Cock")
			var/datum/belly/belly = internal_contents["Cock"]
			if (belly.release_all_contents())
				visible_message("<font color='green'><b>[src] splurts out the contents of their cock!</b></font>")
				playsound(loc, 'sound/effects/splat.ogg', 50, 1)
			else if (belly.is_full)
				belly.is_full = 0
				visible_message("<span class='danger'>[src] gushes out a puddle of cum from their cock!</span>")
				playsound(loc, 'sound/effects/splat.ogg', 50, 1)

		if("Breasts")
			var/datum/belly/belly = internal_contents["Boob"]
			if (belly.release_all_contents())
				visible_message("<font color='green'><b>[src] squirts out the contents of their breasts!</b></font>")
				playsound(loc, 'sound/effects/splat.ogg', 50, 1)
			else if(belly.is_full)
				belly.is_full = 0
				visible_message("<span class='danger'>[src] squirts out a puddle of milk from their breasts!</span>")
				playsound(loc, 'sound/effects/splat.ogg', 50, 1)

/////////////////////////////
//// NW's emergency code ////
/////////////////////////////

/mob/living/proc/escapeOOC()
	set name = "OOC escape"
	set category = "Vore"

	var/confirm = alert(src, "This button is for escaping from your partner if they have disconnected or your preferences are being violated. Do not use it for anything else!", "Confirmation", "Okay", "Cancel")

	if(confirm == "Cancel")
		return

	else if(confirm == "Okay")
		if(iscarbon(loc) || isanimal(loc))
			message_admins("[key_name(src)] used the OOC escape button to get out of [loc] ([loc ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>" : "null"])")
			// TODO - Properly escape with updating internal_contents
			src.loc = get_turf(src.loc)

		else
			src << "<span class='alert'>You aren't inside anyone, you clod.</span>"

/////////////////////////
/// NW's Inside Panel ///
/////////////////////////

/mob/living/carbon/human/proc/insidePanel() //mob/user as mob)
	set name = "Inside"
	set category = "Vore"

	var/datum/vore_look/picker_holder = new()
	picker_holder.loop=picker_holder

	var/dat = picker_holder.gen_ui(src)

	picker_holder.popup = new(src, "insidePanel","Inside!", 700, 400, picker_holder)
	picker_holder.popup.set_content(dat)
	picker_holder.popup.open()

//
// Callback Handler for the Inside form
//
/datum/vore_look
	var/datum/browser/popup
	var/loop = null;  // Magic self-reference to stop the handler from being GC'd before user takes action.
/datum/vore_look/Topic(href,href_list[])
	if (ui_interact(href, href_list))
		popup.set_content(gen_ui(usr))
		usr << output(popup.get_content(), "insidePanel.browser")

/datum/vore_look/proc/gen_ui(var/mob/living/carbon/human/user)
	var/dat
	if (is_vore_predator(user.loc))
		var/vore/pred_capable/eater = user.loc
		var/datum/belly/inside_belly		// Which of predator's bellies are we inside?

		//This big block here figures out where the prey is
		for (var/bellytype in eater.internal_contents)
			var/datum/belly/B = eater.internal_contents[bellytype]
			for (var/mob/living/M in B.internal_contents)
				if (M == user)
					inside_belly = B
					break
		// ASSERT(inside_belly != null) // Make sure we actually found ourselves.

		dat += "<font color = 'green'>You are currently inside</font> <font color = 'yellow'>[eater]'s</font> <font color = 'red'>[inside_belly.belly_name]</font>!<br><br>"
		dat += "[inside_belly.inside_flavor]<br><br>"
		if (inside_belly.internal_contents.len > 0)
			dat += "<font color = 'green'>You can see the following around you:</font><br>"
			for (var/atom/movable/M in inside_belly.internal_contents)
				if(M != user) dat += "[M] <a href='?src=\ref[src];look=\ref[M]'>Examine</a> <a href='?src=\ref[src];helpout=\ref[M]'>Help out</a><br>"
		dat += "<br>"
	else
		dat += "You aren't inside anyone.<br><br>"

	// List people inside you
	dat += "<font color = 'purple'><b><center>Contents</center></b></font><br>"
	for (var/bellytype in user.internal_contents)
		var/datum/belly/belly = user.internal_contents[bellytype]
		var/inside_count = 0
		dat += "<font color = 'green'>[belly.belly_type] </font> <a href='?src=\ref[src];toggle_digestion=\ref[belly]'>Digestion: [belly.digest_mode]</a><br>"
		for (var/atom/movable/M in belly.internal_contents)
			dat += "[M] <a href='?src=\ref[src];look=\ref[M]'>Examine</a> <br>"
			inside_count += 1
		if (inside_count == 0)
			dat += "You have not consumed anything<br>"

	// Offer flavor text customization options
	dat += "<font color = 'purple'><b><center>Customisation options</center></b></font><br><br>"
	for (var/bellytype in user.internal_contents)
		var/datum/belly/belly = user.internal_contents[bellytype]
		dat += "<b>[belly.belly_type]</b><br>[belly.inside_flavor] <a href='?src=\ref[src];set_description=\ref[belly]'>Change text</a><br>"

	return dat;

/datum/vore_look/proc/ui_interact(href, href_list)
	log_debug("vore_look.Topic([href])")
	if(href_list["look"])
		// TODO - This probably should be ATOM not mob/living
		var/mob/living/subj=locate(href_list["look"])
		subj.examine(usr)

	if(href_list["helpout"])
		var/mob/living/subj=locate(href_list["helpout"])
		var/mob/living/eater = usr.loc
		usr << "<font color='green'>You begin to push [subj] to freedom!</font>"
		subj << "[usr] begins to push you to freedom!"
		eater << "<span class='warning'>Someone is trying to escape from inside you!<span>"
		sleep(50)
		if(prob(33))
			// TODO - Properly escape with updating internal_contents
			subj.loc = eater.loc
			usr << "<font color='green'>You manage to help [subj] to safety!</font>"
			subj << "<font color='green'>[usr] pushes you free!</font>"
			eater << "<span class='alert'>[subj] forces free of the confines of your body!</span>"
		else
			usr << "<span class='alert'>[subj] slips back down inside despite your efforts.</span>"
			subj << "<span class='alert'> Even with [usr]'s help, you slip back inside again.</span>"
			eater << "<font color='green'>Your body efficiently shoves [subj] back where they belong.</font>"

	if(href_list["set_description"])
		var/datum/belly/B = locate(href_list["set_description"])
		B.inside_flavor = input(usr, "Input a new flavor text!", "[B.belly_type] flavor text", B.inside_flavor) as message
		return 1 // TODO Will this make it refresh the ui?

	if (href_list["toggle_digestion"])
		var/datum/belly/B = locate(href_list["toggle_digestion"])
		B.toggle_digestion()
		return 1 // TODO Will this make it refresh the ui?

	if (href_list["close"])
		del(src)  // Cleanup

/mob/living/carbon/human/proc/I_am_not_mad()
	set name = "Toggle digestability"
	set category = "Vore"

	if(alert(src, "This button is for those who don't like being digested. It will make you undigestable. Don't abuse this button by toggling it back and forth to extend a scene or whatever, or you'll make the admins cry. Note that this cannot be toggled inside someone's belly.", "", "Okay", "Cancel") == "Okay")
		digestable = !digestable
		usr << "<span class='alert'>You are [digestable ?  "now" : "no longer"] digestable.</span>"
		message_admins("[key_name(src)] toggled their digestability to [digestable] ([loc ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>" : "null"])")
