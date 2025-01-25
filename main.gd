extends Node2D


var handpan = preload("res://sfx/hang.ogg")
var ambient = preload("res://sfx/underwater-ambience.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer2D.play()
	$AudioStreamPlayer2D2.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$RockBackground.position.y = $Bubble.position.y - get_viewport_rect().size.y / 2
	$RockBackground.position.x = $Bubble.position.x - get_viewport_rect().size.x / 2
