//Malfunctioning cryostasis sleepers: Spawns in makeshift shelters in lavaland. Ghosts become hermits with knowledge of how they got to where they are now.
/obj/effect/mob_spawn/human/hermit
	name = "malfunctioning cryostasis sleeper"
	desc = "Жужащий слипер с чьим-то силуэтом внутри. Функция стазиса неисправна и он скорее используется как кровать."
	mob_name = "a stranded hermit"
	icon = 'icons/obj/lavaland/spawners.dmi'
	icon_state = "cryostasis_sleeper"
	roundstart = FALSE
	death = FALSE
	random = TRUE
	allow_species_pick = TRUE
	mob_species = /datum/species/human
	description = "Вы одинокий выживший, застрявший на лаваленде в импровизированном убежище. Попробуйте выжить почти безо всякого оборудования. Для тех, кому профессия шахтёра кажется слишком скучной."
	flavour_text = "Вы были выброшены на этой Богом забытой планете настолько давно, что даже и не помните. Каждый день вы едва сводите концы с концами в вашем убежище среди ужасных\
	существ, пикирующих с небес пепельных драконов и бесконечных бурь. Всё, о чём вы мечтаете, это просто почувствовать мягкую траву под ногами \
	и свежий воздух в лёгких. Эти мысли развеиваются воспоминаниями о том, как вы сюда попали... "
	assignedrole = "Hermit"

/obj/effect/mob_spawn/human/hermit/Initialize(mapload)
	. = ..()
	var/arrpee = rand(1,4)
	switch(arrpee)
		if(1)
			flavour_text += "Вы были помощником [pick("торговца оружием", "корабельного мастера", "стыковочного менеджера")] на небольшой торговой станции в паре секторов отсюда.\
			Рейдеры атаковали вас и была лишь одна спасательная капсула, когда вы забежали в отбытие. Вы запустили её в одиночкую. Множество панических лиц из той толпы перед шлюзом\
			навсегда отпечатались в вашем сознании, после чего вас отправило в этот ад со стремительно гибнущей станции"
			outfit.uniform = /obj/item/clothing/under/assistantformal
			outfit.shoes = /obj/item/clothing/shoes/black
			outfit.back = /obj/item/storage/backpack
		if(2)
			flavour_text += "Вы - изгнанник из кооператива Тигр. Их технологический фанатизм заставил вас усомниться в их силе и вере, они разглядели в вас \
			еретика и подвергали ужасающим пыткам. Вы были всего в паре часов от казни, когда ваш высокопоставленный друг из Кооператива обеспечил вам капсулу, \
			взломал и изменил координаты назначения и запустил вас. Вы проснулись от стазиса, когда приземлились, и с тех пор едва выживаете."
			outfit.uniform = /obj/item/clothing/under/color/orange
			outfit.shoes = /obj/item/clothing/shoes/orange
			outfit.back = /obj/item/storage/backpack
		if(3)
			flavour_text += "Вы были доктором на одной из станций Nanotrasen, но вы оставили позади эту чёртову компанию и всё, что её олицитворяло. От метафорического ада \
			к буквальному, тем не менее, вы обнаруживаете, что скучаете по циркулированному воздуху и прохладным полам того, что оставили позади... но вы бы скорее предпочли остаться здесь, нежели там."
			outfit.uniform = /obj/item/clothing/under/rank/medical
			outfit.suit = /obj/item/clothing/suit/storage/labcoat
			outfit.back = /obj/item/storage/backpack/medic
			outfit.shoes = /obj/item/clothing/shoes/black
		if(4)
			flavour_text += "Ваши друзья всегда подшучивали над вами за то, что вы \"не играете с полной колодой\", так они выразились. Похоже они были правы. На одной из экскурсий \
			по современному оборудованию Nanotrasen вы оказались в спасательной капсле и увидели красную кнопку. Она была большой и блестящей, чем и зацепила ваш взгляд. Вы нажали \
			её, и после ужасающего и быстрого полёта в несколько дней вы приземлились здесь. С тех пор у вас появилось время поумнеть, и вы думаете, что они бы теперь не смеялись."
			outfit.uniform = /obj/item/clothing/under/color/grey/glorf
			outfit.shoes = /obj/item/clothing/shoes/black
			outfit.back = /obj/item/storage/backpack

/obj/effect/mob_spawn/human/hermit/Destroy()
	new/obj/structure/fluff/empty_cryostasis_sleeper(get_turf(src))
	return ..()
