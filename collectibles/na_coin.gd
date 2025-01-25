extends StaticBody2D

var rotation_speed : float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation_speed = randf_range(-1., 1.)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation += rotation_speed * delta
	pass
