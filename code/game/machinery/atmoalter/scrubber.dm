/obj/machinery/portable_atmospherics/powered/scrubber
	name = "\improper Portable Air Scrubber"

	icon = 'icons/obj/atmos.dmi'
	icon_state = "pscrubber:0"
	density = 1

	var/locked = 1  // Start locked so people can't mess with scrubbing settings.
	req_access = list(access_atmospherics)

	var/on = 0
	var/volume_rate = 800

	volume = 750

	power_rating = 7500 //7500 W ~ 10 HP
	power_losses = 150

	var/list/scrubbing_gas = list("phoron", "carbon_dioxide", "sleeping_agent", "oxygen_agent_b")

/obj/machinery/portable_atmospherics/powered/scrubber/New()
	..()
	cell = new/obj/item/weapon/cell(src)

/obj/machinery/portable_atmospherics/powered/scrubber/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(prob(50/severity))
		on = !on
		update_icon()

	..(severity)

/obj/machinery/portable_atmospherics/powered/scrubber/update_icon()
	src.overlays = 0

	if(on && cell && cell.charge)
		icon_state = "pscrubber:1"
	else
		icon_state = "pscrubber:0"

	if(holding)
		overlays += "scrubber-open"

	if(connected_port)
		overlays += "scrubber-connector"

	return

/obj/machinery/portable_atmospherics/powered/scrubber/process()
	..()

	var/power_draw = -1

	if(on && cell && cell.charge)
		var/datum/gas_mixture/environment
		if(holding)
			environment = holding.air_contents
		else
			environment = loc.return_air()

		var/transfer_moles = min(1, volume_rate/environment.volume)*environment.total_moles

		power_draw = scrub_gas(src, scrubbing_gas, environment, air_contents, transfer_moles, power_rating)

	if (power_draw < 0)
		last_flow_rate = 0
		last_power_draw = 0
	else
		power_draw = max(power_draw, power_losses)
		cell.use(power_draw * CELLRATE)
		last_power_draw = power_draw

		update_connected_network()

		//ran out of charge
		if (!cell.charge)
			update_icon()

	//src.update_icon()
	src.updateUsrDialog()

/obj/machinery/portable_atmospherics/powered/scrubber/return_air()
	return air_contents

/**
** Allow the scrubber's advanced controls to be unlocked.
*/
/obj/machinery/portable_atmospherics/powered/scrubber/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if (istype(I, /obj/item/weapon/card/id) || istype(I, /obj/item/device/pda))
		if (src.allowed(usr))
			src.locked = !src.locked
			user << "<span class='notice'>You [ src.locked ? "lock" : "unlock"] \the [src] advanced controls.</span>"
			src.updateUsrDialog()
		else
			user << "<span class='notice'>This [src] doesn't seem to respect your authority.</span>"
	else
		return ..()

/obj/machinery/portable_atmospherics/powered/scrubber/attack_hand(var/mob/user as mob)
	// Let default implementation determine if user can use it or not
	if (..())
		usr << browse(null, "window=scrubber")
		return 1;
	user.set_machine(src)
	var/holding_text

	if(holding)
		holding_text = {"<BR><B>Tank Pressure</B>: [round(holding.air_contents.return_pressure(), 0.01)] kPa<BR>
<A href='?src=\ref[src];remove_tank=1'>Remove Tank</A>
"}
	var/output_text = {"<B>Settings</B><BR>
Pressure: [round(air_contents.return_pressure(), 0.01)] kPa<BR>
Flow Rate: [round(last_flow_rate, 0.1)] L/s<BR>
Port Status: [(connected_port)?("Connected"):("Disconnected")]
[holding_text]<BR>
<BR>
Cell Charge: [cell? "[round(cell.percent())]%" : "N/A"] | Load: [round(last_power_draw)] W<BR>
Power Switch: <A href='?src=\ref[src];power=1'>[on?("On"):("Off")]</A><BR>
Flow Rate Regulator: <A href='?src=\ref[src];volume_adj=-1000'>-</A> <A href='?src=\ref[src];volume_adj=-100'>-</A> <A href='?src=\ref[src];volume_adj=-10'>-</A> <A href='?src=\ref[src];volume_adj=-1'>-</A> [volume_rate] L/s <A href='?src=\ref[src];volume_adj=1'>+</A> <A href='?src=\ref[src];volume_adj=10'>+</A> <A href='?src=\ref[src];volume_adj=100'>+</A> <A href='?src=\ref[src];volume_adj=1000'>+</A><BR>
<HR>
"}
	if (locked)
		output_text += "(Swipe ID card to unlock interface.)"
	else
		output_text += "Scrubbing: "
		for (var/gas_id in gas_data.gases)
			var/is_on = (gas_id in scrubbing_gas)
			output_text += "<a href='?src=\ref[src];toggle_scrub=[gas_id]' class='[is_on ? "linkOn" : "linkOff"]'>[gas_data.name[gas_id]]</a> "

	output_text += {"<HR>
<A href='?src=\ref[user];mach_close=scrubber'>Close</A><BR>
"}

	var/datum/browser/popup = new(user, "scrubber", name, 600, 300)
	popup.set_content(output_text)
	popup.open()
	return

/obj/machinery/portable_atmospherics/powered/scrubber/Topic(href, href_list)
	// Delegate checks to parent method, which calls CanUseTopic().  If success, parent automatically sets machine too.
	if (..())
		usr << browse(null, "window=scrubber")
		return 1;
	else
		if(href_list["power"])
			on = !on

		if (href_list["remove_tank"])
			if(holding)
				holding.loc = loc
				holding = null

		if (href_list["volume_adj"])
			var/diff = text2num(href_list["volume_adj"])
			volume_rate = min(initial(volume_rate), max(0, volume_rate+diff))

		if (href_list["toggle_scrub"])
			var gas_id = href_list["toggle_scrub"]
			if (locked)
				usr << "The advanced scrubbing controls are locked. Swipe your ID to unlock."
			else if (gas_id in scrubbing_gas)
				scrubbing_gas -= gas_id
			else
				scrubbing_gas += gas_id

		src.updateUsrDialog()
		src.add_fingerprint(usr)
		update_icon()


//Huge scrubber
/obj/machinery/portable_atmospherics/powered/scrubber/huge
	name = "\improper Huge Air Scrubber"
	icon_state = "scrubber:0"
	anchored = 1
	volume = 50000
	volume_rate = 5000

	chan
	use_power = 1
	idle_power_usage = 500		//internal circuitry, friction losses and stuff
	active_power_usage = 100000	//100 kW ~ 135 HP

	var/global/gid = 1
	var/id = 0

/obj/machinery/portable_atmospherics/powered/scrubber/huge/New()
	..()
	cell = null

	id = gid
	gid++

	name = "[name] (ID [id])"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/attack_hand(var/mob/user as mob)
		usr << "\blue You can't directly interact with this machine. Use the scrubber control console."

/obj/machinery/portable_atmospherics/powered/scrubber/huge/update_icon()
	src.overlays = 0

	if(on && !(stat & (NOPOWER|BROKEN)))
		icon_state = "scrubber:1"
	else
		icon_state = "scrubber:0"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/power_change()
	var/old_stat = stat
	..()
	if (old_stat != stat)
		update_icon()

/obj/machinery/portable_atmospherics/powered/scrubber/huge/process()
	if(!on || (stat & (NOPOWER|BROKEN)))
		update_use_power(0)
		last_flow_rate = 0
		last_power_draw = 0
		return 0

	var/power_draw = -1

	var/datum/gas_mixture/environment = loc.return_air()

	var/transfer_moles = min(1, volume_rate/environment.volume)*environment.total_moles

	power_draw = scrub_gas(src, scrubbing_gas, environment, air_contents, transfer_moles, active_power_usage)

	if (power_draw < 0)
		last_flow_rate = 0
		last_power_draw = 0
	else
		use_power(power_draw)
		update_connected_network()

/obj/machinery/portable_atmospherics/powered/scrubber/huge/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/weapon/wrench))
		if(on)
			user << "\blue Turn it off first!"
			return

		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		user << "\blue You [anchored ? "wrench" : "unwrench"] \the [src]."

		return

	//doesn't use power cells
	if(istype(I, /obj/item/weapon/cell))
		return
	if (istype(I, /obj/item/weapon/screwdriver))
		return

	//doesn't have advanced controls
	if (istype(I, /obj/item/weapon/card/id) || istype(I, /obj/item/device/pda))
		return

	//doesn't hold tanks
	if(istype(I, /obj/item/weapon/tank))
		return

	..()


/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary
	name = "\improper Stationary Air Scrubber"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/weapon/wrench))
		user << "\blue The bolts are too tight for you to unscrew!"
		return

	..()