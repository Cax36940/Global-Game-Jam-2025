extends Node2D

var geyser_scene = preload("res://collectibles/geyser.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var position_y = -356 - 900 * 50
	for i in range(19):
		var instance = geyser_scene.instantiate()
		var rand_x = randf_range(200, 500)
		instance.position.x = rand_x
		var rand_value = randi_range(0, 1)
		
		if rand_value == 1:
			instance.position.x *= -1
			instance.scale.x *= -1
		instance.position.y = position_y
		add_child(instance)
		position_y -= 500 * 50
		
	pass # Replace with function body.
