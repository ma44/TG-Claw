//An automatic chem filter; think of it like a automated chem master somewhat
//Takes a reagent container as a input and will remove chemicals that don't fit with the inputted chem macro
//Alternatively, the machine can also remove certain reagents VIA chem macro input instead of making reagents like a chem macro

#define FILTER_INTO 1
#define FILTER_OUT 2

/obj/machinery/automation/chem_filter
	name = "automatic chem filter"
	desc = "A machine used for the filteration of inputted reagent containers."
	var/current_mode = FILTER_INTO //filter_out is the other possible one
	var/current_chem_macro = "eznutriment=5"

/obj/machinery/automation/chem_filter/Bumped(atom/movable/input)
	var/obj/item/I = input
	if(istype(I) && I.reagents && current_chem_macro)
		contents += I //We add it to ourself later for processing
	..()

/obj/machinery/automation/chem_filter/process()
	..()
	if(contents.len && current_chem_macro)
		var/obj/item/processing = contents[1]
		switch(current_mode)
			if(FILTER_INTO)
				var/list/reagents_to_save = process_recipe_list(current_chem_macro)
				for(var/datum/reagent/reagent in processing.reagents.reagent_list)
					if(reagents_to_save[reagent.id])
						processing.reagents.remove_reagent(reagent.id, max(0, processing.reagents.get_reagent_amount(reagent.id) - reagents_to_save.[reagent.id], TRUE) //Remove any excess reagent
					else
						processing.reagents.del_reagent(reagent.id)

				playsound(loc, 'sound/machines/ping.ogg', 30, 1)
				processing.loc = get_step(src, outputdir)

			if(FILTER_OUT)
				var/list/reagents_to_remove = process_recipe_list(current_chem_macro)
				for(var/r_id in reagents_to_remove)
					processing.reagents.remove_reagent(r_id, reagents_to_remove[r_id])
				playsound(loc, 'sound/machines/ping.ogg', 30, 1)
				processing.loc = get_step(src, outputdir)
