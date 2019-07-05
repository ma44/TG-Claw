//An automatic chem filter; think of it like a automated chem master somewhat
//Takes a reagent container as a input and will remove chemicals that don't fit with the inputted chem macro
//Alternatively, the machine can also remove certain reagents VIA chem macro input instead of making reagents like a chem macro

#define FILTER_INTO 0
#define FILTER_OUT 1

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
						processing.reagents.remove_reagent(reagent.id, 0, processing.reagents.get_reagent_amount(reagent.id) - reagents_to_save.[reagent.id], TRUE) //Remove any excess reagent
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

/obj/machinery/automation/chem_filter/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
  if(!ui)
    ui = new(user, src, ui_key, "auto_chem_filter", "Automatic Chemical Filtering Machine", 600, 800, master_ui, state)
    ui.open()

/obj/machinery/automation/chem_filter/ui_data(mob/user)
	var/list/data = list()
	if(current_mode)
		data["current_mode"] = "filter into"
	else
		data["current_mode"] = "filter out"
	data["current_chem_macro"] = current_chem_macro
	return data

/obj/machinery/automation/chem_filter/ui_act(action, params)
	if(..())
		return

	switch(action)
		if("toggle_mode")
			if(current_mode)
				current_mode = FILTER_INTO
			else
				current_mode = FILTER_OUT
			. = TRUE

		if("change_macro")
			current_chem_macro = stripped_input(usr,"Recipe","Insert the chem macro with chem IDs")
			. = TRUE
	update_icon()

