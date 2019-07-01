//An attempt at a assembly line for the vault or possibly as a wasteland ruin, put in recycling due to proximity towards conveyors

//Basic parent type that handles inserting objects into itself when getting Bumped() and changing output direction with multitool
/obj/machinery/automation
	name = "Shouldn't exist reeeee"
	var/outputdir = SOUTH //Outputs finished stuff south by default
	icon = 'icons/obj/recycling.dmi'
	icon_state = "grinder-o0"
	density = TRUE

/obj/machinery/automation/examine(mob/user)
	..()
	to_chat(user, "<span class='notice'>It's currently outputting products in the direction of [dir2text(outputdir)].</span>")

/obj/machinery/automation/attackby(obj/item/W, mob/user, params)
	if(default_unfasten_wrench(user, W))
		return

	if(istype(W, /obj/item/multitool)) //Changes the direction of things based on direction of user
		outputdir = get_dir(src, user)
		to_chat(user, "You set the direction of the finished product to be placed at to face [dir2text(dir)].")

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
	else
		playsound(src, "sparks", 75, 1, -1)
	possible_item = null

/obj/machinery/automation/autocrafter/Bumped(atom/input)
	for(var/ingredients in currentrecipe.reqs)
		if(istype(input, ingredients))
			contents += input
			break

//A test machine that grinds up a item if applicable and outputs all the results as a reagent patch
/obj/machinery/automation/grinder
	name = "autogrinder"
	desc = "Grinds up items with reagents inside and outputs it as a patch."

/obj/machinery/automation/grinder/Initialize()
	. = ..()
	create_reagents(1000) //Because of the way this machine would work, all of this would be constantly be outputting anyway, or you could just use this as a unpowered 1000 unit vat

/obj/machinery/automation/grinder/Bumped(atom/input)
	var/obj/item/I = input
	if(I && I.grind_results)
		reagents.add_reagent_list(I.grind_results)
		if(I.reagents) //Any reagents already present are transferred
			I.reagents.trans_to(reagents, I.reagents.total_volume)
		contents -= I
		qdel(I)
		return //Quiet return if it was an item that could be grinded

	playsound(src, "sparks", 75, 1, -1) //Errored out because the item being bumped isn't 'grindable'

//For testing purposes, this machine will output a patch reagent container with some of the chems
/obj/machinery/automation/grinder/process()
	if(reagents)
		var/obj/item/reagent_containers/pill/patch/outputpatch = new(get_step(src, outputdir))
		reagents.trans_to(outputpatch, min(reagents.total_volume, 40)) //At most 40 units of the chem into that patch

