//An attempt at a assembly line for the vault or possibly as a wasteland ruin, put in recycling due to proximity towards conveyors

//Basic parent type that handles inserting objects into itself when getting Bumped() and changing output direction with multitool
/obj/machinery/automation
	name = "Shouldn't exist reeeee"
	var/outputdir = SOUTH //Outputs finished stuff south by default
	icon = 'icons/obj/recycling.dmi'
	icon_state = "grinder-o0"
	density = TRUE
	speed_process = TRUE //Every 0.2 seconds instead of 2

/obj/machinery/automation/examine(mob/user)
	..()
	to_chat(user, "<span class='notice'>It's currently outputting products in the direction of [dir2text(outputdir)].</span>")

/obj/machinery/automation/Bumped(atom/input)
	if(!((get_dir(src, input) == outputdir)))
		return ..()
	else
		contents += input

/obj/machinery/automation/multitool_act(mob/living/user, obj/item/multitool)
	if(get_dir(src, user) in GLOB.cardinals)
		to_chat(user, "You set the output of the machine to [get_dir(src, user)].")
		outputdir = get_dir(src, user)
