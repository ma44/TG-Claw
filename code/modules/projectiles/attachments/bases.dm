/obj/item/gun_attachment/base/assault
	gun_type = CUSTOMIZABLE_PROJECTILE
	name = "Assault Rifle Ballistic Base"
	icon_state = "base_projectile_assault"
	mag_type = /obj/item/ammo_box/magazine/guncrafting_ar
	the_item_state = "arg"

/obj/item/gun_attachment/base/pistol
	gun_type = CUSTOMIZABLE_PROJECTILE
	name = "Pistol Ballistic Base"
	icon_state = "base_projectile_pistol"
	mag_type = /obj/item/ammo_box/magazine/guncrafting_pistol
	the_item_state = "gun"

/obj/item/gun_attachment/base/shotgun
	gun_type = CUSTOMIZABLE_PROJECTILE
	name = "Shotgun Ballistic Base"
	icon_state = "base_projectile_shotgun1"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/guncrafting
	the_item_state = "shotgun"
	internal = 1

/obj/item/gun_attachment/base/shotgun_db
	gun_type = CUSTOMIZABLE_PROJECTILE
	name = "Double Barrel Shotgun Ballistic Base"
	icon_state = "base_projectile_shotgun2"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/dual
	the_item_state = "shotgun"
	internal = 1

/obj/item/gun_attachment/base/revolver_357
	gun_type = CUSTOMIZABLE_REVOLVER
	name = ".357 Revolver Ballistic Base"
	icon_state = "base_projectile_revolver2"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder
	the_item_state = "gun"
	internal = 1
	no_revolver = 0

/obj/item/gun_attachment/base/revolver_38
	gun_type = CUSTOMIZABLE_REVOLVER
	name = ".38 Special Revolver Ballistic Base"
	icon_state = "base_projectile_revolver1"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rev38
	the_item_state = "gun"
	internal = 1
	no_revolver = 0


/obj/item/gun_attachment/base/stun
	gun_type = CUSTOMIZABLE_ENERGY
	name = "Stun Energy Base"
	icon_state = "stun"
	energy_type = list(/obj/item/ammo_casing/energy/electrode)
	the_item_state = "taser4"

/obj/item/gun_attachment/base/htaser
	gun_type = CUSTOMIZABLE_ENERGY
	name = "Hybrid Taser Energy Base"
	icon_state = "stun"
	energy_type = list(/obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/disabler)
	the_item_state = "advtaserstun4"

/obj/item/gun_attachment/base/egun
	gun_type = CUSTOMIZABLE_ENERGY
	name = "Energy Gun Energy Base"
	icon_state = "ion"
	energy_type = list(/obj/item/ammo_casing/energy/disabler, /obj/item/ammo_casing/energy/lasergun)
	the_item_state = "energydisable4"

/obj/item/gun_attachment/base/laser
	gun_type = CUSTOMIZABLE_ENERGY
	name = "Laser Energy Base"
	icon_state = "laser"
	energy_type = list(/obj/item/ammo_casing/energy/lasergun)
	the_item_state = "laser"

/obj/item/gun_attachment/base/ion
	gun_type = CUSTOMIZABLE_ENERGY
	name = "Ioniser Energy Base"
	icon_state = "ion"
	energy_type = list(/obj/item/ammo_casing/energy/ion)
	the_item_state = "ionrifle4"

/obj/item/gun_attachment/base/disable
	gun_type = CUSTOMIZABLE_ENERGY
	name = "Disabler Energy Base"
	icon_state = "disable"
	energy_type = list(/obj/item/ammo_casing/energy/disabler)
	the_item_state = "disabler4"
/*
/obj/item/gun_attachment/base/bee
	gun_type = CUSTOMIZABLE_ENERGY
	name = "It's Hip To Shoot Bees Energy Base"
	icon_state = "bees"
	energy_type = list(/obj/item/ammo_casing/energy/bee)
*/
/obj/item/gun_attachment/base/xray
	gun_type = CUSTOMIZABLE_ENERGY
	name = "X-Ray Energy Base"
	icon_state = "xray"
	energy_type = list(/obj/item/ammo_casing/energy/xray)
	the_item_state = "xray4"

/obj/item/gun_attachment/base/tesla
	gun_type = CUSTOMIZABLE_ENERGY
	name = "Tesla Energy Base"
	icon_state = "special"
	energy_type = list(/obj/item/ammo_casing/energy/tesla_revolver)
	the_item_state = "tesla"