/mob/living/carbon
	var/vorifice = "Oral Vore"

/mob/living/carbon/human/proc/endo_toggle()
	set name = "Toggle Stomach Digestion"
	set category = "Vore"

	stendo = !stendo //invert
	switch(stendo)
		if(0)	src << "<span class='notice'>You will no longer digest people in your stomach.</span>"
		if(1)	src << "<span class='notice'>You will now digest people in your stomach.</span>"

/mob/living/carbon/human/proc/cvendo_toggle()
	set name = "Toggle Cockvore Digestion"
	set category = "Vore"

	cvendo = !cvendo
	switch(cvendo)
		if(0)	src << "<span class='notice'>You will no longer cummify people.</span>"
		if(1)	src << "<span class='notice'>You will now cummify people.</span>"

/mob/living/carbon/human/proc/bvendo_toggle()
	set name = "Toggle Breastvore Digestion"
	set category = "Vore"

	bvendo = !bvendo

	switch(vendo)
		if(0)	src << "<span class='notice'>You will no longer milkify people.</span>"
		if(1)	src << "<span class='notice'>You will now milkify people.</span>"

/mob/living/carbon/human/proc/womb_toggle()
	set name = "Set Womb Mode"
	set category = "Vore"
	wombheal = input("Womb Mode") in list("Hold","Heal","Transform (Male)","Transform (Female)","Transform (Keep Gender)","Transform (Change Species)","Digest")
	switch(wombheal)
		if("Heal")
			src << "<span class='notice'>You will now heal people you've unbirthed.</span>"
		if("Digest")
			src << "<span class='notice'>You will now digest people you've unbirthed.</span>"
		if("Hold")
			src << "<span class='notice'>You will now harmlessly hold people you've unbirthed.</span>"
		if("Transform (Male)")
			src << "<span class='notice'>You will now transform people you've unbirthed into your son.</span>"
		if("Transform (Female)")
			src << "<span class='notice'>You will now transform people you've unbirthed into your daughter.</span>"
		if("Transform (Keep Gender)")
			src << "<span class='notice'>You will now transform people you've unbirthed, but they will keep their gender.</span>"
		if("Transform (Change Species)")
			src << "<span class='notice'>You will now transform people you've unbirthed to look similar to your species.</span>"

/mob/living/carbon/human/proc/orifice_toggle()
	set name = "Choose Vore Mode"
	set category = "Vore"
	vorifice = input("Choose Vore Mode") in list("Oral Vore","Unbirth","Anal Vore","Cock Vore","Breast Vore")
	src << "<span class='notice'>[vorifice] selected.</span>"
//////////////////////////////////////////
/// NW's digestion toggle optimisation ///
//////////////////////////////////////////

/mob/living/carbon/human/proc/All_Digestion_Toggles()
	set name = "Digestion Toggles"
	set category = "Vore"
	var/digestzone = input("Choose Organ") in list("Stomach","Cock","Breasts","Womb")

	switch(digestzone)
		if("Stomach")
			endo_toggle()
		if("Cock")
			cvendo_toggle()
		if("Breasts")
			vendo_toggle()
		if("Womb")
			womb_toggle()


/mob/living/carbon/human/proc/vore_release()
	set name = "Release"
	set category = "Vore"
	var/releaseorifice = input("Choose Orifice") in list("Stomach (by Mouth)","Stomach (by Anus)","Womb","Cock","Breasts")

	switch(releaseorfice)
		if("Stomach (by Mouth)")
			if(stomach_contents.len)
				for(var/mob/M in stomach_contents)

					M.loc = src.loc //this is specifically defined as src.loc to try to prevent a mob from ending up in nullspace by byond confusion
					stomach_contents.Remove(M)

					if(iscarbon(src.loc)) //This makes sure that the mob behaves properly if released into another mob
						var/mob/living/carbon/loc_mob = src.loc

						if(src in loc_mob.stomach_contents)
							loc_mob.stomach_contents += M
						if(src in loc_mob.womb_contents)
							loc_mob.womb_contents += M
						if(src in loc_mob.cock_contents)
							loc_mob.cock_contents += M
						if(src in loc_mob.boob_contents)
							loc_mob.boob_contents += M

				visible_message("<font color='green'><b>[src] hurls out the contents of their stomach!</b></font>")
				playsound(loc, 'sound/effects/splat.ogg', 50, 1)

		if("Stomach (by Anus)")
			if(stomach_contents.len)
				for(var/mob/M in stomach_contents)

					M.loc = src.loc
					stomach_contents.Remove(M)

					if(iscarbon(src.loc))
						var/mob/living/carbon/loc_mob = src.loc

						if(src in loc_mob.stomach_contents)
							loc_mob.stomach_contents += M
						if(src in loc_mob.womb_contents)
							loc_mob.womb_contents += M
						if(src in loc_mob.cock_contents)
							loc_mob.cock_contents += M
						if(src in loc_mob.boob_contents)
							loc_mob.boob_contents += M

				visible_message("<font color='green'><b>[src] releases their stomach contents out of their rear!</b></font>")
				playsound(loc, 'sound/effects/splat.ogg', 50, 1)

		if("Womb")
			if(womb_contents.len)
				for(var/mob/M in womb_contents)

					M.loc = src.loc
					womb_contents.Remove(M)

					if(iscarbon(src.loc))
						var/mob/living/carbon/loc_mob = src.loc

						if(src in loc_mob.stomach_contents)
							loc_mob.stomach_contents += M
						if(src in loc_mob.womb_contents)
							loc_mob.womb_contents += M
						if(src in loc_mob.cock_contents)
							loc_mob.cock_contents += M
						if(src in loc_mob.boob_contents)
							loc_mob.boob_contents += M

				visible_message("<font color='green'><b>[src] gushes out the contents of their womb!</b></font>")
				playsound(loc, 'sound/effects/splat.ogg', 50, 1)

			else
				if(wombfull) //checks if true. If it's anything but 0, null, or "", it will set to 0.
					wombfull = 0
					visible_message("<span class='danger'>[src] gushes out a puddle of liquid from their folds!</span>")
					playsound(loc, 'sound/effects/splat.ogg', 50, 1)

		if("Cock")
			if(cock_contents.len)
				for(var/mob/M in cock_contents)

					M.loc = src.loc
					cock_contents.Remove(M)

					if(iscarbon(src.loc))
						var/mob/living/carbon/loc_mob = src.loc

						if(src in loc_mob.stomach_contents)
							loc_mob.stomach_contents += M
						if(src in loc_mob.womb_contents)
							loc_mob.womb_contents += M
						if(src in loc_mob.cock_contents)
							loc_mob.cock_contents += M
						if(src in loc_mob.boob_contents)
							loc_mob.boob_contents += M

				visible_message("<font color='green'><b>[src] splurts out the contents of their cock!</b></font>")
				playsound(loc, 'sound/effects/splat.ogg', 50, 1)

			else
				if(cockfull)
					cockfull = 0
					visible_message("<span class='danger'>[src] gushes out a puddle of cum from their cock!</span>")
					playsound(loc, 'sound/effects/splat.ogg', 50, 1)

		if("Breasts")
			if(boob_contents.len)
				for(var/mob/M in boob_contents)

					M.loc = src.loc
					boob_contents.Remove(M)

					if(iscarbon(src.loc))
						var/mob/living/carbon/loc_mob = src.loc

						if(src in loc_mob.stomach_contents)
							loc_mob.stomach_contents += M
						if(src in loc_mob.womb_contents)
							loc_mob.womb_contents += M
						if(src in loc_mob.cock_contents)
							loc_mob.cock_contents += M
						if(src in loc_mob.boob_contents)
							loc_mob.boob_contents += M

				visible_message("<font color='green'><b>[src] squirts out the contents of their breasts!</b></font>")
				playsound(loc, 'sound/effects/splat.ogg', 50, 1)

			else
				if(boobfull)
					boobfull = 0
					visible_message("<span class='danger'>[src] squirts out a puddle of milk from their breasts!</span>")
					playsound(loc, 'sound/effects/splat.ogg', 50, 1)


/////////////////////////////
//// NW's emergency code ////
/////////////////////////////

/mob/living/proc/escapeOOC()
	set name = "OOC escape"
	set category = "Vore"

	var/confirm = alert(src, "This button is for escaping from your partner if they have disconnected or your preferences are being violated. Do not use it for anything else!", "Confirmation", "Okay", "Cancel")

	if(confirm == "Cancel")	return

	else if(confirm == "Okay")
		if(iscarbon(loc) || isanimal(loc))
			msg_admin_attack("[key_name(src)] used the OOC escape button to get out of [loc]")
			src.loc = get_turf(src.loc)

		else
			src << "<span class='alert'>You aren't inside anyone, you clod.</span>"

/////////////////////////
/// NW's Inside Panel ///
/////////////////////////

/mob/living/carbon/human/proc/insidePanel() //mob/user as mob)
	set name = "Inside"
	set category = "Vore"

	var/datum/vore_look/picker_holder=new()
	picker_holder.loop=picker_holder

	var/dat
	if(istype(src.loc,/mob/living/carbon/human))
		var/mob/living/carbon/human/eater = src.loc
		// This big block here figures out where the prey is
		for(var/mob/living/M in eater.stomach_contents)
			if(M == src) src.predlocation = "stomach"
		for(var/mob/living/M in eater.cock_contents)
			if(M == src) src.predlocation = "balls"
		for(var/mob/living/M in eater.womb_contents)
			if(M == src) src.predlocation = "womb"
		for(var/mob/living/M in eater.boob_contents)
			if(M == src) src.predlocation = "breast"
		// Done
		dat += "<font color = 'green'>You are currently inside</font> <font color = 'yellow'>[eater]'s</font> <font color = 'red'>[src.predlocation]</font>!<br><br>"
		if(src.predlocation == "stomach")
			if(!eater.insideflavour[1])
				eater.insideflavour[1] = "There is nothing interesting about this stomach."
			dat += "[eater.insideflavour[1]]<br><br>"
			dat += "<font color = 'green'>You can see the following people around you:</font><br>"
			for(var/mob/living/M in eater.stomach_contents)
				if(M != src) dat += "[M] <a href='?src=\ref[picker_holder];look=\ref[M]'>Examine</a> <a href='?src=\ref[picker_holder];helpout=\ref[M]'>Help out</a><br>"
		if(src.predlocation == "balls")
			if(!eater.insideflavour[2])
				eater.insideflavour[2] = "Generic sac description"
			dat += "[eater.insideflavour[2]]<br><br>"
			dat += "<font color = 'green'>You can see the following people around you:</font><br>"
			for(var/mob/living/M in eater.cock_contents)
				if(M != src) dat += "[M] <a href='?src=\ref[picker_holder];look=\ref[M]'>Examine</a> <a href='?src=\ref[picker_holder];helpout=\ref[M]'>Help out</a><br>"
		if(src.predlocation == "womb")
			if(!eater.insideflavour[3])
				eater.insideflavour[3] = "Generic womb description"
			dat += "[eater.insideflavour[3]]<br><br>"
			dat += "<font color = 'green'>You can see the following people around you:</font><br>"
			for(var/mob/living/M in eater.womb_contents)
				if(M != src) dat += "[M] <a href='?src=\ref[picker_holder];look=\ref[M]'>Examine</a> <a href='?src=\ref[picker_holder];helpout=\ref[M]'>Help out</a><br>"
		if(src.predlocation == "breast")
			if(!eater.insideflavour[4])
				eater.insideflavour[4] = "Generic boob description"
			dat += "[eater.insideflavour[4]]<br><br>"
			dat += "<font color = 'green'>You can see the following people around you:</font><br>"
			for(var/mob/living/M in eater.boob_contents)
				if(M != src) dat += "[M] <a href='?src=\ref[picker_holder];look=\ref[M]'>Examine</a> <a href='?src=\ref[picker_holder];helpout=\ref[M]'>Help out</a><br>"
		dat += "<br>"
	else
		dat += "You aren't inside anyone.<br><br>"

	dat += "<font color = 'purple'><b><center>Customisation options</center></b></font><br><br>"
	dat += "<b>Stomach:</b><br>[src.insideflavour[1]] <a href='?src=\ref[picker_holder];set_description_belly=\ref[src]'>Change text</a><br>"
	dat += "<b>Balls:</b><br>[src.insideflavour[2]] <a href='?src=\ref[picker_holder];set_description_balls=\ref[src]'>Change text</a><br>"
	dat += "<b>Womb:</b><br>[src.insideflavour[3]] <a href='?src=\ref[picker_holder];set_description_womb=\ref[src]'>Change text</a><br>"
	dat += "<b>Breasts:</b><br>[src.insideflavour[4]] <a href='?src=\ref[picker_holder];set_description_boobs=\ref[src]'>Change text</a><br>"

	var/datum/browser/popup = new(src, "insidePanel","Inside!", 700, 400, src)
	popup.set_content(dat)
	popup.open()

/datum/vore_look/var/loop = null
/datum/vore_look/Topic(href,href_list[])

	if(href_list["look"])
		var/mob/living/subj=locate(href_list["look"])
		subj.examine()

	if(href_list["helpout"])
		var/mob/living/subj=locate(href_list["helpout"])
		var/mob/living/eater = usr.loc
		usr << "<font color='green'>You begin to push [subj] to freedom!</font>"
		subj << "[usr] begins to push you to freedom!"
		eater << "<span class='warning'>Someone is trying to escape from inside you!<span>"
		sleep(50)
		if(prob(33))
			subj.loc = eater.loc
			usr << "<font color='green'>You manage to help [subj] to safety!</font>"
			subj << "<font color='green'>[usr] pushes you free!</font>"
			eater << "<span class='alert'>[subj] forces free of the confines of your body!</span>"
		else
			usr << "<span class='alert'>[subj] slips back down inside despite your efforts.</span>"
			subj << "<span class='alert'> Even with [usr]'s help, you slip back inside again.</span>"
			eater << "<font color='green'>Your body efficiently shoves [subj] back where they belong.</font>"

	if(href_list["set_description_belly"])
		var/mob/living/carbon/human/M = usr
		M.insideflavour[1] = input(M, "Input a few flavour text!", "Stomach flavour text", M.insideflavour[1])

	if(href_list["set_description_balls"])
		var/mob/living/carbon/human/M = usr
		M.insideflavour[2] = input(M, "Input a few flavour text!", "Balls flavour text", M.insideflavour[2])

	if(href_list["set_description_womb"])
		var/mob/living/carbon/human/M = usr
		M.insideflavour[3] = input(M, "Input a few flavour text!", "Womb flavour text", M.insideflavour[3])

	if(href_list["set_description_boobs"])
		var/mob/living/carbon/human/M = usr
		M.insideflavour[4] = input(M, "Input a few flavour text!", "Breasts flavour text", M.insideflavour[4])

/mob/living/carbon/human/proc/I_am_not_mad()
	set name = "Toggle digestability"
	set category = "Vore"

	if(alert(src, "This button is for those who don't like being digested. It will make you undigestable. Don't abuse this button by toggling it back and forth to extend a scene or whatever, or you'll make the admins cry. Note that this cannot be toggled inside someone's belly.", "", "Okay", "Cancel") == "Okay")
		digestable = !digestable
		if(src.digestable == 1) usr << "<span class='alert'>You are now digestable.</span>"
		else usr << "<span class='alert'>You are now undigestable.</span>"
		msg_admin_attack("[key_name(src)] toggled their digestability to [digestable]")