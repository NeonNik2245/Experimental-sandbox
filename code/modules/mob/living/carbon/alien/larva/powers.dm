
/mob/living/carbon/alien/larva/verb/hide()
	set name = "Спрятаться"
	set desc = "Позволяет прятаться за различной мебелью и предметами."
	set category = "Alien"

	if(stat != CONSCIOUS)
		return

	if(layer != ABOVE_NORMAL_TURF_LAYER)
		layer = ABOVE_NORMAL_TURF_LAYER
		visible_message("<B>[src] сливается с полом!</B>", "<span class='noticealien'>Теперь вы прячетесь.</span>")
	else
		layer = MOB_LAYER
		visible_message("[src] поднимается с пола...", "<span class=notice'>Вы больше не прячетесь.</span>")

/mob/living/carbon/alien/larva/verb/evolve()
	set name = "Эволюционировать"
	set desc = "Эволюционировать во взрослую особь чужого."
	set category = "Alien"

	if(stat != CONSCIOUS)
		return

	if(handcuffed || legcuffed)
		to_chat(src, "<span class='warning'>Вы не можете эволюционировать, когда вас сковали.</span>")

	if(amount_grown >= max_grown)	//TODO ~Carn
		//green is impossible to read, so i made these blue and changed the formatting slightly
		to_chat(src, "<span class='boldnotice'>Вы вырастаете в чудесного чужого! Пришло время выбрать касту.</span>")
		to_chat(src, "<span class='notice'>Есть три касты, в которые вы можете эволюционировать:</span>")
		to_chat(src, "<B>Охотники </B> <span class='notice'>сильные и ловкие, способные к охоте вдали от улья и перемещению в вентиляции.\
		 Охотники генерируют лпазму медленно и не могут запасать её в больших количествах.</span>")
		to_chat(src, "<B>Дозорные </B> <span class='notice'>защищают улей, смертельно опасны вблизи и на растоянии.\
		 Они не столь сильны и быстры, как охотники.</span>")
		to_chat(src, "<B>Трутни </B> <span class='notice'>являются рабочей кастой и имеют наибольшие показатели в хранении и генерации плазмы.\
		 Они единственная каста, которая может эволюционировать ещё раз в ужаса.щую королеву чужих.</span>")
		var/alien_caste = alert(src, "Пожалуйста, выберите касту.",,"Охотники","Дозорные","Трутни")

		var/mob/living/carbon/alien/humanoid/new_xeno
		switch(alien_caste)
			if("Охотники")
				new_xeno = new /mob/living/carbon/alien/humanoid/hunter(loc)
			if("Дозорные")
				new_xeno = new /mob/living/carbon/alien/humanoid/sentinel(loc)
			if("Трутни")
				new_xeno = new /mob/living/carbon/alien/humanoid/drone(loc)
		if(mind)
			mind.transfer_to(new_xeno)
		else
			new_xeno.key = key
		new_xeno.mind.name = new_xeno.name
		qdel(src)
		return
	else
		to_chat(src, "<span class='warning'>Вы ещё не доросли.</span>")
		return
