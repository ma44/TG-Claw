//An attempt at a assembly line for the vault or possibly as a wasteland ruin, put in recycling due to proximity towards conveyors

//Basic parent type that handles inserting objects into itself when getting Bumped() and changing output direction with multitool
/obj/machinery/automation
	name = "Shouldn't exist reeeee"
	var/outputdir = SOUTH //Outputs finished stuff south by default
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

/obj/machinery/automation/ui_data(mob/user)
	var/list/data = list()
	data["name_of_output"] = name_of_output
	data["current_output"] = output_container.name
	data["current_amount_to_dispense"] = amount_to_transfer
	return data

/obj/machinery/automation/ui_act(action, params)