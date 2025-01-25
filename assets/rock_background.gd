extends Node2D

var rock_layer = preload("res://assets/rock_layer.tscn")
var worm_scene = preload("res://assets/worm.tscn")
var first_layer_depth : float = 1000
var layer_spacing : float = 500
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var viewport_half_width = get_viewport_rect().size.x / 2.0
	for i in range(12, 0, -1):
		var depth_coef : float = first_layer_depth / (first_layer_depth + (i-1) * layer_spacing)
		var instance = rock_layer.instantiate()
		var width = viewport_half_width - depth_coef * (viewport_half_width - 100)
		instance.set_width(width + 150)
		instance.set_velocity_factor(depth_coef)
		var color : Color = Color.from_hsv(0.6, 0.5, 0.6 - 0.05 * i)
		instance.set_color(color)
		instance.z_index = -2*i
		add_child(instance)
		
	generate_worm()
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func generate_worm():
	await get_tree().create_timer(.1).timeout
	var instance = worm_scene.instantiate()
	instance.position.x = randf_range(-100, 600)
	instance.position.y = randf_range(-1000, 0)
	instance.z_index = randi_range(-2, -24)
	instance.set_velocity_factor(first_layer_depth / (first_layer_depth + (-instance.z_index/2) * layer_spacing))
	add_child(instance)
	generate_worm()

func set_velocity(new_velocity : Vector2):
	for child in get_children():
		child.set_velocity(new_velocity)
