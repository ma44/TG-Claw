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
		to_chat(user, "You set the direction of the finished product to be placed at to face [dir2text(outputdir)].")

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
	..()

/obj/machinery/automation/autocrafter/Bumped(atom/input)
	for(var/ingredients in currentrecipe.reqs)
		if(istype(input, ingredients))
			contents += input
			break
	..()

//A test machine that grinds up a item if applicable and outputs all the results as a reagent patch
/obj/machinery/automation/grinder
	name = "autogrinder"
	desc = "Grinds up items with reagents inside and outputs it as a patch."
	var/obj/item/reagent_containers/output_container = /obj/item/reagent_containers/pill/patch //The typepath of the reagent container we want to output; patch by default
	var/amount_to_transfer = 20 //How many units should be dispensed into the output container
	var/name_of_output = "" //If we want to append a custom name to the output we will, otherwise just uses default setup AKA get_master_reagent and total volume

/obj/machinery/automation/grinder/Initialize()
	. = ..()
	create_reagents(1000) //Because of the way this machine would work, all of this would be constantly be outputting anyway, or you could just use this as a unpowered 1000 unit vat

/obj/machinery/automation/grinder/Bumped(atom/input)
	var/obj/item/I = input
	if(I && I.grind_results && (reagents.total_volume != reagents.maximum_volume)) //We'll only grind if it's acceptable and that we don't have the max capacity hit
		reagents.add_reagent_list(I.grind_results)
		if(I.reagents) //Any reagents already present inside besides the grind_results are transferred
			I.reagents.trans_to(reagents, I.reagents.total_volume)
		contents -= I
		qdel(I)
		return //Quiet return if it was an item that could be grinded

	playsound(src, "sparks", 75, 1, -1) //Errored out because the item being bumped isn't 'grindable'
	..()

//For testing purposes, this machine will output a patch reagent container with some of the chems
/obj/machinery/automation/grinder/process()
	if(reagents.total_volume > amount_to_transfer)
		var/obj/item/reagent_containers/outputed_container = new output_container(get_step(src, outputdir))
		reagents.trans_to(outputed_container, min(reagents.total_volume, amount_to_transfer)) //Transfer the chemicals
		if(name_of_output)
			outputed_container.name = trim(name_of_output)
		else
			outputed_container.name = trim(outputed_container.reagents.get_master_reagent_name() + " " + amount_to_transfer)
	..()

//A machine that takes items, puts it into a storage container then outputs it
//Should be expanded so it can say put them into crates or wrapping paper
/obj/machinery/automation/packager
	name = "packager"
	desc = "Takes items and puts them into cardboard boxes."
	var/package_type = /obj/item/storage/box
	var/obj/item/storage/current_package
	var/box_is_full = FALSE //So we can output it every process() instead of every Bumped()

/obj/machinery/automation/packager/Initialize()
	. = ..()
	current_package = new package_type

//Outputs the package and inits it again
/obj/machinery/automation/packager/proc/output_package()
	current_package.loc = get_step(src, outputdir)
	adjust_item_drop_location(current_package)
	playsound(loc, 'sound/machines/ping.ogg', 30, 1)
	current_package = new package_type
	box_is_full = FALSE

/obj/machinery/automation/packager/Bumped(atom/input)
	if(isitem(input))
		var/obj/item/item = input
		var/datum/component/storage/compon_storage = current_package.GetComponent(/datum/component/storage)
		if(compon_storage && compon_storage.max_w_class >= item.w_class)
			if(!SEND_SIGNAL(current_package, COMSIG_TRY_STORAGE_INSERT, item, null, FALSE, FALSE)) //If it can't fit inside the box because not enough space, output box
				box_is_full = TRUE
				return
	//playsound(src, "sparks", 75, 1, -1) //Item being bumped is too big to be put into the storage container
	..()

/obj/machinery/automation/packager/process()
	..()
	var/datum/component/storage/compon_storage = current_package.GetComponent(/datum/component/storage)
	//Copypasta electric boogaloo
	var/sum_w_class = 0
	for(var/obj/item/I in compon_storage.real_location)
		sum_w_class += I.w_class //Adds up the combined w_classes which will be in the storage item if the item is added to it.
	if(box_is_full || compon_storage.max_combined_w_class == sum_w_class || compon_storage.real_location.contents.len == compon_storage.max_items)
		output_package()

//Takes input item and attempts to wrap it in wrapping paper acquired from nowhere
/obj/machinery/automation/wrapper
	name = "wrapper"
	desc = "Wraps items in wrapping paper."

/obj/machinery/automation/wrapper/Bumped(atom/movable/input)
	if(isitem(input))
		var/obj/item/I = input
		if(I.can_be_package_wrapped())
			var/obj/item/smallDelivery/P = new /obj/item/smallDelivery(get_step(src, outputdir))
			var/size = round(I.w_class)
			I.forceMove(P)
			P.name = "[weightclass2text(size)] parcel"
			P.w_class = size
			size = min(size, 5)
			P.icon_state = "deliverypackage[size]"
			adjust_item_drop_location(P)
			return
	if(istype (input, /obj/structure/closet))
		var/obj/structure/closet/O = input
		if(!O.opened && O.delivery_icon)
			var/obj/structure/bigDelivery/P = new /obj/structure/bigDelivery(get_step(src, outputdir))
			P.icon_state = O.delivery_icon
			O.forceMove(P)
			return

	playsound(src, "sparks", 75, 1, -1) //Item being bumped is too big to be put into the storage container
	..()
