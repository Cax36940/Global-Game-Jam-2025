extends RigidBody2D


var velocity = Vector2(0, -1.0)
const HSPEED_VARIATION = 0.2
const VSPEED_VARIATION = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.x += randfn(0.0, 0.2) * HSPEED_VARIATION
	velocity.y += randfn(0.0, 0.1) * VSPEED_VARIATION
	position.x += velocity.x
	position.y += velocity.y
