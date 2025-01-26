extends Node2D


var handpan = preload("res://sfx/hang.ogg")
var ambient = preload("res://sfx/underwater-ambience.wav")

var is_in_game = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer2D.play()
	$AudioStreamPlayer2D2.play()
	$Bubble.set_can_update(is_in_game)
	$Bubble.bubble_died.connect(on_end_game)


func on_end_game() -> void:
	$MainUI.show_main_ui()
	is_in_game = false
	$Bubble.set_can_update(is_in_game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !is_in_game:
		if Input.is_action_just_pressed("ui_cancel"):
			$MainUI.start_game()
			is_in_game = true
			$Bubble.set_can_update(is_in_game)
			$CollectibleGenerator.start_generation()
			
	
	$RockBackground.position.y = $Bubble.position.y - get_viewport_rect().size.y / 2
	$RockBackground.position.x = $Bubble.position.x - get_viewport_rect().size.x / 2
