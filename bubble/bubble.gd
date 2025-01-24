extends CharacterBody2D


var hspeed = 300.0
var vspeed = 100.0


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * hspeed
	else:
		velocity.x = move_toward(velocity.x, 0, hspeed)
	
	velocity.y = -vspeed

	move_and_slide()
