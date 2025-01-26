extends Node2D

@export var na_value : int
@export var cl_value : int
@export var h_value : int
@export var o_value : int
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	$SubViewport.set_update_mode(Viewport.VRS_UPDATE_ALWAYS)  # Ensure continuous updates
	var texture : ViewportTexture = $SubViewport.get_texture()
	$NaCl.texture = texture

func _on_area_2d_body_entered(_body: Node2D) -> void:
	get_node("/root/main/PlayerData").add_to_wallet(Currency.new(na_value, cl_value, h_value, o_value))
	$AudioStreamPlayer.play()
	visible = false

func _on_audio_stream_player_finished() -> void:
	queue_free()
