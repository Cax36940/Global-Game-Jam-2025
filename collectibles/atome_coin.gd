extends Node2D

var rotation_speed : float
@export var na_value : int
@export var cl_value : int
@export var h_value : int
@export var o_value : int
var velocity : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation_speed = randf_range(-1., 1.)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation += rotation_speed * delta
	position += velocity * delta

func _on_area_2d_body_entered(_body: Node2D) -> void:
	get_node("/root/main/PlayerData").add_to_wallet(Currency.new(na_value, cl_value, h_value, o_value))
	$AudioStreamPlayer.play()
	visible = false

func _on_audio_stream_player_finished() -> void:
	get_parent().remove_child(self)
	queue_free()
