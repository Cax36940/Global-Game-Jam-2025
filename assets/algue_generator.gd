extends Node2D

var algue_scene = preload("res://assets/algue.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(100):
		generate_worm()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func generate_worm():
	var instance = algue_scene.instantiate()
	instance.position.x = randf_range(0, get_viewport_rect().size.x)
	instance.position.y = get_viewport_rect().size.y - randf_range(-20, 0)
	add_child(instance)
