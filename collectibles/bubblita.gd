extends RigidBody2D


var velocity = Vector2(0, -1.0)
const HSPEED_VARIATION = 0.2
const VSPEED_VARIATION = 0.2
var air = 0.1
var end_time = 0.0
const END_TIME_MEAN = 10.0 # seconds
var finished = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	end_time = Time.get_ticks_msec() + randfn(END_TIME_MEAN * 1000, 0.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.x += randfn(0.0, 0.2) * HSPEED_VARIATION
	velocity.y += randfn(0.0, 0.1) * VSPEED_VARIATION
	position += velocity * delta * 60
	if Time.get_ticks_msec() > end_time:
		pop()

func pop():
	if not finished:
		finished = true
		$AudioStreamPlayer2D.play()
		$Sprite2D.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	# touch bubble
	body.air += air
	pop()


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
