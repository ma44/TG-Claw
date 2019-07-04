//A machine that takes items, puts it into a storage container then outputs it
//Should be expanded so it can say put them into crates or wrapping paper
/obj/machinery/automation/packager
	name = "packager"
	desc = "Takes items and puts them into cardboard boxes."
	var/package_type = /obj/item/storage/box
	var/obj/item/storage/current_package
	var/box_is_full = FALSE //So we can output it every process() instead of every Bumped()
	var/dispense_at_item_amount = 0 //If it's at zero, we output only when it fails to insert anything

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
	..()

/obj/machinery/automation/packager/process()
	..()
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
			var/datum/component/storage/compon_storage = current_package.GetComponent(/datum/component/storage)
			dispense_at_item_amount = CLAMP(round(input(usr, "Put 0 as the amount of items if you wish for the box to be outputted as soon as it's full.", "How many items?") as num|null), 0, compon_storage.max_items)
	update_icon()
