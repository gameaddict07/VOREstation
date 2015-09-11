//
//	Definition for anal voring someone
//

/vore/voretype/womb
	name = "Unbirth"
	belly_target = "Womb"

/vore/voretype/womb/eat_held_mob(var/mob/attacker, var/mob/living/prey, var/mob/living/pred)
	var/attempt_msg = "<span class='danger'>[attacker] starts to push [prey] into [pred]'s pussy!</span>"
	var/success_msg = "<span class='danger'>The last of [prey] vanishes into [pred]'s vagina!</span>"

	if (!perform_the_nom(attacker, prey, pred, attempt_msg, success_msg, 'sound/vore/schlorp.ogg')) return

	if(pred == attacker)
		msg_admin_attack("[key_name(attacker)] unbirthed [key_name(prey)]")
	else
		msg_admin_attack("[key_name(attacker)] forced [key_name(pred)] to unbirth [key_name(prey)]")

/vore/voretype/womb/feed_self_to_grabbed(var/mob/living/carbon/human/user, var/vore/pred_capable/pred)
	var/attempt_msg = "<span class='danger'>[user] is attempting to climb into [pred]'s pussy!</span>"
	var/success_msg = "<span class='danger'>[user] squelches into [pred]'s womb!</span>"

	if (!perform_the_nom(user, user, pred, attempt_msg, success_msg, 'sound/vore/schlorp.ogg')) return

	msg_admin_attack("[key_name(user)] forced [key_name(pred)] to unbirth them")
	return 1;

/vore/voretype/womb/feed_grabbed_to_self(var/mob/living/carbon/human/user, var/mob/prey)
	var/attempt_msg = "<span class='danger'>[user] is attempting to unbirth [prey]!</span>"
	var/success_msg = "<span class='danger'>[user] squelches [prey] into \his[user] womb!</span>"

	if (!perform_the_nom(user, prey, user, attempt_msg, success_msg, 'sound/vore/schlorp.ogg')) return

	msg_admin_attack("[key_name(user)] unbirthed [key_name(prey)]")
	return 1;

/vore/voretype/womb/feed_grabbed_to_other(var/mob/living/carbon/human/user, var/mob/prey, var/vore/pred_capable/pred)
	var/attempt_msg = "<span class='danger'>[user] is attempting to push [prey] into [pred]'s pussy!</span>"
	var/success_msg = "<span class='danger'>[prey] squelches into [pred]'s womb!</span>"

	if (!perform_the_nom(user, prey, pred, attempt_msg, success_msg, 'sound/vore/schlorp.ogg')) return

	msg_admin_attack("[key_name(user)] forced [key_name(pred)] to unbirth [key_name(prey)]")
	return 1;
