extends Node2D

@onready var left_rock : Polygon2D = $LeftRock
@onready var right_rock : Polygon2D = $RightRock

var left_noise : FastNoiseLite
var right_noise : FastNoiseLite

var rock_color : Color = Color(1.0, 1.0, 1.0)

var velocity : Vector2 = Vector2.ZERO
var velocity_factor : float = 1.0 # factor to account for depth of the layer
var y_offset : float = 0.0
var begin_y : float = -100.0
var end_y : float
var width : float = 200.0

var spacing : float = 20.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity.y = 100.0
	end_y  = get_viewport_rect().size.y + 100
	
	left_rock.set_color(rock_color)
	right_rock.set_color(rock_color)
	
	left_rock.polygon.clear()
	right_rock.polygon.clear()
	
	var points : Array[Vector2] = []
	
	left_noise = FastNoiseLite.new()
	left_noise.seed = randi()
	left_noise.frequency = 0.004  # Adjust frequency for different noise patterns
	
	right_noise = FastNoiseLite.new()
	right_noise.seed = randi()
	right_noise.frequency = 0.004  # Adjust frequency for different noise patterns
	
	
	# Fill left rock points
	points.push_back(Vector2(0,end_y))
	points.push_back(Vector2(0,begin_y))
	for i in range(begin_y, end_y + spacing, spacing):
		points.push_back(Vector2(width + left_noise.get_noise_1d(i) * 20, i))
	left_rock.polygon = points
	
	points.clear()
	
	# Fill right rock points
	points.push_back(Vector2(get_viewport_rect().size.x + 100,end_y))
	points.push_back(Vector2(get_viewport_rect().size.x + 100,begin_y))
	for i in range(begin_y, end_y + spacing, spacing):
		points.push_back(Vector2(get_viewport_rect().size.x - width + right_noise.get_noise_1d(i) * 20, i))
		
	right_rock.polygon = points
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_left_rock(delta)
	update_right_rock(delta)
	pass

func update_left_rock(delta):
	var points : PackedVector2Array = left_rock.polygon
	var number_points_to_change = 0
	
	# Move all points
	# Count the number of points going out of bound (too low)
	for i in range(2, points.size()):
		points[i] = points[i] + velocity * delta * velocity_factor
		if points[i].y > end_y:
			number_points_to_change += 1
			
	# If some points are to low, push back new points to the top
	if number_points_to_change > 0 :
		for i in range(points.size() - 1,1 + number_points_to_change, -1):
			points[i] = points[i - number_points_to_change]
		var number_added_point = 0.0
		for i in range(number_points_to_change + 1, 1, -1):
			y_offset -= spacing
			number_added_point += 1
			points[i] = Vector2(width + left_noise.get_noise_1d(begin_y + y_offset) * 20, points[number_points_to_change + 2].y - spacing * number_added_point)
	left_rock.polygon = points

func update_right_rock(delta):
	var points : PackedVector2Array = right_rock.polygon
	var number_points_to_change = 0
	
	# Move all points
	# Count the number of points going out of bound (too low)
	for i in range(2, points.size()):
		points[i] = points[i] + velocity * delta * velocity_factor
		if points[i].y > end_y:
			number_points_to_change += 1
			
	# If some points are to low, push back new points to the top
	if number_points_to_change > 0 :
		for i in range(points.size() - 1,1 + number_points_to_change, -1):
			points[i] = points[i - number_points_to_change]
		var number_added_point = 0.0
		for i in range(number_points_to_change + 1, 1, -1):
			y_offset -= spacing
			number_added_point += 1
			points[i] = Vector2(get_viewport_rect().size.x - width + right_noise.get_noise_1d(begin_y + y_offset) * 20, points[number_points_to_change + 2].y - spacing * number_added_point)
	right_rock.polygon = points

func set_width(new_width : float):
	width = new_width

func set_color(new_color : Color) :
	rock_color = new_color

func set_velocity_factor(new_velocity_factor : float) :
	velocity_factor = new_velocity_factor

func set_velocity(new_velocity : Vector2):
	velocity = new_velocity
