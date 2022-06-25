/*NOTES:
These are general powers. Specific powers are stored under the appropriate alien creature type.
*/

/*Alien spit now works like a taser shot. It won't home in on the target but will act the same once it does hit.
Doesn't work on other aliens/AI.*/


/mob/living/carbon/proc/powerc(X, Y)//Y is optional, checks for weed planting. X can be null.
	if(stat)
		to_chat(src, "<span class='noticealien'>Вы должны быть в сознании для этого.</span>")
		return 0
	else if(X && getPlasma() < X)
		to_chat(src, "<span class='noticealien'>Недостаточно плазмы.</span>")
		return 0
	else if(Y && (!isturf(src.loc) || istype(src.loc, /turf/space)))
		to_chat(src, "<span class='noticealien'>Вы не можете расположить это здесь!</span>")
		return 0
	else	return 1

/mob/living/carbon/alien/humanoid/verb/plant()
	set name = "Посадить сорняки (50)"
	set desc = "Рассаживает немного инопланетных сорняков"
	set category = "Alien"

	if(locate(/obj/structure/alien/weeds/node) in get_turf(src))
		to_chat(src, "<span class='noticealien'>здесь уже есть узел сорняков.</span>")
		return

	if(powerc(50,1))
		adjustPlasma(-50)
		for(var/mob/O in viewers(src, null))
			O.show_message(text("<span class='alertalien'>[src] посадил инопланетные сорняки!</span>"), 1)
		new /obj/structure/alien/weeds/node(loc)
	return

/mob/living/carbon/alien/humanoid/verb/whisp(mob/M as mob in oview())
	set name = "Шёпот (10)"
	set desc = "Нашептать кому-то"
	set category = "Alien"

	if(powerc(10))
		adjustPlasma(-10)
		var/msg = sanitize(input("сообщение:", "Чужой шепчет") as text|null)
		if(msg)
			log_say("(AWHISPER to [key_name(M)]) [msg]", src)
			to_chat(M, "<span class='noticealien'>Вы слышите странный, чужой голос в своей голове...<span class='noticealien'>[msg]")
			to_chat(src, "<span class='noticealien'>Вы говорите: [msg] [M]</span>")
			for(var/mob/dead/observer/G in GLOB.player_list)
				G.show_message("<i>Сообщение чужого <b>[src]</b> ([ghost_follow_link(src, ghost=G)]) к <b>[M]</b> ([ghost_follow_link(M, ghost=G)]): [msg]</i>")
	return

/mob/living/carbon/alien/humanoid/verb/transfer_plasma(mob/living/carbon/alien/M as mob in oview())
	set name = "Передать плазму"
	set desc = "Передать плазму другому чужому"
	set category = "Alien"

	if(isalien(M))
		var/amount = input("Количество:", "Передать плазму [M]") as num
		if(amount)
			amount = abs(round(amount))
			if(powerc(amount))
				if(get_dist(src,M) <= 1)
					M.adjustPlasma(amount)
					adjustPlasma(-amount)
					to_chat(M, "<span class='noticealien'>[src] передал [amount] плазмы тебе.</span>")
					to_chat(src, {"<span class='noticealien'>Ты передал [amount] плазмы [M]</span>"})
				else
					to_chat(src, "<span class='noticealien'>Тебе надо быть ближе для передачи.</span>")
	return


/mob/living/carbon/alien/humanoid/proc/corrosive_acid(atom/target) //If they right click to corrode, an error will flash if its an invalid target./N
	set name = "Едкая кислота (200)"
	set desc = "Покройте объект кислотой для его разрушения с течением времени"
	set category = "Alien"

	if(powerc(200))
		if(target in oview(1))
			if(target.acid_act(200, 100))
				visible_message("<span class='alertalien'>[src] покрывает [target] мерзкой дрянью. Теперь [target] начинает шипеть и плавиться под пузырящейся кислотой!</span>")
				adjustPlasma(-200)
			else
				to_chat(src, "<span class='noticealien'>Ты не можешь растворить этот объект.</span>")
		else
			to_chat(src, "<span class='noticealien'>[target] is too far away.</span>")

/mob/living/carbon/alien/humanoid/proc/neurotoxin() // ok
	set name = "Плевок нейротоксином (50)"
	set desc = "Плюёт нейротоксином в цель, парализуя их на короткое время"
	set category = "Alien"

	if(powerc(50))
		adjustPlasma(-50)
		src.visible_message("<span class='danger'>[src] плюёт нейротоксином!", "<span class='alertalien'>Вы плюнули нейротоксином!</span>")

		var/turf/T = loc
		var/turf/U = get_step(src, dir) // Get the tile infront of the move, based on their direction
		if(!isturf(U) || !isturf(T))
			return

		var/obj/item/projectile/bullet/neurotoxin/A = new /obj/item/projectile/bullet/neurotoxin(usr.loc)
		A.current = U
		A.firer = src
		A.yo = U.y - T.y
		A.xo = U.x - T.x
		A.fire()
		A.newtonian_move(get_dir(U, T))
		newtonian_move(get_dir(U, T))
	return

/mob/living/carbon/alien/humanoid/proc/resin() // -- TLE
	set name = "Выделить смолу (55)"
	set desc = "Выделяет жёсткую податливую смолу"
	set category = "Alien"

	if(powerc(55))
		var/choice = input("Выбери желаемую форму.","Сооружения из смолы") as null|anything in list("смолистая стена","смолистая мембрана","смолистое гнездо") //would do it through typesof but then the player choice would have the type path and we don't want the internal workings to be exposed ICly - Urist

		if(!choice || !powerc(55))	return
		adjustPlasma(-55)
		for(var/mob/O in viewers(src, null))
			O.show_message(text("<span class='alertalien'>[src] выделяет жирную фиолетовую субстанцию и придаёт ей форму!</span>"), 1)
		switch(choice)
			if("смолистая стена")
				new /obj/structure/alien/resin/wall(loc)
			if("смолистая мембрана")
				new /obj/structure/alien/resin/membrane(loc)
			if("смолистое гнездо")
				new /obj/structure/bed/nest(loc)
	return

/mob/living/carbon/alien/humanoid/verb/regurgitate()
	set name = "Отрыжка"
	set desc = "Опустошает содержимое вашего желудка"
	set category = "Alien"

	if(powerc())
		if(LAZYLEN(stomach_contents))
			for(var/mob/M in src)
				LAZYREMOVE(stomach_contents, M)
				M.forceMove(drop_location())
			visible_message("<span class='alertalien'><B>[src] выплёвывает содержимое своего желудка!</span>")

/mob/living/carbon/proc/getPlasma()
 	var/obj/item/organ/internal/xenos/plasmavessel/vessel = get_int_organ(/obj/item/organ/internal/xenos/plasmavessel)
 	if(!vessel) return 0
 	return vessel.stored_plasma


/mob/living/carbon/proc/adjustPlasma(amount)
 	var/obj/item/organ/internal/xenos/plasmavessel/vessel = get_int_organ(/obj/item/organ/internal/xenos/plasmavessel)
 	if(!vessel) return
 	vessel.stored_plasma = max(vessel.stored_plasma + amount,0)
 	vessel.stored_plasma = min(vessel.stored_plasma, vessel.max_plasma) //upper limit of max_plasma, lower limit of 0
 	return 1

/mob/living/carbon/alien/adjustPlasma(amount)
	. = ..()
	updatePlasmaDisplay()

/mob/living/carbon/proc/usePlasma(amount)
	if(getPlasma() >= amount)
		adjustPlasma(-amount)
		return 1

	return 0
