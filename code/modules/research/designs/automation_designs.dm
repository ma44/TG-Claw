/datum/techweb_node/automation //A node that contains all of the automation things
	id = "automation"
	display_name = "Automated Assembly Line Technology"
	description = "A basic kit for automating just about nearing everything."
	prereq_ids = list("base")
	design_ids = list("auto_package", "auto_wrapper", "auto_label", "auto_grinder", "auto_crafter", "auto_chem_filter")
	research_costs = list(TECHWEB_POINT_TYPE_AUTOMATION = 2500)

/datum/design/board/automation
	category = list ("Engineering Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/board/automation/packager
	name = "Machine Design (Auto Packager Board)"
	desc = "The circuit board for an automatic packager."
	id = "auto_package"
	build_path = /obj/item/circuitboard/machine/automation/packager

/datum/design/board/automation/wrapper
	name = "Machine Design (Auto Wrapper Board)"
	desc = "The circuit board for an automatic wrapper."
	id = "auto_wrapper"
	build_path = /obj/item/circuitboard/machine/automation/wrapper

/datum/design/board/automation/label
	name = "Machine Design (Auto Label Board)"
	desc = "The circuit board for an automatic labeler."
	id = "auto_label"
	build_path = /obj/item/circuitboard/machine/automation/label

/datum/design/board/automation/grinder
	name = "Machine Design (Auto Grinder Board)"
	desc = "The circuit board for an automatic grinder."
	id = "auto_grinder"
	build_path = /obj/item/circuitboard/machine/automation/grinder

/datum/design/board/automation/crafter
	name = "Machine Design (Auto Crafter Board)"
	desc = "The circuit board for an automatic crafter."
	id = "auto_crafter"
	build_path = /obj/item/circuitboard/machine/automation/crafter

/datum/design/board/automation/chem_filter
	name = "Machine Design (Auto Chem Filter Board)"
	desc = "The circuit board for an automatic chem filter."
	id = "auto_chem_filter"
	build_path = /obj/item/circuitboard/machine/automation/chem_filter
