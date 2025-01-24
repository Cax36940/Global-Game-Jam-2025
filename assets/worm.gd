extends Line2D

var velocity : Vector2 = Vector2.ZERO
var total_time : float = 0.0
const SPEED : float = 1.0
const NUMBER_POINT : int = 10
const JOINT_LENGTH : float = 20.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(NUMBER_POINT):
		add_point(Vector2(-JOINT_LENGTH * i, 0), i)
		
	# https://rgbcolorpicker.com/random/blue
	var hue : float = randf_range(210.0 / 360, 260.0 / 360)
	var sat : float = randf_range(0.7, 1.0)
	var val : float = randf_range(0.3, 0.7)
	default_color = Color.from_hsv(hue, sat, val)
	
	total_time = randf_range(0.0, 2 * PI / SPEED)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	total_time += delta
	velocity.y = cos(total_time * SPEED) / 5.0
	velocity.x = sqrt(1 - velocity.y ** 2)
	
	set_point_position(0, get_point_position(0) + velocity * SPEED)

	for i in range(1, NUMBER_POINT):
		set_point_position(i, get_point_position(i-1) + JOINT_LENGTH * (get_point_position(i) - get_point_position(i-1)).normalized())
	
	pass
