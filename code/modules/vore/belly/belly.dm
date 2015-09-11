//
//	The belly object is what holds onto a mob while they're inside a predator.
//	It takes care of altering the pred's decription, digesting the prey, relaying struggles etc.
//	It is not, however, for printing messages about entering/exiting the belly. That is done in voretype etc.
//

#define DM_HOLD "Hold"
#define DM_DIGEST "Digest"
#define DM_HEAL "Heal"

#define VORE_STRUGGLE_EMOTE_CHANCE 40

/**
* Parent type of all the various "belly" varieties.
*/
/vore/belly
	// Instance Variables
	var/belly_type					// Stomach/Cock/Womb/Boob
	var/belly_name					// stomach/balls/womb/breast
	// TODO - Unify belly_type and belly_name shall we?
	var/mob/owner					// The mob whose belly this is.
	var/digest_mode = DM_HOLD		// Whether or not to digest. Default to not digest.
	var/list/digest_modes = list(DM_HOLD, DM_DIGEST)	// Possible digest modes
	var/is_full						// Flag for if digested remeans are present. (for disposal messages)
	var/inside_flavor				// Flavor text description of inside sight/sound/smells/feels.
	var/recent_struggle = 0			// Flag to prevent struggle emote spam

	var/list/internal_contents = list();	// People/Things you've eaten into this belly!

	// Constructor that sets the owning mob
	// @Override
	New(mob/owning_mob)
		owner = owning_mob

	// Toggle digestion on/off and notify user of the new setting.
	// If multiple digestion modes are avaliable (i.e. unbirth) then user should be prompted.
	proc/toggle_digestion()
		return;

	// Checks if any mobs are present inside the belly
	// @return True if the belly is empty.
	proc/is_empty()
		return internal_contents.len == 0;


	// Release all contents of this belly into the owning mob's location.
	// If that location is another mob, contents are transferred into whichever of its bellies the owning mob is in.
	// Returns the number of mobs so released.
	proc/release_all_contents()
		var/tick = 0 //easiest way to check if the list has anything
		for (var/mob/M in internal_contents)
			M.loc = owner.loc  // Move the belly contents into the same location as belly's owner.
			src.internal_contents -= M  // Remove from the belly contents

			if (iscarbon(owner.loc)) // This makes sure that the mob behaves properly if released into another mob
				var/mob/living/carbon/loc_mob = owner.loc
				for (var/bellytype in loc_mob.internal_contents)
					var/vore/belly/belly = loc_mob.internal_contents[bellytype]
					if (owner in belly.internal_contents)
						belly.internal_contents += M
			tick++
		return tick;

	// Process the predator's effects upon the contents of its belly (i.e digestion/transformation etc)
	// Called from /mob/living/carbon/human/Life() proc.
	// Default implementation does nothing!
	proc/process_Life()
		return;

	// Get the line that should show up in Examine message if the owner of this belly
	// is eaxmined.   By making this a proc, we not only take advantage of polymorphism,
	// but can easily make the message vary based on how many people are inside, etc.
	// Returns a string which shoul be appended to the Examine output.
	proc/get_examine_msg(t_He, t_his, t_him, t_has, t_is)
		return;

	// Relay the sounds of someone struggling in a belly to those outside!
	// Called from /mob/living/carbon/relaymove()
	proc/relay_struggle(var/mob/user, var/direction)
		return;

