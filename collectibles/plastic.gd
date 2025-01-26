extends Node2D

const MAX_ANGLE = 20.0 # degrees
const PERIOD = 1.5 # seconds
var is_on_bubble = false
var phase = 0.0 # degrees
var attach_point_index : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	phase = randf() * 2 * PI


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not is_on_bubble:
		rotation_degrees = sin(Time.get_ticks_msec() / (1000.0 * PERIOD) + phase) * MAX_ANGLE
	else:
		position = get_node("../../BubbleSprite").get_point_position(attach_point_index)

func detach():
	is_on_bubble = false
	reparent(get_node("/root/main/Plastics"))
	position.y += randf_range(-50, -30)
	position.x += 20 * randfn(0.0, 2.0)
	scale = Vector2.ONE

func _on_area_2d_body_entered(body: Node2D) -> void:
	# touch bubble
	if is_on_bubble:
		return
	is_on_bubble = true
	if body.has_node("Plastics"):
		call_deferred("reparent", body.get_node("Plastics"))
	
	if body.has_node("BubbleSprite"):
		attach_point_index = body.get_node("BubbleSprite").nearest_index(position)
