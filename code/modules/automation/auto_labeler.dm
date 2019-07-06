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
