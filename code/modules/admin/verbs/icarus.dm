/client/proc/FireLaser()
	set name = "Fire the Daedalus lasers"
	set desc = "Fires a laser bolt at your position.  You should only do this as a(n) (a)ghost"
	set category = "Fun"

	var/turf/target = get_turf(src.mob)
	admin_log_and_message_admins("has fired the Daedalus point defense laser at [target.x]-[target.y]-[target.z]")
	if(!src.holder)
		src << "Only administrators may use this command."
		return

	Daedalus_FireLaser(target)


/client/proc/FireCannons()
	set name = "Fire the Daedalus cannons"
	set desc = "Fires an explosive missile at your position.  You should only do this as a(n) (a)ghost."
	set category = "Fun"

	var/turf/target = get_turf(src.mob)
	admin_log_and_message_admins("has fired the Daedalus main gun projectile at [target.x]-[target.y]-[target.z]")
	if(!src.holder)
		src << "Only administrators may use this command."
		return

	Daedalus_FireCannon(target)


/client/proc/ChangeDaedalusPosition()
	set name = "Adjust Daedalus Position"
	set desc = "Lets you chose the position of the Daedalus in regards to the map."
	set category = "Fun"

	admin_log_and_message_admins("is changing the Daedalus position.")
	if(!src.holder)
		src << "Only administrators may use this command."
		return

	Daedalus_SetPosition(src)

var/Daedalus_position = SOUTH

proc/Daedalus_FireLaser(var/turf/target)
	// Find the world edge to fire from.
	var/x = Daedalus_position & EAST ? world.maxx : Daedalus_position & WEST ? 1 : target.x
	var/y = Daedalus_position & NORTH ? world.maxy : Daedalus_position & SOUTH ? 1 : target.y
	var/x_off = x != target.x ? abs(target.x - x) : INFINITY
	var/y_off = y != target.y ? abs(target.y - y) : INFINITY
	// Get the minimum number of steps using the rise/run shit.
	var/iterations = round(min(x_off, y_off)) - 14 // We cannot fire straight from the edge since teleport thing.

	// Now we can get the location of the start.
	x = target.x + (Daedalus_position & EAST ? iterations : Daedalus_position & WEST ? -iterations : 0)
	y = target.y + (Daedalus_position & NORTH ? iterations : Daedalus_position & SOUTH ? -iterations : 0)

	var/turf/start = locate(x, y, target.z)

	// should step down as:
	// 1000, 500, 333, 250, 200, 167, 142, 125, 111, 100, 90
	var/damage = 1000
	for(var/i in 2 to 12)
		var/obj/item/projectile/beam/in_chamber = new (start)
		in_chamber.original = target
		in_chamber.starting = start
		in_chamber.silenced = 1
		in_chamber.yo = Daedalus_position & NORTH ? -1 : Daedalus_position & SOUTH ? 1 : 0
		in_chamber.xo = Daedalus_position & EAST ? -1 : Daedalus_position & WEST ? 1 : 0
		in_chamber.damage = damage
		in_chamber.kill_count = 500
		in_chamber.process()
		damage -= damage / i
		sleep(-1)

	// Let everyone know what hit them.
	var/obj/item/projectile/beam/in_chamber = new (start)
	in_chamber.original = target
	in_chamber.starting = start
	in_chamber.silenced = 0
	in_chamber.yo = Daedalus_position & NORTH ? -1 : Daedalus_position & SOUTH ? 1 : 0
	in_chamber.xo = Daedalus_position & EAST ? -1 : Daedalus_position & WEST ? 1 : 0
	in_chamber.kill_count = 500
	in_chamber.damage = 0
	in_chamber.name = "point defense laser"
	in_chamber.firer = "Daedalus" // Never displayed, but we want this to display the hit message.
	in_chamber.process()

proc/Daedalus_FireCannon(var/turf/target)
	// Find the world edge to fire from.
	var/x = Daedalus_position & EAST ? world.maxx : Daedalus_position & WEST ? 1 : target.x
	var/y = Daedalus_position & NORTH ? world.maxy : Daedalus_position & SOUTH ? 1 : target.y
	var/x_off = x != target.x ? abs(target.x - x) : INFINITY
	var/y_off = y != target.y ? abs(target.y - y) : INFINITY
	// Get the minimum number of steps using the rise/run shit.
	var/iterations = round(min(x_off, y_off)) - 14 // We cannot fire straight from the edge since teleport thing.

	// Now we can get the location of the start.
	x = target.x + (Daedalus_position & EAST ? iterations : Daedalus_position & WEST ? -iterations : 0)
	y = target.y + (Daedalus_position & NORTH ? iterations : Daedalus_position & SOUTH ? -iterations : 0)

	var/turf/start = locate(x, y, target.z)

	// Now we find the corresponding turf on the other side of the level.
	// Yeah, yeah.  Overuse of the terinary operator.  So sue me.
	x = Daedalus_position & EAST ? 1 : Daedalus_position & WEST ? world.maxx : target.x
	y = Daedalus_position & NORTH ? 1 : Daedalus_position & SOUTH ? world.maxy : target.y
	x_off = x != target.x ? abs(target.x - x) : INFINITY
	y_off = y != target.y ? abs(target.y - y) : INFINITY
	iterations = round(min(x_off, y_off))
	x = target.x + (Daedalus_position & EAST ? -iterations : Daedalus_position & WEST ? iterations : 0)
	y = target.y + (Daedalus_position & NORTH ? -iterations : Daedalus_position & SOUTH ? iterations : 0)
	target = locate(x, y, target.z)

	// Finally fire the fucker.
	var/obj/effect/meteor/small/projectile = new (start)
	projectile.dest = target
	projectile.name = "main gun projectile" // stealthy
	projectile.hits = 6
	projectile.detonation_chance = 99 // it's a missile/cannon round thing!

	// Make sure it travels
	spawn(0)
		walk_towards(projectile, projectile.dest, 1)

proc/Daedalus_SetPosition(var/user)
	var/global/list/directions = list("North" = 1, "North East" = 5, "East" = 4, "South East" = 6, "South" = 2, "South West" = 10, "West" = 8, "North West" = 9)
	var/direction = input(user, "Where should the Daedalus fire from?", "Daedalus Comms") as null|anything in directions
	if(!direction)
		return

	Daedalus_position = directions[direction]
