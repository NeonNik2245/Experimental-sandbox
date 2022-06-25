/mob/living/carbon/alien/humanoid/drone
	name = "трутень чужих"
	caste = "d"
	maxHealth = 100
	health = 100
	icon_state = "aliend_s"

/mob/living/carbon/alien/humanoid/drone/New()
	if(src.name == "трутень чужих")
		src.name = text("трутень чужих ([rand(1, 999)])")
	src.real_name = src.name
	alien_organs += new /obj/item/organ/internal/xenos/plasmavessel/drone
	alien_organs += new /obj/item/organ/internal/xenos/acidgland
	alien_organs += new /obj/item/organ/internal/xenos/resinspinner
	..()

//Drones use the same base as generic humanoids.
//Drone verbs

/mob/living/carbon/alien/humanoid/drone/verb/evolve() // -- TLE
	set name = "Эволюционировать (500)"
	set desc = "Создаёт внутренний мешок для яиц, позволяющий оставлять потомство. Одновременно может быть только одна королева."
	set category = "Alien"

	if(powerc(500))
		// Queen check
		var/no_queen = 1
		for(var/mob/living/carbon/alien/humanoid/queen/Q in GLOB.alive_mob_list)
			if(!Q.key && Q.get_int_organ(/obj/item/organ/internal/brain/))
				continue
			no_queen = 0

		if(src.has_brain_worms())
			to_chat(src, "<span class='warning'>В настоящее время ты не можешь использовать эту способность!</span>")
			return
		if(no_queen)
			adjustPlasma(-500)
			to_chat(src, "<span class='noticealien'>Ты начинаешь эволюционировать!</span>")
			for(var/mob/O in viewers(src, null))
				O.show_message(text("<span class='alertalien'>[src] начинает извиваться и корчиться!</span>"), 1)
			var/mob/living/carbon/alien/humanoid/queen/new_xeno = new(loc)
			mind.transfer_to(new_xeno)
			new_xeno.mind.name = new_xeno.name
			qdel(src)
		else
			to_chat(src, "<span class='notice'>У нас уже есть живая королева.</span>")
	return
