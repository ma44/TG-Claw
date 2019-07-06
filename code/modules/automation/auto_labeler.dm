//Labels items like a hand labeler

/obj/machinery/automation/auto_label //Takes a recipe datum, accepts ingredients for them and makes it
	name = "auto labeler"
	desc = "Takes in items and labels them like a hand labeler. However if a crate is inserted, it will generate a manifest for it if it doesn't have one."
	var/to_label_on = ""

/obj/machinery/automation/auto_label/process()
	if(contents.len && isitem(contents[1]))
		if(to_label_on)
			contents[1].name = "[contents[1].name] ([to_label_on])"
			playsound(loc, 'sound/machines/ping.ogg', 30, 1)
			contents[1].loc = get_step(src, outputdir)
		else
			playsound(loc, 'sound/machines/ping.ogg', 30, 1)
			contents[1].loc = get_step(src, outputdir)

	else
		if(contents.len && istype(contents[1], /obj/structure/closet/crate))
			var/obj/structure/closet/crate/acrate = contents[1]
			if(!acrate.manifest)
				var/obj/item/paper/P = new(acrate)
				P.name = "crate content manifest"
				P.info += "<h2>Crate Content List</h2><br/>"
				for(var/atom/movable/AM in acrate.contents - P)
					P.info += "<li>AM.name</li>"
					P.info += "<br/>"
				P.forceMove(acrate)
				acrate.manifest = P
				acrate.update_icon()
			playsound(loc, 'sound/machines/ping.ogg', 30, 1)
			acrate.loc = get_step(src, outputdir)

/obj/machinery/automation/auto_label/Bumped(atom/input)
	if(isitem(input) || istype(input, /obj/structure/closet/crate))
		contents += input
	..()

/obj/machinery/automation/auto_label/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
  ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
  if(!ui)
    ui = new(user, src, ui_key, "auto_label", "Automatic Labeling Machine", 600, 800, master_ui, state)
    ui.open()

/obj/machinery/automation/auto_label/ui_data(mob/user)
	var/list/data = list()
	data["current_label"] = to_label_on
	return data

/obj/machinery/automation/auto_label/ui_act(action, params)
	if("change_name")
		name_of_output = stripped_input(usr,"New label: ","Input a custom label!", "", MAX_NAME_LEN)
		. = TRUE
