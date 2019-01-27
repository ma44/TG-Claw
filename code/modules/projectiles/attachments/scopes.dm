/obj/item/gun_attachment/scope
	var/range = 3
	not_okay = /obj/item/weapon/gun_attachment/scope
	no_revolver = 0

/obj/item/gun_attachment/scope/on_attach(var/obj/item/gun/owner)
	..()
	owner.zoomable = TRUE
	owner.zoom_amt = range
	owner.build_zooming()

/obj/item/gun_attachment/scope/on_remove(var/obj/item/gun/owner)
	..()
	owner.zoomable = FALSE
	owner.zoom_amt = initial(owner.zoom_amt)
	qdel(owner.azoom)
	owner.azoom = null

/obj/item/gun_attachment/scope/reflex
	name = "Reflex Sight"
	desc = "A reflex sight."
	icon_state = "attach_scope_reflex"
	range = 3

/obj/item/gun_attachment/scope/red_dot
	name = "Red Dot Sight"
	desc = "A red dot sight."
	icon_state = "attach_scope_reddot"
	range = 5

/obj/item/gun_attachment/scope/sniper
	name = "Sniper Sight"
	desc = "A sniper sight."
	icon_state = "attach_scope_sniper"
	range = 7
