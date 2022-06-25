//This file contains xenoborg specic weapons.

/obj/item/melee/energy/alien/claws
	name = "энергетические когти"
	desc = "Набор энергетических когтей чужих."
	icon = 'icons/mob/alien.dmi'
	icon_state = "borg-laser-claws"
	icon_state_on = "borg-laser-claws"
	force = 15
	force_on = 15
	throwforce = 5
	throwforce_on = 5
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	w_class_on = WEIGHT_CLASS_SMALL
	attack_verb = list("attacked", "slashed", "gored", "sliced", "torn", "ripped", "butchered", "cut")
	attack_verb_on = list()

//Bottles for borg liquid squirters. PSSH PSSH
/obj/item/reagent_containers/spray/alien
	name = "жидкостный синтезатор"
	desc = "Выделяет жидкости чужих."
	icon = 'icons/mob/alien.dmi'
	icon_state = "borg-default"

/obj/item/reagent_containers/spray/alien/smoke
	name = "дымовой синтезатор"
	desc = "Выделяет дымящиеся жидкости."
	icon = 'icons/mob/alien.dmi'
	icon_state = "borg-spray-smoke"

/obj/item/reagent_containers/spray/alien/smoke/afterattack(atom/A as mob|obj, mob/user as mob)
	if(istype(A, /obj/structure/reagent_dispensers) && get_dist(src,A) <= 1)
		if(!A.reagents.total_volume && A.reagents)
			to_chat(user, "<span class='notice'>\The [A] is empty.</span>")
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, "<span class='notice'>\The [src] is full.</span>")
			return
	reagents.remove_reagent(25,"water")
	var/datum/effect_system/smoke_spread/bad/smoke = new
	smoke.set_up(5, 0, user.loc)
	smoke.start()
	playsound(user.loc, 'sound/effects/bamf.ogg', 50, 2)

/obj/item/reagent_containers/spray/alien/acid
	name = "кислотный синтезатор"
	desc = "Выделяет жгучие жидкости."
	icon = 'icons/mob/alien.dmi'
	icon_state = "borg-spray-acid"

/obj/item/reagent_containers/spray/alien/stun
	name = "синтезатор парализующих токсинов"
	desc = "выделяет виагру."
	icon = 'icons/mob/alien.dmi'
	icon_state = "borg-spray-stun"

//SKREEEEEEEEEEEE tool

/obj/item/flash/cyborg/alien
	name = "глазная вспышка"
	desc = "Полезно для фотографирования, знакомства с друзьями и быстрой жарки чипсов."
	icon = 'icons/mob/alien.dmi'
	icon_state = "borg-flash"
