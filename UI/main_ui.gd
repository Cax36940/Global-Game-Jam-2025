class_name MainUI
extends CanvasLayer

@export var min_db_volume: float = -10
@export var max_db_volume: float = 10

var health = {
	base_cost = Currency.multiply(Currency.costs["H2"], 10),
	base_value = 1.0,
	lvl = 0,
	cost = Currency.new(0, 0, 10, 0),
	value = 1.0
}

var speed = {
	base_cost = Currency.multiply(Currency.costs["NaClO4"], 3),
	base_value = 1.0,
	lvl = 0,
	cost = Currency.new(1, 1, 0, 4),
	value = 1.0
}

var resistance = {
	base_cost = Currency.multiply(Currency.costs["NaCl"], 5),
	base_value = 0.0,
	lvl = 0,
	cost = Currency.new(1, 1, 0, 0),
	value = 0.0
}

var stock = {
	base_cost = Currency.multiply(Currency.costs["NaOH"], 3),
	base_value = 1.0,
	lvl = 0,
	cost = Currency.new(1, 0, 1, 1),
	value = 1.0
}

var na_amount = {
	base_cost = Currency.multiply(Currency.costs["O2"], 1),
	base_value = 1.0,
	lvl = 0,
	cost = Currency.new(0, 0, 0, 1),
	value = 1.0
}

var cl_amount = {
	base_cost = Currency.multiply(Currency.costs["O2"], 1),
	base_value = 1.0,
	lvl = 0,
	cost = Currency.new(0, 0, 0, 1),
	value = 1.0
}

func get_health(): return health.value
func get_speed(): return speed.value
func get_resistance(): return resistance.value
func get_stock(): return stock.value
func get_na_amount(): return na_amount.value
func get_cl_amount(): return cl_amount.value


func upgrade_stat(stat: Dictionary, cost_func: Callable, value_func: Callable):
	stat.lvl += 1
	stat.cost = cost_func.call(stat.base_cost, stat.lvl)
	stat.value = value_func.call(stat.base_value, stat.lvl)

var ui_positions = []
var in_settings = false

func _ready() -> void:
	# if implementing saves, load upgrade values
	health.lvl = 0
	health.cost = health.base_cost
	health.value = health.base_value
	speed.lvl = 0
	speed.cost = speed.base_cost
	speed.value = speed.base_value
	resistance.lvl = 0
	resistance.cost = resistance.base_cost
	resistance.value = resistance.base_value
	stock.lvl = 0
	stock.cost = stock.base_cost
	stock.value = stock.base_value
	$LeftBar/LeftUpgrades/HealthUpgradeButton.set_upgrade_txt(health.cost, health.lvl, health.value)
	$LeftBar/LeftUpgrades/SpeedUpgradeButton.set_upgrade_txt(speed.cost, speed.lvl, speed.value)
	$LeftBar/LeftUpgrades/ResistanceUpgradeButton.set_upgrade_txt(resistance.cost, resistance.lvl, resistance.value)
	$LeftBar/LeftUpgrades/StockUpgradeButton.set_upgrade_txt(stock.cost, stock.lvl, stock.value)
	$RightUpgrades/SkillUpgradeButton.set_upgrade_txt(na_amount.cost, na_amount.lvl, na_amount.value)
	$RightUpgrades/SkillUpgradeButton2.set_upgrade_txt(cl_amount.cost, cl_amount.lvl, cl_amount.value)
	
	# select first button for keyboard/gamepad navigation
	$LeftBar/LeftUpgrades/HealthUpgradeButton.grab_focus()
	
	ui_positions.append($LeftBar.position)
	ui_positions.append($RightUpgrades.position)
	ui_positions.append($GameTitle.position)
	ui_positions.append($Settings.position)
	ui_positions.append($StartButton.position)
	
	$Settings.visible = false


func start_game() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($LeftBar, "position", Vector2(-$LeftBar.size.x-ui_positions[0].x, ui_positions[0].y), 1)
	tween.tween_callback(hide_main_ui_callback)
	tween = get_tree().create_tween()
	tween.tween_property($RightUpgrades, "position", Vector2(ui_positions[1].x + $RightUpgrades.size.x + 2*ui_positions[0].x, ui_positions[1].y), 1)
	tween = get_tree().create_tween()
	tween.tween_property($GameTitle, "position", Vector2(ui_positions[2].x, -$GameTitle.size.y - ui_positions[2].y), 1)
	tween = get_tree().create_tween()
	tween.tween_property($StartButton, "position", Vector2(ui_positions[4].x, ui_positions[4].y + $StartButton.size.y + (get_viewport().get_visible_rect().size.y - ui_positions[4].y)), 1)

func hide_main_ui_callback() -> void:
	$LeftBar.visible = false
	$RightUpgrades.visible = false
	$GameTitle.visible = false
	$StartButton.visible = false


func show_main_ui() -> void:
	$LeftBar.visible = true
	$RightUpgrades.visible = true
	$GameTitle.visible = true
	$StartButton.visible = true
	$LeftBar.position = ui_positions[0]
	$RightUpgrades.position = ui_positions[1]
	$GameTitle.position = ui_positions[2]
	$StartButton.position = ui_positions[4]



func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_health_upgrade_button_pressed() -> void:
	if PlayerData.singleton == null or !PlayerData.singleton.try_buy_upgrade(health.cost):
		$LeftBar/LeftUpgrades/HealthUpgradeButton.buy_fail_animation()
		return
	
	upgrade_stat(health,
		func (base, lvl): return Currency.multiply(base, lvl**1.15 + 1),
		func (base, lvl): return base * (lvl / 2.0 + 1.0)
	)
	$LeftBar/LeftUpgrades/HealthUpgradeButton.set_upgrade_txt(health.cost, health.lvl, health.value)


func _on_speed_upgrade_button_pressed() -> void:
	if PlayerData.singleton == null or !PlayerData.singleton.try_buy_upgrade(speed.cost):
		$LeftBar/LeftUpgrades/SpeedUpgradeButton.buy_fail_animation()
		return
	
	upgrade_stat(speed, 
		func (base, lvl): return Currency.multiply(base, lvl + 1), 
		func (base, lvl): return base * (lvl + 1.0)
	)
	$LeftBar/LeftUpgrades/SpeedUpgradeButton.set_upgrade_txt(speed.cost, speed.lvl, speed.value)


func _on_resistance_upgrade_button_pressed() -> void:
	if PlayerData.singleton == null or !PlayerData.singleton.try_buy_upgrade(resistance.cost):
		$LeftBar/LeftUpgrades/ResistanceUpgradeButton.buy_fail_animation()
		return
	
	upgrade_stat(resistance, 
		func (base, lvl): return Currency.multiply(base, lvl + 1), 
		func (base, lvl): return 1.0 / (1.0 + exp(2.0 - lvl/2.0)) * 0.8
	)
	$LeftBar/LeftUpgrades/ResistanceUpgradeButton.set_upgrade_txt(resistance.cost, resistance.lvl, resistance.value)


func _on_stock_upgrade_button_pressed() -> void:
	if PlayerData.singleton == null or !PlayerData.singleton.try_buy_upgrade(stock.cost):
		$LeftBar/LeftUpgrades/StockUpgradeButton.buy_fail_animation()
		return
	
	upgrade_stat(stock, 
		func (base, lvl): return Currency.multiply(base, lvl + 1), 
		func (base, lvl): return base * (lvl / 2.0 + 1.0)
	)
	$LeftBar/LeftUpgrades/StockUpgradeButton.set_upgrade_txt(stock.cost, stock.lvl, stock.value)


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), value == 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value/100.0 * (max_db_volume-min_db_volume) + min_db_volume)


func _on_settings_button_pressed() -> void:
	if in_settings:
		hide_settings()
	else:
		show_settings()


func show_settings() -> void:
	$Settings.visible = true
	in_settings = true
	var tween = get_tree().create_tween()
	tween.tween_property($Settings, "position", Vector2(ui_positions[3].x, -ui_positions[3].y-$Settings.size.y), .5).set_trans(Tween.TRANS_SPRING)


func hide_settings() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Settings, "position", Vector2(ui_positions[3].x, ui_positions[3].y), .5).set_trans(Tween.TRANS_SPRING)
	tween.tween_callback(_hide_settings_callback)


func _hide_settings_callback() -> void:
	$Settings.visible = false
	in_settings = false


func update_stats(max_distance: int, previous_distance: int, total_distance_traveled: int) -> void:
	$LeftBar/Stats/StatDstMax.text = "Distance max atteinte : -" + str(max_distance)
	$LeftBar/Stats/StatDstPrev.text = "Distance run précédente : -" + str(previous_distance)
	$LeftBar/Stats/StatTotDst.text = "Distance totale parcourue : " + str(total_distance_traveled)

signal start_button_pressed
func _on_start_button_pressed() -> void:
	start_button_pressed.emit()


func _on_skill_upgrade_button_pressed() -> void:
	if PlayerData.singleton == null or !PlayerData.singleton.try_buy_upgrade(na_amount.cost):
		$RightUpgrades/SkillUpgradeButton.buy_fail_animation()
		return
	
	upgrade_stat(na_amount, 
		func (base, lvl): return Currency.multiply(base, lvl**1.5 + 1), 
		func (base, lvl): return base + lvl/10.0
	)
	$RightUpgrades/SkillUpgradeButton.set_upgrade_txt(na_amount.cost, na_amount.lvl, na_amount.value)


func _on_skill_upgrade_button_2_pressed() -> void:
	if PlayerData.singleton == null or !PlayerData.singleton.try_buy_upgrade(cl_amount.cost):
		$RightUpgrades/SkillUpgradeButton2.buy_fail_animation()
		return
	
	upgrade_stat(cl_amount, 
		func (base, lvl): return Currency.multiply(base, lvl**1.5 + 1), 
		func (base, lvl): return base + lvl/10.0
	)
	$RightUpgrades/SkillUpgradeButton2.set_upgrade_txt(cl_amount.cost, cl_amount.lvl, cl_amount.value)
