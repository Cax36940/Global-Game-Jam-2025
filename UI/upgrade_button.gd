extends Button

# this script only deals with the visuals of the ugrade button

@export var button_up_icon: Texture2D
@export var button_down_icon: Texture2D

@export var default_color: Color
@export var mouse_over_color: Color

func _ready() -> void:
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	self.button_down.connect(_on_button_down)
	self.button_up.connect(_on_button_up)
	self.focus_entered.connect(_on_mouse_entered)
	self.focus_exited.connect(_on_mouse_exited)
	
	$NinePatchRect.modulate = default_color
	$NinePatchRect.texture = button_up_icon


func set_upgrade_txt(cost: int, lvl: int, value: float):
	$VBoxContainer/Cost.text = "Prix : " + str(cost) + " NaCl"
	$VBoxContainer/Level.text = "Niveau " + str(lvl)
	$VBoxContainer/Value.text = "Valeur " + str(value)


func _on_mouse_entered() -> void:
	$NinePatchRect.modulate = mouse_over_color


func _on_mouse_exited() -> void:
	$NinePatchRect.modulate = default_color


func _on_button_down() -> void:
	$NinePatchRect.texture = button_down_icon


func _on_button_up() -> void:
	$NinePatchRect.texture = button_up_icon
