extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$RockBackground.position.y = $Bubble.position.y - get_viewport_rect().size.y / 2
	$RockBackground.position.x = $Bubble.position.x - get_viewport_rect().size.x / 2
