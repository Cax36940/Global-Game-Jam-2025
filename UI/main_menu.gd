extends Control

var health = {
	base_cost = 10,
	base_value = 1.0,
	lvl = 0,
	cost = 10,
	value = 1.0
}


func upgrade_health():
	health.lvl += 1
	health.cost = health.base_cost * (health.lvl + 1)
	health.value = health.base_value * (health.lvl / 2.0 + 1.0)
	$HealthUpgradeButton.set_upgrade_gfx(health.cost, health.lvl, health.value)


func _ready() -> void:
	# if implementing saves, load upgrade values
	health.lvl = 0
	health.cost = health.base_cost
	health.value = health.base_value
	$HealthUpgradeButton.set_upgrade_gfx(health.cost, health.lvl, health.value)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_health_upgrade_button_pressed() -> void:
	upgrade_health()
