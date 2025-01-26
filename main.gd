extends Node2D



var is_in_game = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Bubble.set_can_update(is_in_game)
	$Bubble.bubble_died.connect(on_end_game)


func earn_h2o() -> void:
	var dist = $Bubble.MAX_DEPTH - $Bubble.depth
	var amount = dist / 10
	print(amount)
	$PlayerData.add_to_wallet(Currency.new(0, 0, 2*amount, 1*amount))


func on_end_game() -> void:
	$MainUI.show_main_ui()
	is_in_game = false
	earn_h2o()
	$Bubble.set_can_update(is_in_game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !is_in_game:
		if Input.is_action_just_pressed("ui_copy"):
			$MainUI.start_game()
			is_in_game = true
			$Bubble.reset($MainUI)
			$Bubble.set_can_update(is_in_game)
			#$CollectibleGenerator.start_generation()
			
	$CanvasLayer/StockIndicator.quantity = $Bubble.stock / $Bubble.stock_capacity
	$RockBackground.position.y = $Bubble.position.y - get_viewport_rect().size.y / 2
	$RockBackground.position.x = $Bubble.position.x - get_viewport_rect().size.x / 2
