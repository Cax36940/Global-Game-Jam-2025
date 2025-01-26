extends Node2D

const MAX_ANGLE = 20.0 # degrees
const PERIOD = 1.5 # seconds
var phase = 0.0 # degrees
var attach_point_index : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	phase = randf() * 2 * PI

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	rotation_degrees = sin(Time.get_ticks_msec() / (1000.0 * PERIOD) + phase) * MAX_ANGLE

func _on_area_2d_body_entered(body: Node2D) -> void:
	# touch bubble
	if !body.has_node("Plastics"):
		return
	
	if body.has_node("BubbleSprite"):
		attach_point_index = body.get_node("BubbleSprite").nearest_index(position)
	
	var index_list = []
	for i in range(-2, 3, 1):
		index_list.push_back((attach_point_index + i) % 30)
	
	for node in body.get_node("Plastics").get_children():
		if node.get_attach_index() in index_list :
			body.get_node("Plastics").call_deferred("remove_child", node)
			node.call_deferred("queue_free")
			if get_parent():
				get_parent().call_deferred("remove_child", self)
			call_deferred("queue_free")
			return
	
	body.damage(0.05)
	if get_parent():
		get_parent().call_deferred("remove_child", self)
	call_deferred("queue_free")
