extends Node2D



var is_in_game = false
var max_depth_reached = 0
var total_distance_traveled = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Bubble.set_can_update(is_in_game)
	$Bubble.bubble_died.connect(on_end_game)
	max_depth_reached = $Bubble.MAX_DEPTH
	$MainUI.update_stats(max_depth_reached, max_depth_reached, total_distance_traveled)
	$MainUI.start_button_pressed.connect(on_start_game)

func earn_h2o() -> void:
	var dist = $Bubble.MAX_DEPTH - $Bubble.depth
	var amount = dist / 10
	$PlayerData.add_to_wallet(Currency.new(0, 0, 2*amount, 1*amount))


func on_end_game() -> void:
	if max_depth_reached > $Bubble.depth:
		max_depth_reached = $Bubble.depth
	total_distance_traveled += $Bubble.MAX_DEPTH - $Bubble.depth
	$MainUI.update_stats(max_depth_reached, $Bubble.depth, total_distance_traveled)
	$MainUI.show_main_ui()
	is_in_game = false
	earn_h2o()
	$Bubble.reset($MainUI)
	$Bubble.update_depth()
	$Bubble.set_can_update(is_in_game)
	$CollectibleGenerator.reset()
	$ObstaclesGenerator.reset()
	$PlasticsGenerator.reset()
	$RockBackground.reset()

func on_start_game() -> void:
	$MainUI.start_game()
	$Bubble.start()
	is_in_game = true
	$Bubble.set_can_update(is_in_game)
	$CollectibleGenerator.start_generation()
	$ObstaclesGenerator.start_generation()
	$PlasticsGenerator.start_generation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_in_game:
		$Bubble.inflate(delta)
		$Bubble.reset_values($MainUI)
			
	$CanvasLayer/StockIndicator.quantity = $Bubble.stock / $Bubble.stock_capacity
	$RockBackground.position.y = $Bubble.position.y - get_viewport_rect().size.y
	$RockBackground.position.x = $Bubble.position.x - get_viewport_rect().size.x / 2
