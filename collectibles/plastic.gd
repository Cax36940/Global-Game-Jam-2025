extends Node2D

const MAX_ANGLE = 20.0 # degrees
const PERIOD = 1.5 # seconds
var is_on_bubble = false
var phase = 0.0 # degrees
var attach_point_index : int
var total_time : float = randf_range(0, 10)


@onready var line = $Line2D
var init_points_pos = []
var points_offset = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	phase = randf() * 2 * PI
	for i in range(5):
		points_offset.push_back(randf_range(0, 10))
	init_points_pos = line.points


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_on_bubble:
		total_time += delta
		rotation_degrees = sin(Time.get_ticks_msec() / (1000.0 * PERIOD) + phase) * MAX_ANGLE
		var points = init_points_pos.duplicate()
		for i in range(5):
			points[i].y += 5 * sin(total_time + points_offset[i])
		line.points = points
		
	else:
		var position_index = []
		for i in range(-2, 3, 1):
			position_index.push_back((attach_point_index + i) % 30)
		
		position = get_node("../../BubbleSprite").get_point_position(attach_point_index)
		var points = []
		for i in range(5):
			points.push_back(get_node("../../BubbleSprite").get_point_position(position_index[i]) - position)
		line.points = points

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
	rotation_degrees = 0
	if body.has_node("Plastics"):
		call_deferred("reparent", body.get_node("Plastics"))
	
	if body.has_node("BubbleSprite"):
		attach_point_index = body.get_node("BubbleSprite").nearest_index(position)

func get_attach_index() -> int : 
	return attach_point_index
