//
//	Definition for breast voring someone
//

/vore/voretype/boobs
	name = "Breast Vore"
	belly_target = "Boob"

/vore/voretype/boobs/eat_held_mob(var/mob/attacker, var/mob/living/prey, var/mob/living/pred)
	var/attempt_msg = "<span class='danger'>[attacker] is trying to force [prey] into [pred]'s breasts!</span>"
	var/success_msg = "<span class='danger'>[attacker] stuffs the last of [prey] into [pred]'s boobs!</span>"

	if (!perform_the_nom(attacker, prey, pred, attempt_msg, success_msg, 'sound/vore/insert.ogg')) return

	if(pred == attacker)
		msg_admin_attack("[key_name(attacker)] breast vored [key_name(prey)]")
	else
		msg_admin_attack("[key_name(attacker)] forced [key_name(pred)] to breast vore [key_name(prey)]")

/vore/voretype/boobs/feed_self_to_grabbed(var/mob/living/carbon/human/user, var/vore/pred_capable/pred)
	var/attempt_msg = "<span class='danger'>[user] is attempting to stuff themselves into [pred]'s breasts!</span>"
	var/success_msg = "<span class='danger'>[user] pushes themselves fully into [pred]'s tits!</span>"

	if (!perform_the_nom(user, user, pred, attempt_msg, success_msg, 'sound/vore/insert.ogg')) return

	msg_admin_attack("[key_name(user)] forced [key_name(pred)] to boob vore them")
	return 1;

/vore/voretype/boobs/feed_grabbed_to_self(var/mob/living/carbon/human/user, var/mob/prey)
	var/attempt_msg = "<span class='danger'>[user] is attempting to stuff [prey] into \his[user] breasts!</span>"
	var/success_msg = "<span class='danger'>[user] sucks [prey] into \his[user] tits!</span>"

	if (!perform_the_nom(user, prey, user, attempt_msg, success_msg, 'sound/vore/insert.ogg')) return

	msg_admin_attack("[key_name(user)] boob vored [key_name(prey)]")
	return 1;

/vore/voretype/boobs/feed_grabbed_to_other(var/mob/living/carbon/human/user, var/mob/prey, var/vore/pred_capable/pred)
	var/attempt_msg = "<span class='danger'>[user] is attempting to stuff [prey] into [pred]'s breasts!</span>"
	var/success_msg = "<span class='danger'>[pred] sucks [prey] into \his[pred] tits!</span>"

	if (!perform_the_nom(user, prey, pred, attempt_msg, success_msg, 'sound/vore/insert.ogg')) return

	msg_admin_attack("[key_name(user)] forced [key_name(pred)] to boob vore [key_name(prey)]")
	return 1;