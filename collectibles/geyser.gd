extends Node2D


const BUBBLITA_PER_SEC = 2.0
var bubblita_scence = preload("res://collectibles/bubblita.tscn")
var initial_bubblita_mean_speed = Vector2(0, 0)

func create_bubblita():
	var bubblita = bubblita_scence.instantiate()
	var vx = initial_bubblita_mean_speed.x + randfn(0.0, 0.1)
	var vy = initial_bubblita_mean_speed.y + randfn(0.0, 0.1)
	bubblita.velocity.x = vx
	bubblita.velocity.y = vy
	add_child(bubblita)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_bubblita_mean_speed.x = randf() * 2 - 1
	initial_bubblita_mean_speed.y = - 2 - randf() * 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if randf() < delta * BUBBLITA_PER_SEC:
		create_bubblita()
