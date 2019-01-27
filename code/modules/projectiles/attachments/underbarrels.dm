/obj/item/gun_attachment/underbarrel
	not_okay = /obj/item/gun_attachment/underbarrel
	no_revolver = 0

/obj/item/gun_attachment/underbarrel/bayonet
	name = "Bayonet"
	desc = "Great for stabbing."
	icon_state = "attach_underbarrel_bayonet"

/obj/item/gun_attachment/underbarrel/bayonet/on_attach(var/obj/item/gun/owner)
	..()
	owner.force += 10

/obj/item/gun_attachment/underbarrel/bayonet/on_remove(var/obj/item/gun/owner)
	..()
	owner.force -= 10