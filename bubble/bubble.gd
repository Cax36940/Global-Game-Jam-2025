extends CharacterBody2D

@onready var bubble_sprite = $BubbleSprite
@onready var bubble_collision : CollisionShape2D = $BubbleCollision

# every air-related variable is a percentage of AIR_MAX
const AIR_MAX = 1.0 # initial bubble max size (with all upgrades) = in-game max size
const AIR_MIN = 0.01 # bubble pop size
const AIR_LOSE_RATE = 0.01 # per second
const REFILL_SPEED = 0.1 # per second

const STOCK_MAX = 10.0 # max air stock size (10 times AIR_MAX)
const SLIDE_RATE = 0.9 # 1 = no slide, 0 = no friction
const SLIDE_RATE_INPUT = 2.0
const ZOOM_PER_SEC = 0.1

var hspeed = 300.0
var vspeed = 100.0
var air = 0.1 # TODO replace with initial air value
var stock_capacity = 0.1 # air stock capacity (1.0 = AIR_MAX) (between 0 and STOCK_MAX, depend on upgrades)
var stock = 0.1 # air in stock (between 0 and stock_capacity, varies during the run)
var mult = 1.0 # Multiplier for camera and speed, = sqrt(air)

var can_move = false

func set_can_move(value: bool):
	can_move = value

func reset():
	pass # mettre tout aux valeurs initiales (link to ui)


func adjust_size(delta: float):
	scale = Vector2(10*air, 10*air)
	var z = $Camera2D.zoom.x
	z = move_toward(z, 1/mult, ZOOM_PER_SEC * delta)
	$Camera2D.zoom = Vector2(z, z)

func refill(quantity: float):
	quantity = min(quantity, stock)
	air += quantity
	stock -= quantity

func lose_air_check_die(delta: float):
	print(stock)
	air = move_toward(air, 0, AIR_LOSE_RATE * delta)
	air = min(air, AIR_MAX)
	if air < AIR_MIN:
		refill(AIR_MIN - air)
	return air < AIR_MIN

func _process(delta: float) -> void:
	if !can_move: return
	
	var die = lose_air_check_die(delta)
	if die:
		vspeed = 0
		velocity = Vector2.ZERO
		pop()
		set_physics_process(false)
		set_process(false)
		# TODO : end day
	
	if(has_node("../RockBackground")):
		get_node("../RockBackground").set_velocity(-velocity)
	bubble_sprite.set_speed_force(-velocity)
	bubble_collision.shape.segments = bubble_sprite.get_polygon_points()
	bubble_collision.position.y = bubble_sprite.position.y


func _physics_process(delta: float) -> void:
	if !can_move: return
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	var use_stock := Input.is_action_pressed("air")
	if use_stock:
		refill(REFILL_SPEED * delta)
	
	"""
	# With no friction/sliding effects
	if direction:
		velocity.x = direction * hspeed
	else:
		velocity.x = move_toward(velocity.x, 0, hspeed)
	"""
	
	# With friction/sliding effects
	if direction:
		velocity.x = move_toward(velocity.x, direction * hspeed, hspeed * SLIDE_RATE_INPUT * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, hspeed * SLIDE_RATE * delta)
	
	mult = sqrt(10*air)
	velocity.y = - vspeed * mult
	
	adjust_size(delta)
	move_and_slide()

func pop():
	bubble_sprite.pop()
	
