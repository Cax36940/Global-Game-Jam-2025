extends Line2D

var velocity : Vector2 = Vector2.ZERO
var total_time : float = 0.0
const SPEED : float = 1.0
const NUMBER_POINT : int = 10
const JOINT_LENGTH : float = 20.0
var velocity_factor : float = 1.0 # factor to account for depth of the layer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(NUMBER_POINT):
		add_point(Vector2(-JOINT_LENGTH * i, 0), i)
		
	# https://rgbcolorpicker.com/random/blue
	var hue : float = randf_range(210.0 / 360, 260.0 / 360)
	var sat : float = randf_range(0.7, 1.0)
	var val : float = randf_range(0.5, 0.7) * (1 + z_index/25.)

	default_color = Color.from_hsv(hue, sat, val)
	
	total_time = randf_range(0.0, 2 * PI / SPEED)
	scale = Vector2(10./(10. - z_index),10./(10. - z_index))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta * velocity_factor
	total_time += delta
	
	var local_velocity : Vector2 = Vector2.ZERO
	local_velocity.y = cos(total_time * SPEED) / 5.0
	local_velocity.x = sqrt(1 - local_velocity.y ** 2)

	set_point_position(0, get_point_position(0) + local_velocity * SPEED)

	for i in range(1, NUMBER_POINT):
		set_point_position(i, get_point_position(i-1) + JOINT_LENGTH * (get_point_position(i) - get_point_position(i-1)).normalized())
	
	if get_point_position(0).x > 1500 or position.y > 200 - 10 * get_node("/root/main/Bubble").velocity.y:
		get_parent().remove_child(self)
		queue_free()
	pass

func set_velocity(new_velocity : Vector2):
	velocity = new_velocity

func set_velocity_factor(new_velocity_factor : float) :
	velocity_factor = new_velocity_factor
