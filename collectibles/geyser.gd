extends Node2D


const BUBBLITA_PER_SEC = 2.0
var bubblita_scene = preload("res://collectibles/bubblita.tscn")
var initial_bubblita_mean_speed = Vector2(0, 0)

var total_time : float = randf_range(0, 10)
var initial_position : Vector2

func create_bubblita():
	var bubblita = bubblita_scene.instantiate()
	var vx = initial_bubblita_mean_speed.x + randfn(0.0, 0.1)
	var vy = initial_bubblita_mean_speed.y + randfn(0.0, 0.1)
	bubblita.velocity.x = vx
	bubblita.velocity.y = vy
	bubblita.scale *= randf_range(0.5, 1.0)
	add_child(bubblita)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_position = position
	initial_bubblita_mean_speed.x = randfn(0.0, 0.1)
	initial_bubblita_mean_speed.y = randfn(-3, 0.1)
	$AudioStreamPlayer2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if randf() < delta * BUBBLITA_PER_SEC:
		create_bubblita()
		
	total_time += delta
	position.y = initial_position.y + 20 * sin(total_time)
