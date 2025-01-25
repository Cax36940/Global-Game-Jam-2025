extends Node2D

var velocity : Vector2
var in_color : Color
var out_color : Color
const SPEED : float = 200.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("Fade")
	pass # Replace with function body.

func _draw() -> void:
	draw_circle(position, 20, in_color)
	draw_circle(position, 21, out_color, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta * SPEED
	pass

func setup(new_velocity : Vector2, new_in_color : Color, new_out_color : Color) -> void:
	velocity = new_velocity
	in_color = new_in_color
	out_color = new_out_color
	position += velocity * SPEED * 0.1

func die():
	get_parent().remove_child(self)
	queue_free()
