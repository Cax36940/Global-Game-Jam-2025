extends Node2D


var velocity = Vector2(0, -1.5)
const HSPEED_VARIATION = 0.2
const VSPEED_VARIATION = 0.2
var air = 0.005
var end_time = 0.0
const END_TIME_MEAN = 15.0 # seconds
var finished = false
var lifetime = 0.0

func _draw() -> void:
	draw_circle(position, 20, Color("7cadf44f"))
	draw_circle(position, 21, Color("2a66bb51"), false)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lifetime = randfn(END_TIME_MEAN, 0.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.x += randfn(0.0, 0.2) * HSPEED_VARIATION
	velocity.y += randfn(0.0, 0.1) * VSPEED_VARIATION
	position += velocity * delta * 60
	lifetime -= delta
	if lifetime <= 0.0:
		pop()

func pop():
	if not finished:
		finished = true
		$AudioStreamPlayer2D.play()
		visible = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	# touch bubble
	if body.get_parent().is_in_game:
		body.air = min(body.air + air, body.AIR_MAX)
		pop()


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
