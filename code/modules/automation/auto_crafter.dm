//Checks every process() to see if it has the allowed ingredients inside of it's contents to then craft a thing

/obj/machinery/automation/autocrafter //Takes a recipe datum, accepts ingredients for them and makes it
	name = "autocrafter"
	desc = "Takes in ingredients and outputs products."
	var/datum/crafting_recipe/currentrecipe = new/datum/crafting_recipe/healpowder() //Testing purposes
	var/datum/personal_crafting/craftproc = new //The thing that has all the procs we gotta call
	var/obj/possible_item
	dir = SOUTH //Default outputs south

/obj/machinery/automation/autocrafter/examine(mob/user)
	..()
	to_chat(user, "<span class='notice'>This [src] is currently producing a recipe called [currentrecipe.name]\n</span>")

/obj/machinery/automation/autocrafter/process()
	possible_item = craftproc.construct_item(src, currentrecipe)
	if(isobj(possible_item)) //The returned one can either be null, a string or the object itself; the object itself means it's crafted
		possible_item.loc = get_step(src, outputdir)
	possible_item = null
	..()

/obj/machinery/automation/autocrafter/Bumped(atom/input)
	for(var/ingredients in currentrecipe.reqs)
		if(istype(input, ingredients))
			contents += input
			break
	..()
