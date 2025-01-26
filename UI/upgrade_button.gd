extends Button

# this script only deals with the visuals of the ugrade button

@export var button_up_icon: Texture2D
@export var button_down_icon: Texture2D

@export var default_color: Color
@export var mouse_over_color: Color
@export var buy_fail_color: Color

func _ready() -> void:
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	self.button_down.connect(_on_button_down)
	self.button_up.connect(_on_button_up)
	self.focus_entered.connect(_on_mouse_entered)
	self.focus_exited.connect(_on_mouse_exited)
	$AnimationPlayer.animation_finished.connect(_on_animation_player_animation_finished)
	
	$gfx.modulate = default_color
	$gfx.texture = button_up_icon


func set_upgrade_txt(cost: Currency, lvl: int, value: float):
	$VBoxContainer/Cost.text = "Prix : " + Currency.parse_from_costs(cost)
	$VBoxContainer/Level.text = "Niveau " + str(lvl)
	$VBoxContainer/Value.text = "Valeur %.2f" % [value]


var _is_animating = false
func buy_fail_animation() -> void:
	_is_animating = true
	$gfx.modulate = buy_fail_color
	
	$AnimationPlayer.play("ui_shake_animation")


func _on_mouse_entered() -> void:
	if _is_animating: return
	$gfx.modulate = mouse_over_color


func _on_mouse_exited() -> void:
	if _is_animating: return
	$gfx.modulate = default_color


func _on_button_down() -> void:
	$gfx.texture = button_down_icon


func _on_button_up() -> void:
	$gfx.texture = button_up_icon


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	var tween = get_tree().create_tween()
	if is_hovered() or has_focus():
		tween.tween_property($gfx, "modulate", mouse_over_color, .5)
	else:
		tween.tween_property($gfx, "modulate", default_color, .5)
	_is_animating = false
