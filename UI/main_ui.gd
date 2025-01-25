class_name MainUI
extends Control

var health = {
	base_cost = 10,
	base_value = 1.0,
	lvl = 0,
	cost = 10,
	value = 1.0
}

var resistance = {
	base_cost = 10,
	base_value = 1.0,
	lvl = 0,
	cost = 10,
	value = 1.0
}

var speed = {
	base_cost = 10,
	base_value = 1.0,
	lvl = 0,
	cost = 10,
	value = 1.0
}

func get_health(): return health.value
func get_speed(): return speed.value
func get_resistance(): return resistance.value

func upgrade_stat(stat: Dictionary, cost_func: Callable, value_func: Callable):
	stat.lvl += 1
	stat.cost = cost_func.call(stat.base_cost, stat.lvl)
	stat.value = value_func.call(stat.base_value, stat.lvl)


func _ready() -> void:
	# if implementing saves, load upgrade values
	health.lvl = 0
	health.cost = health.base_cost
	health.value = health.base_value
	resistance.lvl = 0
	resistance.cost = resistance.base_cost
	resistance.value = resistance.base_value
	speed.lvl = 0
	speed.cost = speed.base_cost
	speed.value = speed.base_value
	$GridContainer/HealthUpgradeButton.set_upgrade_gfx(health.cost, health.lvl, health.value)
	$GridContainer/ResistanceUpgradeButton.set_upgrade_gfx(resistance.cost, resistance.lvl, resistance.value)
	$GridContainer/SpeedUpgradeButton.set_upgrade_gfx(speed.cost, speed.lvl, speed.value)
	


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_health_upgrade_button_pressed() -> void:
	upgrade_stat(health, 
		func (base, lvl): return base * (lvl + 1), 
		func (base, lvl): return base * (lvl / 2.0 + 1.0)
	)
	$GridContainer/HealthUpgradeButton.set_upgrade_gfx(health.cost, health.lvl, health.value)


func _on_resistance_upgrade_button_pressed() -> void:
	upgrade_stat(resistance, 
		func (base, lvl): return base * (lvl + 1), 
		func (base, lvl): return base * (lvl / 2.0 + 1.0)
	)
	$GridContainer/ResistanceUpgradeButton.set_upgrade_gfx(resistance.cost, resistance.lvl, resistance.value)


func _on_speed_upgrade_button_pressed() -> void:
	upgrade_stat(speed, 
		func (base, lvl): return base * (lvl + 1), 
		func (base, lvl): return base * (lvl / 2.0 + 1.0)
	)
	$GridContainer/SpeedUpgradeButton.set_upgrade_gfx(speed.cost, speed.lvl, speed.value)
