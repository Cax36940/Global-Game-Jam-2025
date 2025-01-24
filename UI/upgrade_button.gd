extends Button

# this script only deals with the visuals of the ugrade button

func set_upgrade_gfx(cost: int, lvl: int, value: float):
	$VBoxContainer/Cost.text = "Prix : " + str(cost) + " NaCl"
	$VBoxContainer/Level.text = "Niveau " + str(lvl)
	$VBoxContainer/Value.text = "Valeur " + str(value)
