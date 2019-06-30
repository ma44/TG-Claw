//An attempt at a assembly line for the vault or possibly as a wasteland ruin, put in recycling due to proximity towards conveyors
//Checks every process() to see if it has the allowed ingredients inside of it's contents to then craft a thing

/obj/machinery/autocrafter //Takes a recipe datum, accepts ingredients for them and makes it
	name = "autocrafter"
	desc = "Takes in ingredients and outputs products."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "grinder-o0"
	density = TRUE
	var/datum/crafting_recipe/currentrecipe = new/datum/crafting_recipe/healpowder() //Testing purposes
	var/datum/personal_crafting/craftproc = new //The thing that has all the procs we gotta call
	var/obj/possible_item
	var/outputdir = SOUTH //Outputs finished stuff south
	dir = SOUTH //Default outputs south

/obj/machinery/autocrafter/examine(mob/user)
	..()
	to_chat(user, "<span class='notice'>This autocrafter is currently producing a recipe called [currentrecipe.name]\n</span>")
	to_chat(user, "<span class='notice'>It's currently outputting products in the direction of [dir2text(outputdir)].</span>")

/obj/machinery/autocrafter/process()
	possible_item = craftproc.construct_item(src, currentrecipe)
	if(isobj(possible_item)) //The returned one can either be null, a string or the object itself; the object itself means it's crafted
		possible_item.loc = get_step(src, outputdir)
	else
		playsound(src, "sparks", 75, 1, -1)
	possible_item = null

/obj/machinery/autocrafter/Bumped(atom/input)
	for(var/ingredients in currentrecipe.reqs)
		if(istype(input, ingredients))
			contents += input
			break

/obj/machinery/autocrafter/attackby(obj/item/W, mob/user, params)
	if(default_unfasten_wrench(user, W))
		return

	if(istype(W, /obj/item/multitool)) //Changes the direction of things based on direction of user
		outputdir = get_dir(src, user)
		to_chat(user, "You set the direction of the finished product to be placed at to face [dir2text(dir)].")
