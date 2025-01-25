extends Node2D

@export var points: int = 30
@export var radius: float = 100.0

var area: float
var circumference: float
var length: float

@onready var blob: Polygon2D = $Blob
@onready var blob_outline : Line2D = $BlobOutline

var part_scene = preload("res://bubble/bubble_part.tscn")

var blob_initial_points : Array[Vector2]
var blob_points : Array[Vector2]
var blob_old_points : Array[Vector2]

var accumulated_displacements: Array
var normals: Array[Vector2]

var mouse_pos: Vector2
var mouse_colliding: bool = false

var speed_force : Vector2 = Vector2.ZERO
const MAX_SPEED_FORCE : float = 300.0

func _ready() -> void:
	area = radius * radius * PI
	circumference = radius * 2 * PI
	length = circumference * 1.15 / points
	
	blob_points = []
	blob_old_points = []
	accumulated_displacements.resize(points * 3)
	accumulated_displacements.fill(0)
	normals.resize(points)
	
	# Create the initial shape
	for i in range(points):
		var delta = Vector2(radius, 0).rotated(deg_to_rad((360. / points) * i))
		blob_points.push_back(global_position + delta)
		blob_initial_points.push_back(global_position + delta)
		blob_old_points.push_back(global_position + delta)
		normals[i] = delta.normalized()
	
	# Center the blob
	blob.polygon = blob_points
	blob_outline.points = blob_points
	# Ensure mouse tracking
	set_process_input(true)

func _process(delta: float) -> void:
	# Constraint resolution (10 iterations for stability)
	for _j in range(10):
		for i in range(points):
			var next_index = (i + 1) % points
			
			# Pull segments toward each other
			var to_next = blob_points[i] - blob_points[next_index]
			if to_next.length() > length:
				to_next = to_next.normalized() * length
				var offset = (blob_points[i] - blob_points[next_index]) - to_next
				
				accumulated_displacements[i * 3] -= offset.x / 2
				accumulated_displacements[i * 3 + 1] -= offset.y / 2
				accumulated_displacements[i * 3 + 2] += 1.0
				
				accumulated_displacements[next_index * 3] += offset.x / 2
				accumulated_displacements[next_index * 3 + 1] += offset.y / 2
				accumulated_displacements[next_index * 3 + 2] += 1.0
		
		# Compute area difference and dilation
		var current_area = blob_area()
		var delta_area : float = 0
		if current_area < area * 1.5 :
			delta_area = area - current_area
			
		var dilation_distance = delta_area / circumference
		
		# Apply dilation
		for i in range(points):
			var prev_index = (i - 1 + points) % points
			var next_index = (i + 1) % points
			var normal = (blob_points[next_index] - blob_points[prev_index]).orthogonal().normalized()
			
			accumulated_displacements[i * 3] += normal.x * dilation_distance
			accumulated_displacements[i * 3 + 1] += normal.y * dilation_distance
			accumulated_displacements[i * 3 + 2] += 1.0
		
		# Apply accumulated forces
		for i in range(points):
			if accumulated_displacements[i * 3 + 2] > 0:
				blob_points[i] += Vector2(accumulated_displacements[i * 3], accumulated_displacements[i * 3 + 1]) / accumulated_displacements[i * 3 + 2]
		
		# Reset displacements
		accumulated_displacements.fill(0)
		
		# Collision handling
		for i in range(points):
			if mouse_colliding and (blob_points[i] - mouse_pos + position).length() < 50:
				blob_points[i] = set_distance(blob_points[i], mouse_pos - position, 50)
			
	# Apply Verlet Integration
	for i in range(points):
		verlet_integrate_blob(i)
		blob_points[i] += (blob_initial_points[i] - blob_points[i]) * delta * 0.5
		if speed_force.length() > MAX_SPEED_FORCE :
			speed_force = MAX_SPEED_FORCE * speed_force.normalized()
		var force : Vector2 = ((blob_initial_points[i].y + radius) / (radius)) * speed_force
		blob_points[i] += force * delta

	position.y = min((blob_initial_points[int(3*points/4.)] - blob_points[int(3*points/4.)]).y, 0)
	blob.polygon = blob_points
	blob_outline.points = blob_points
	
func verlet_integrate_blob(i : int) -> void:
	var temp = blob_points[i]
	blob_points[i] = blob_points[i] + (blob_points[i] - blob_old_points[i])
	blob_old_points[i] = temp

func set_distance(current_point: Vector2, anchor: Vector2, distance: float) -> Vector2:
	var to_anchor = (current_point - anchor).normalized() * distance
	return anchor + to_anchor

func blob_area() -> float:
	var current_area = 0.0
	for i in range(len(blob_points) - 1):
		current_area += blob_points[i].x * blob_points[i + 1].y - blob_points[i + 1].x * blob_points[i].y
	return abs(current_area) / 2.0

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.position
	elif event is InputEventMouseButton:
		if event.pressed:
			mouse_colliding = true
		else:
			mouse_colliding = false

func set_speed_force(new_speed_force : Vector2):
	speed_force.y = move_toward(speed_force.y, new_speed_force.y, 1)
	speed_force.x = new_speed_force.x * 0.05

func get_polygon_points() -> Array[Vector2]:
	return blob_points

func nearest_index(local_position : Vector2) -> int :
	var dist_min : float = 100000;
	var ret : int = 0
	for i in range(blob_points.size()):
		var current_dist = (blob_points[i] * global_scale + global_position - local_position).length()
		if current_dist < dist_min:
			ret = i
			dist_min = current_dist
	return ret

func get_point_position(i : int) -> Vector2 :
	return blob_points[i%points] + position

func pop():
	var part_position : Vector2 = Vector2.ZERO
	for i in range(blob_points.size()):
		part_position += blob_points[i]
		var instance = part_scene.instantiate()
		instance.setup(blob_points[i].normalized(), blob.color, blob_outline.default_color)
		$ParticuleContainer.add_child(instance)
	$ParticuleContainer.position = part_position / blob_points.size()
	blob.visible = false
	blob_outline.visible = false
