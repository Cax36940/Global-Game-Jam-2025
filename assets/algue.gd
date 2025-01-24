extends Line2D

var velocity : Vector2 = Vector2.ZERO
var total_time : float = 0.0
const SPEED : float = 1.0
var number_point : int = 10
const JOINT_LENGTH : float = 20.0
static var HUE : float = randf_range(100, 140) 
const HUE_RANGE : float = 5.0
var virtual_position : Array[Vector2]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	number_point = randi_range(5, 15)
	for i in range(number_point):
		add_point(Vector2(0, -JOINT_LENGTH * i), i)
		virtual_position.push_back(get_point_position(i))
		
	# https://rgbcolorpicker.com/random/blue
	#var hue : float = randf_range(90.0 / 360, 150.0 / 360)
	var hue : float = randf_range((HUE - HUE_RANGE) / 360, (HUE + HUE_RANGE) / 360)
	var sat : float = randf_range(0.7, 0.8)
	var val : float = randf_range(0.5, 0.6)
	
	gradient = Gradient.new()
	gradient.set_color(0, Color.from_hsv(hue, sat, val))
	gradient.set_color(1, Color.from_hsv(hue, sat/10, val))
	
	total_time = randf_range(0.0, 2 * PI / SPEED)
	
	width_curve.add_point(Vector2(0, 0.9 + randf_range(-0.1, 0.1)))
	
	for i in range(int(number_point/2.0)):
		var x : float = float(i) / float(int(number_point/2.0) + 1)
		width_curve.add_point(Vector2(x, 1 - log(x + 1) + sin(x * number_point) / randf_range(7.0, 13.0)))
	
	width_curve.add_point(Vector2(1, 0))
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	total_time += delta
	velocity.x = cos(total_time * SPEED) / ((20 - number_point))
	velocity.y = sqrt(1 - velocity.x ** 2)
	
	virtual_position[0] = virtual_position[0] + velocity * SPEED
	
	var position_offset = virtual_position[0] - get_point_position(0)
	
	for i in range(1, number_point):
		virtual_position[i] = virtual_position[i-1] + JOINT_LENGTH * (virtual_position[i] - virtual_position[i-1]).normalized()
		set_point_position(i, virtual_position[i] - position_offset)
	 
	
	pass
