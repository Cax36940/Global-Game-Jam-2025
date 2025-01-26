extends Node2D

var plastic_scene = preload("res://collectibles/plastic.tscn")

const MAX_OBSTACLES : int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func start_generation():
	generate_obstacles()

func reset():
	for node in get_children():
		remove_child(node)
		node.queue_free() 

func generate_obstacles() -> void :
	await get_tree().create_timer(randf_range(5., 11.)).timeout
	clear_obs()

	var random_int : int = randi_range(0, 100)
	
	var instance_position : Vector2 = get_node("../Bubble").position
	instance_position.x += get_node("../Bubble").HSPEED * get_node("../Bubble").hspeed_mult * randf_range(-3, 3)
	instance_position.y += 100 + min(get_node("../Bubble").velocity.y, -50) * 20
	
	if random_int >= 15 :
		var instance : Node2D = plastic_scene.instantiate()
		instance.position = instance_position
		add_child(instance)
		generate_obstacles()
		return
		
	generate_obstacles()

func clear_obs() -> void :
	for child in get_children():
		if child.position.y > get_node("../Bubble").position.y - get_node("../Bubble").velocity.y * 10:
			call_deferred("remove_child", child)
			child.call_deferred("queue_free")
