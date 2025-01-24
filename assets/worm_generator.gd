extends Node2D

var worm_scene = preload("res://assets/worm.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_worm()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func generate_worm():
	await get_tree().create_timer(.1).timeout
	var instance = worm_scene.instantiate()
	instance.position.y = randf_range(100, 600)
	add_child(instance)
	generate_worm()
