extends Node3D

@onready var cube : MeshInstance3D = $Cube  # Set this to the cube's path in the inspector
var rotation_speed: float = 1.0  # Adjust speed in the editor
var axis_rotation_speed: float = 0.5

var rotation_axis : Vector3

func _ready() -> void:
	rotation_axis = Vector3(
			randf_range(-1, 1),  # Random X rotation
			randf_range(-1, 1),  # Random Y rotation
			randf_range(-1, 1)   # Random Z rotation
		).normalized()
func _process(delta: float) -> void:
	cube.rotate_object_local(rotation_axis, rotation_speed * delta)
	var axis_rotation = Basis(Vector3.UP, axis_rotation_speed * delta) * Basis(Vector3.RIGHT, axis_rotation_speed * delta)
	rotation_axis = (axis_rotation * rotation_axis).normalized()
