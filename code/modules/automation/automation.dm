//An attempt at a assembly line for the vault or possibly as a wasteland ruin, put in recycling due to proximity towards conveyors

//Basic parent type that handles inserting objects into itself when getting Bumped() and changing output direction with multitool
/obj/machinery/automation
	name = "Shouldn't exist reeeee"
	var/list/outputdir = list(SOUTH) //Outputs finished stuff south by default
	var/has_multi_output = FALSE //If it can support multiple output directions or not, used mainly for the item splitter
	var/list/inputdir = list(NORTH, WEST, EAST) //Any direction except the same dir of output is allowed
	icon = 'icons/obj/recycling.dmi'
	icon_state = "grinder-o0"
	density = TRUE
	speed_process = TRUE //Every 0.2 seconds instead of 2

/obj/machinery/automation/examine(mob/user)
	..()
	to_chat(user, "<span class='notice'>It's currently outputting products in the direction of [dir2text(outputdir)].</span>")

/obj/machinery/automation/Bumped(atom/input)
	if(!((get_dir(src, input) in inputdir)))
		return ..()

/obj/machinery/automation/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
  if(!ui)
    ui = new(user, src, ui_key, "auto_template", "TEMPLATE DON'T USE", 600, 800, master_ui, state)
    ui.open()

/obj/machinery/automation/ui_data(mob/user)
	var/list/data = list()
	data["inputdir"] = list()
	data["outputdir"] = list()
	data["removed_inputdir"] = list()
	data["removed_outputdir"] = list()
	for(var/dir in GLOB.cardinals)
		if(!(dir in inputdir))
			data["removed_inputdir"] += dir2text(dir)
		else
			data["inputdir"] += dir2text(dir)

		if(!(dir in outputdir))
			data["removed_outputdir"] += dir2text(dir)
		else
			data["outputdir"] += dir2text(dir)

	data["has_multi_output"] = has_multi_output
	return data

/obj/machinery/automation/ui_act(action, params)
	switch(action)
		if("add_input")
			if(params["new_dir"] && (params["new_dir"] in GLOB.cardinals && !(params["new_dir"] in inputdir)))
				inputdir += params["new_dir"]
			log_world("fail add input")
		if("add_output")
			if(params["new_dir"] && (params["new_dir"] in GLOB.cardinals))
				if(has_multi_output && !(params["new_dir"] in outputdir))
					outputdir += params["new_dir"]
				else
					outputdir = list(params["new_dir"])

		if("remove_input")
			if(params["new_dir"] && (params["new_dir"] in GLOB.cardinals && !(params["new_dir"] in inputdir)))
				inputdir -= params["new_dir"]

		if("remove_output")
			if(has_multi_output && params["new_dir"] && (params["new_dir"] in GLOB.cardinals) && (params["new_dir"] in outputdir))
				outputdir = list(params["new_dir"])
			else
				outputdir = list()
