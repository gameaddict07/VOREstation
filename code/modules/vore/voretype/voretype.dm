//
//	Type storing data/procs about the ways you can eat someone!
//

/vore/voretype
	var/name
	var/belly_target = "Stomach"	// Which belly does this voretype lead you to?

//
// Note: There are currently four ways to eat somone in VIRGO, via two main methods.
//
//	A) A micro holder in your hand can be fed to yourself or another.
//	B) A grabbed mob (aggressive or higher) can...
//		i) Be fed to yourself
//		ii) Be fed to someone else
//		iii) You can feed yourself to it!
//

/vore/voretype/proc/eat_held_mob(var/mob/attacker, var/mob/living/prey, var/mob/living/pred)
	return

/vore/voretype/proc/feed_self_to_grabbed(var/mob/living/carbon/human/attacker, var/vore/pred_capable/pred)
	return

/vore/voretype/proc/feed_grabbed_to_self(var/mob/living/carbon/human/attacker, var/mob/prey)
	return

/vore/voretype/proc/feed_grabbed_to_other(var/mob/living/carbon/human/attacker, var/mob/prey, var/vore/pred_capable/pred)
	return

//
// Method to actually execute the nomming and print the messages!
// This method removes duplicate code by consolidating the shared pieces.
// However, if any particular vore type whishes to do its own thing, simply don't call this method (or override it!)
//
/vore/voretype/proc/perform_the_nom(var/mob/user, var/mob/living/prey, var/mob/living/carbon/pred, attempt_msg, success_msg, sound)
	// Announce that we start the attempt!
	user.visible_message(attempt_msg)

	// Now give the prey time to escape... return if they did
	if (!istype(prey, /mob/living/carbon/human))
		if(!do_mob(user, prey) || !do_after(user, 30)) return 0  // Non-humans get only 30 ticks
	else
		if(!do_mob(user, prey) || !do_after(user, 100)) return 0 // Humans get 100 ticks to escape.

	// If we got this far, nom successful! Announce it!
	user.visible_message(success_msg)
	playsound(user, sound, 100, 1)

	// Actually put the prey where they belong.
	prey.loc = pred
	var/vore/belly/target_belly = pred.internal_contents[belly_target]
	target_belly.internal_contents += prey
	return 1

// TODO LESHANA - This needs to be done much better in a cleaner way.
// This is a performance enhancement, single voretypes are immutable we don't need
// separate instances for every mob, they can share singleton instances.

var/list/SINGLETON_VORETYPE_INSTANCES = list(
		"Oral Vore" = new /vore/voretype/oral(),
		"Unbirth" = new /vore/voretype/(),
		"Anal Vore" = new /vore/voretype/anal(),
		"Cock Vore" = new /vore/voretype/cock(),
		"Breast Vore" = new /vore/voretype/boobs())
