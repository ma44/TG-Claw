//A machine that takes items, puts it into a storage container then outputs it
//Should be expanded so it can say put them into crates or wrapping paper
/obj/machinery/automation/packager
	name = "packager"
	desc = "Takes items and puts them into cardboard boxes."
	var/package_type = /obj/item/storage/box
	var/current_package
	var/box_is_full = FALSE //So we can output it every process() instead of every Bumped()
	var/dispense_at_item_amount = 0 //If it's at zero, we output only when it fails to insert anything
	radial_categories = list(
	"Change Container Type",
	"Adjust Item Threshold"
	)

/obj/machinery/automation/packager/Initialize()
	. = ..()
	current_package = new package_type
	radial_categories["Change Container Type"] = image(icon = 'icons/mob/radial.dmi', icon_state = "auto_change_container")
	radial_categories["Adjust Item Threshold"] = image(icon = 'icons/mob/radial.dmi', icon_state = "auto_change_threshold")

/obj/machinery/automation/packager/examine(mob/user)
	. = ..()
	if(.)
		to_chat(user, "<span class='notice'>Current container type: <span class='bold'>[package_type ? "[package_type.name]" : "No package selected!!!"]</span></span>")
		to_chat(user, "<span class='notice'>Current Item Threshold: <span class='bold'>[dispense_at_item_amount ? "[dispense_at_item_amount] items" : "as many items into the box as possible"]</span></span>")

/obj/machinery/automation/packager/MakeRadial(mob/living/user)
	var/category = show_radial_menu(user, src, radial_categories, null, require_near = TRUE)
	if(category)
		switch(category)
			if("Adjust Item Threshold")
				if(istype(current_package, /obj/item/storage))
					var/datum/component/storage/compon_storage = current_package.GetComponent(/datum/component/storage)
					dispense_at_item_amount = CLAMP(round(input(usr, "Put 0 as the amount of items if you wish for the box to be outputted as soon as it's full.", "How many items?") as num|null), 0, compon_storage.max_items)
				else
					var/obj/structure/closet/current_package2 = currentpackage
					dispense_at_item_amount = CLAMP(round(input(usr, "Put 0 as the amount of items if you wish for the box to be outputted as soon as it's full.", "How many items?") as num|null), 0, current_package2.storage_capacity)



//Outputs the package and inits it again
/obj/machinery/automation/packager/proc/output_package()
	current_package.loc = get_step(src, outputdir)
	playsound(loc, 'sound/machines/ping.ogg', 30, 1)
	current_package = new package_type
	box_is_full = FALSE

/obj/machinery/automation/packager/Bumped(atom/input)
	if(isitem(input))
		var/obj/item/item = input
		if(istype(current_package, /obj/item/storage))
			var/datum/component/storage/compon_storage = current_package.GetComponent(/datum/component/storage)
			if(compon_storage && compon_storage.max_w_class >= item.w_class)
				if(!SEND_SIGNAL(current_package, COMSIG_TRY_STORAGE_INSERT, item, null, FALSE, FALSE)) //If it can't fit inside the box because not enough space, output box
					box_is_full = TRUE
					return

		else
			if(istype(current_package, /obj/structure/closet))
				if(current_package.contents.len + 1 < dispense_at_item_amount)
					current_package.insert(item)
				else
					box_is_full = TRUE
	..()

/obj/machinery/automation/packager/process()
	..()
	if(istype(current_package, /obj/item/storage))
		var/datum/component/storage/compon_storage = current_package.GetComponent(/datum/component/storage)
		//Copypasta electric boogaloo
		var/sum_w_class = 0
		var/atom/source_real_location = compon_storage.real_location()
		for(var/obj/item/I in source_real_location)
			sum_w_class += I.w_class //Adds up the combined w_classes which will be in the storage item if the item is added to it.
		if(dispense_at_item_amount && source_real_location.contents.len >= dispense_at_item_amount)
			output_package()
		else
			if(box_is_full || compon_storage.max_combined_w_class == sum_w_class || source_real_location.contents.len >= compon_storage.max_items)
				output_package()
	else
		if(istype(current_package, /obj/structure/locker))
			var/obj/structure/locker/box = current_package
			if(dispense_at_item_amount && box.len >= dispense_at_item_amount)
				output_package()
			else
				if(box.len == box.storage_capacity)
					output_package()

/obj/machinery/automation/packager/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
  ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
  if(!ui)
    ui = new(user, src, ui_key, "auto_packager", "Automatic Packager Machine", 600, 800, master_ui, state)
    ui.open()

/obj/machinery/automation/packager/ui_data(mob/user)
	var/list/data = list()
	data["current_package"] = current_package.name
	data["dispense_at_item_amount"] = dispense_at_item_amount
	return data

/obj/machinery/automation/packager/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("change_item_amount_dispense")
			if(istype(current_package, /obj/item/storage))
				var/datum/component/storage/compon_storage = current_package.GetComponent(/datum/component/storage)
				dispense_at_item_amount = CLAMP(round(input(usr, "Put 0 as the amount of items if you wish for the box to be outputted as soon as it's full.", "How many items?") as num|null), 0, compon_storage.max_items)
			else
				var/obj/structure/closet/current_package2 = currentpackage
				dispense_at_item_amount = CLAMP(round(input(usr, "Put 0 as the amount of items if you wish for the box to be outputted as soon as it's full.", "How many items?") as num|null), 0, current_package2.storage_capacity)
	update_icon()
