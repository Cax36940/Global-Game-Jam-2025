extends CharacterBody2D

@onready var bubble_sprite = $BubbleSprite
@onready var bubble_collision : CollisionShape2D = $BubbleCollision

# every air-related variable is a percentage of AIR_MAX
const AIR_MAX = 1.0 # initial bubble max size (with all upgrades) = in-game max size
const AIR_MIN = 0.01 # bubble pop size
const AIR_LOSE_RATE = 0.01 # per second
const AIR_REFILL_SPEED = 0.1 # per second
const AIR_INIT = 0.1
const STOCK_INIT = 0.02

const STOCK_MAX = 10.0 # max air stock size (10 times AIR_MAX)
const SLIDE_RATE = 0.9 # 1 = no slide, 0 = no friction
const SLIDE_RATE_INPUT = 2.0
const ZOOM_PER_SEC = 0.1

const MAX_DEPTH = 10984 # m
const INFLATION_TIME = 5.0 # seconds

const VSPEED = 100.0
const HSPEED = 200.0

var air_init_mult = 1.0
var vspeed_mult = 1.0
var hspeed_mult = 1.0 # not implemented
var resistance = 0.0 # % damage reduction
var stock_capacity_init_mult = 1.0

var air = AIR_INIT
var stock_capacity = STOCK_INIT # air stock capacity (1.0 = AIR_MAX) (between 0 and STOCK_MAX, depend on upgrades)
var stock = STOCK_INIT # air in stock (between 0 and stock_capacity, varies during the run)
var mult = 1.0 # Multiplier for camera and speed, = sqrt(air)
var depth = MAX_DEPTH
var inflation = 0.0

signal bubble_died


func set_can_update(value: bool):
	set_physics_process(value)
	set_process(value)


func reset(ui: Node):
	# reset values for next run (link to ui)
	stock_capacity_init_mult = ui.get_stock()
	air_init_mult            = ui.get_health()
	vspeed_mult              = ui.get_speed()
	resistance               = ui.get_resistance()
	
	stock_capacity = STOCK_INIT * stock_capacity_init_mult * 5
	air = AIR_INIT * air_init_mult
	stock = stock_capacity
	$BubbleSprite.reset()
	position = Vector2.ZERO
	$Camera2D.zoom = Vector2.ONE


func _ready() -> void:
	$Ambient.play()
	$Music.play()
	bubble_died.connect(reset)
	adjust_size(0)


func adjust_size(delta: float):
	scale = Vector2(5*air, 5*air)
	var z = $Camera2D.zoom.x
	z = move_toward(z, 1/mult, ZOOM_PER_SEC * delta)
	$Camera2D.zoom = Vector2(z, z)


func refill(quantity: float):
	quantity = min(min(quantity, stock), AIR_MAX-air)
	air += quantity
	stock -= quantity


func lose_air_check_die(delta: float) -> bool:
	air = move_toward(air, 0, AIR_LOSE_RATE * delta)
	
	if air < AIR_MIN: # use air in stock if possible (to avoid dying)
		refill(AIR_MIN - air)
	return air < AIR_MIN


func damage(value: float):
	air = move_toward(air, 0, value * (1-resistance))
	
	if air < AIR_MIN: # use air in stock if possible (to avoid dying)
		refill(AIR_MIN - air)


func get_air_inflation() -> float:
	return AIR_MIN + (inflation ** 2) * (AIR_INIT * air_init_mult)


func inflate(delta: float) -> void:
	inflation += delta / INFLATION_TIME
	if inflation > 1.0:
		pop()
		$BubbleSprite.reset()
	air = get_air_inflation()
	scale = Vector2(5*air, 5*air)


func start() -> void:
	$BubbleSprite.reset()
	if inflation > 0.9:
		inflation = 1.0
		air = get_air_inflation()
		scale = Vector2(5*air, 5*air)


func pop():
	inflation = 0.1
	bubble_sprite.pop()
	for child in $Plastics.get_children():
		child.detach()
	$PopSound.play()


func update_depth():
	depth = MAX_DEPTH + int(position.y/50)
	$"../CanvasLayer/Label".text = str(-depth)


func _process(delta: float) -> void:
	update_depth()
	var die = lose_air_check_die(delta)
	if die:
		vspeed_mult = 0
		velocity = Vector2.ZERO
		pop()
		set_can_update(false)
		var timer = get_tree().create_timer(2)
		timer.timeout.connect(func (): bubble_died.emit())
	
	if(has_node("../RockBackground")):
		get_node("../RockBackground").set_velocity(-velocity)
	bubble_sprite.set_speed_force(-velocity)
	bubble_collision.shape.segments = bubble_sprite.get_polygon_points()
	bubble_collision.position.y = bubble_sprite.position.y


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	var use_stock := Input.is_action_pressed("air")
	
	if use_stock:
		refill(AIR_REFILL_SPEED * delta)
	
	"""
	# With no friction/sliding effects
	if direction:
		velocity.x = direction * hspeed
	else:
		velocity.x = move_toward(velocity.x, 0, hspeed)
	"""
	
	var hspeed = HSPEED * hspeed_mult
	var vspeed = VSPEED * vspeed_mult
	# With friction/sliding effects
	if direction:
		velocity.x = move_toward(velocity.x, direction * hspeed, hspeed * SLIDE_RATE_INPUT * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, hspeed * SLIDE_RATE * delta)
	
	mult = sqrt(5*air)
	velocity.y = - vspeed * mult * 2
	
	adjust_size(delta)
	move_and_slide()
