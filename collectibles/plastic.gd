extends StaticBody2D


const MAX_ANGLE = 20.0 # degrees
const PERIOD = 1.5 # seconds
var is_on_bubble = false
var phase = 0.0 # degrees


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	phase = randf() * 2 * PI


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_on_bubble:
		$Sprite2D.rotation_degrees = sin(Time.get_ticks_msec() / (1000.0 * PERIOD) + phase) * MAX_ANGLE


func _on_area_2d_body_entered(body: Node2D) -> void:
	# touch bubble
	is_on_bubble = true
	self.reparent(body)
