/////SINGULARITY SPAWNER
/obj/machinery/the_singularitygen
	name = "Gravitational Singularity Generator"
	desc = "An odd device which produces a Gravitational Singularity when set up."
	icon = 'icons/obj/engines_and_power/singularity.dmi'
	icon_state = "TheSingGen"
	anchored = FALSE
	density = 1
	use_power = NO_POWER_USE
	resistance_flags = FIRE_PROOF
	var/energy = 0
	var/creation_type = /obj/singularity

/obj/machinery/the_singularitygen/process()
	var/turf/T = get_turf(src)
	if(src.energy >= 200)
		message_admins("A [creation_type] has been created at [ADMIN_COORDJMP(src)]")
		investigate_log("A [creation_type] has been created at [AREACOORD(src)] last touched by [fingerprintslast]", INVESTIGATE_ENGINE)

		var/obj/singularity/S = new creation_type(T, 50)
		transfer_fingerprints_to(S)
		if(src) qdel(src)

/obj/machinery/the_singularitygen/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_WRENCH)
		add_fingerprint(user)
		set_anchored(!anchored)
		playsound(src.loc, W.usesound, 75, 1)
		if(anchored)
			user.visible_message("[user.name] secures [src.name] to the floor.", \
				"You secure the [src.name] to the floor.", \
				"You hear a ratchet")
			src.add_hiddenprint(user)
		else
			user.visible_message("[user.name] unsecures [src.name] from the floor.", \
				"You unsecure the [src.name] from the floor.", \
				"You hear a ratchet")
		return
	return ..()
