//
//	Definition for oral voring someone
//

/vore/voretype/oral
	name = "Oral Vore"
	belly_target = "Stomach"

/vore/voretype/oral/eat_held_mob(var/mob/attacker, var/mob/living/prey, var/mob/living/pred)
	var/attempt_msg = "<span class='danger'>[attacker] is attempting to stuff [prey] down [pred]'s throat!</span>"
	var/success_msg = "<span class='danger'>[pred] swallows the last of [prey]!</span>"

	if (!perform_the_nom(attacker, prey, pred, attempt_msg, success_msg, 'sound/vore/gulp.ogg')) return

	if(pred == attacker)
		msg_admin_attack("[key_name(attacker)] oral vored [key_name(prey)]")
	else
		msg_admin_attack("[key_name(attacker)] fed [key_name(prey)] to [key_name(pred)]")

/vore/voretype/oral/feed_self_to_grabbed(var/mob/living/carbon/human/user, var/vore/pred_capable/pred)
	var/attempt_msg = "<span class='danger'>[user] is attempting to feed themselves to [pred]!</span>"
	var/success_msg = "<span class='danger'>[pred] swallows the last of [user]!</span>"

	if (!perform_the_nom(user, user, pred, attempt_msg, success_msg, 'sound/vore/gulp.ogg')) return

	msg_admin_attack("[key_name(user)] fed themselves to [key_name(pred)]")
	return 1;

/vore/voretype/oral/feed_grabbed_to_self(var/mob/living/carbon/human/user, var/mob/prey)
	var/attempt_msg = "<span class='danger'>[user] is attempting to swallow down [prey]!</span>"
	var/success_msg = "<span class='danger'>[user] swallows the last of [prey]!</span>"

	if (!perform_the_nom(user, prey, user, attempt_msg, success_msg, 'sound/vore/gulp.ogg')) return

	msg_admin_attack("[key_name(user)] oral vored [key_name(prey)]")
	return 1;

/vore/voretype/oral/feed_grabbed_to_other(var/mob/living/carbon/human/user, var/mob/prey, var/vore/pred_capable/pred)
	var/attempt_msg = "<span class='danger'>[user] is attempting to feed [prey] to [pred]!</span>"
	var/success_msg = "<span class='danger'>[pred] swallows the last of [prey]!</span>"

	if (!perform_the_nom(user, prey, pred, attempt_msg, success_msg, 'sound/vore/gulp.ogg')) return

	msg_admin_attack("[key_name(user)] fed [key_name(prey)] to [key_name(prey)]")
	return 1;
