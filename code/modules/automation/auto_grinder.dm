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
