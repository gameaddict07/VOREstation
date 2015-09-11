//
//	Definition for cock voring someone
//

/vore/voretype/cock
	name = "Cock Vore"
	belly_target = "Cock"

/vore/voretype/cock/eat_held_mob(var/mob/attacker, var/mob/living/prey, var/mob/living/pred)
	var/attempt_msg = "<span class='danger'>[attacker] begins to force [prey] down [pred]'s shaft!</span>"
	var/success_msg = "<span class='danger'>[prey] disappears into [pred]'s cock!</span>"

	if (!perform_the_nom(attacker, prey, pred, attempt_msg, success_msg, 'sound/vore/gulp.ogg')) return

	if(pred == attacker)
		msg_admin_attack("[key_name(attacker)] cock vored [key_name(prey)]")
	else
		msg_admin_attack("[key_name(attacker)] forced [key_name(pred)] to cock vore [key_name(prey)]")

/vore/voretype/cock/feed_self_to_grabbed(var/mob/living/carbon/human/user, var/vore/pred_capable/pred)
	var/attempt_msg = "<span class='danger'>[user] is attempting to slide into [pred]'s cock!</span>"
	var/success_msg = "<span class='danger'>[user] vanishes into [pred]'s cock!</span>"

	if (!perform_the_nom(user, user, pred, attempt_msg, success_msg, 'sound/vore/gulp.ogg')) return

	msg_admin_attack("[key_name(user)] forced [key_name(pred)] to cock vore them")
	return 1;

/vore/voretype/cock/feed_grabbed_to_self(var/mob/living/carbon/human/user, var/mob/prey)
	var/attempt_msg = "<span class='danger'>[user] is attempting to slide [prey] into \his[user] cock!</span>"
	var/success_msg = "<span class='danger'>[user] swallows [prey] with \his[user] cock!</span>"

	if (!perform_the_nom(user, prey, user, attempt_msg, success_msg, 'sound/vore/gulp.ogg')) return

	msg_admin_attack("[key_name(user)] cock vored [key_name(prey)]")
	return 1;

/vore/voretype/cock/feed_grabbed_to_other(var/mob/living/carbon/human/user, var/mob/prey, var/vore/pred_capable/pred)
	var/attempt_msg = "<span class='danger'>[user] is attempting to slide [prey] into [pred]'s cock!</span>"
	var/success_msg = "<span class='danger'>[prey] vanishes into [pred]'s cock!</span>"

	if (!perform_the_nom(user, prey, pred, attempt_msg, success_msg, 'sound/vore/gulp.ogg')) return

	msg_admin_attack("[key_name(user)] forced [key_name(pred)] to cock vore [key_name(prey)]")
	return 1;
