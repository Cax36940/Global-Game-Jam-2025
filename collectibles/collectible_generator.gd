extends Node2D

var na_scene = preload("res://collectibles/na_coin.tscn")
var cl_scene = preload("res://collectibles/cl_coin.tscn")
var nacl_scene = preload("res://collectibles/nacl_coin.tscn")

const MAX_NA : int = 10
const MAX_CL : int = 10
const MAX_NACL : int = 1 #Keep it to 1 otherwise display is glitched

var main_ui

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_ui = $"../MainUI"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func start_generation():
	generate_collectible()

func reset():
	for node in $NaCoins.get_children():
		$NaCoins.remove_child(node)
		node.queue_free() 
		
	for node in $ClCoins.get_children():
		$ClCoins.remove_child(node)
		node.queue_free() 
		
	for node in $NaClCoins.get_children():
		$NaClCoins.remove_child(node)
		node.queue_free() 

func generate_collectible() -> void :
	var t = randf_range(4., 6.) * 2.0/(main_ui.get_na_amount() + main_ui.get_cl_amount())
	await get_tree().create_timer(t).timeout
	clear_coins()
	var na_space : int = MAX_NA * main_ui.get_na_amount() - $NaCoins.get_child_count()
	var cl_space : int = MAX_CL * main_ui.get_cl_amount() - $ClCoins.get_child_count()
	var nacl_space : int = MAX_NACL - $NaClCoins.get_child_count()
	
	var total_space : int = na_space + cl_space + nacl_space
	var random_int : int = randi_range(0, total_space)
	
	if random_int == 0 :
		generate_collectible()
		return
	
	var bubble = get_node("../Bubble")
	var instance_position : Vector2 = bubble.position
	var instance_velocity : Vector2 = Vector2(0, bubble.velocity.y)
	instance_position.x += bubble.HSPEED * bubble.hspeed_mult * randf_range(-3, 3)
	instance_position.y += min(bubble.velocity.y, -50) * 2
	instance_velocity.y *= randf_range(0.4, 0.6)

	random_int -= na_space
	
	if random_int <= 0 :
		var instance : Node2D = na_scene.instantiate()
		$NaCoins.add_child(instance)
		instance.position = instance_position
		instance.velocity = instance_velocity
		generate_collectible()
		return
	
	random_int -= cl_space
	
	if random_int <= 0 :
		var instance : Node2D = cl_scene.instantiate()
		$ClCoins.add_child(instance)
		instance.position = instance_position
		instance.velocity = instance_velocity
		generate_collectible()
		return
	
	random_int -= nacl_space
	
	if random_int <= 0 :
		var instance : Node2D = nacl_scene.instantiate()
		$NaClCoins.add_child(instance)
		instance.position = instance_position
		instance.velocity = instance_velocity
		generate_collectible()
		return
	
	generate_collectible()

func clear_coins() -> void :
	for child in $NaCoins.get_children():
		if child.position.y > get_node("../Bubble").position.y - get_node("../Bubble").velocity.y * 10:
			$NaCoins.call_deferred("remove_child", child)
			child.call_deferred("queue_free")
	
	for child in $ClCoins.get_children():
		if child.position.y > get_node("../Bubble").position.y - get_node("../Bubble").velocity.y * 10:
			$ClCoins.call_deferred("remove_child", child)
			child.call_deferred("queue_free")
	
	for child in $NaClCoins.get_children():
		if child.position.y > get_node("../Bubble").position.y - get_node("../Bubble").velocity.y * 10:
			$NaClCoins.call_deferred("remove_child", child)
			child.call_deferred("queue_free")
