//
//	Definition for anal voring someone
//

/vore/voretype/anal
	name = "Anal Vore"
	belly_target = "Stomach"

/vore/voretype/anal/eat_held_mob(var/mob/attacker, var/mob/living/prey, var/mob/living/pred)
	var/attempt_msg = "<span class='danger'>[attacker] starts sliding [prey] up [pred]'s ass!</span>"
	var/success_msg = "<span class='danger'>[prey] fully slides into [pred]'s ass!</span>"

	if (!perform_the_nom(attacker, prey, pred, attempt_msg, success_msg, 'sound/vore/schlorp.ogg')) return

	if(pred == attacker)
		msg_admin_attack("[key_name(attacker)] anal vored [key_name(prey)]")
	else
		msg_admin_attack("[key_name(attacker)] forced [key_name(pred)] to anal vore [key_name(prey)]")

/vore/voretype/anal/feed_self_to_grabbed(var/mob/living/carbon/human/user, var/vore/pred_capable/pred)
	var/attempt_msg = "<span class='danger'>[user] is attempting to push themselves up [pred]'s rear!</span>"
	var/success_msg = "<span class='danger'>[user] disappears up [pred]'s ass!</span>"

	if (!perform_the_nom(user, user, pred, attempt_msg, success_msg, 'sound/vore/schlorp.ogg')) return

	msg_admin_attack("[key_name(user)] forced [key_name(pred)] to anal vore them")
	return 1;

/vore/voretype/anal/feed_grabbed_to_self(var/mob/living/carbon/human/user, var/mob/prey)
	var/attempt_msg = "<span class='danger'>[user] is attempting to push [prey] up \his[user] rear!</span>"
	var/success_msg = "<span class='danger'>[user] schlorps [prey] into \his[user] rump!</span>"

	if (!perform_the_nom(user, prey, user, attempt_msg, success_msg, 'sound/vore/schlorp.ogg')) return

	msg_admin_attack("[key_name(user)] anal vored [key_name(prey)]")
	return 1;

/vore/voretype/anal/feed_grabbed_to_other(var/mob/living/carbon/human/user, var/mob/prey, var/vore/pred_capable/pred)
	var/attempt_msg = "<span class='danger'>[user] is attempting to push [prey] up [pred]'s rear!</span>"
	var/success_msg = "<span class='danger'>[prey] disappears up [pred]'s ass!</span>"

	if (!perform_the_nom(user, prey, pred, attempt_msg, success_msg, 'sound/vore/schlorp.ogg')) return

	msg_admin_attack("[key_name(user)] forced [key_name(pred)] to anal vore [key_name(prey)]")
	return 1;