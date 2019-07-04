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
