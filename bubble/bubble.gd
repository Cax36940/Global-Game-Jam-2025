extends CharacterBody2D



const AIR_MIN = 0.1 # bubble pop size
const SLIDE_RATE = 0.9 # 1 = no slide, 0 = no friction

var hspeed = 300.0
var vspeed = 100.0
var air = 1.0
var air_lose_rate = 0.1 # per second


func adjust_size():
	scale = Vector2(air, air)
	#$Camera2D.zoom = Vector2(air, air)

func lose_air_check_die(delta: float):
	air = move_toward(air, AIR_MIN, air_lose_rate*delta)
	return air <= AIR_MIN

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	"""
	# With no friction/sliding effects
	if direction:
		velocity.x = direction * hspeed
	else:
		velocity.x = move_toward(velocity.x, 0, hspeed)
	"""
	
	
	# With friction/sliding effects
	if direction:
		velocity.x = move_toward(velocity.x, direction * hspeed, hspeed)
	else:
		velocity.x = move_toward(velocity.x, 0, hspeed * SLIDE_RATE * delta)
	
	velocity.y = - vspeed * air
	
	var die = lose_air_check_die(delta)
	adjust_size()
	move_and_slide()
	
	if die:
		# TODO : pop !
		vspeed = 0
