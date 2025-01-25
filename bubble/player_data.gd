class_name PlayerData
extends Node


static var singleton: PlayerData

var wallet: Currency


func _ready() -> void:
	
	if singleton != null:
		get_tree().queue_delete(self)
		return
	else:
		singleton = self
	
	# load wallet if save game
	wallet = Currency.new(0,0,0,0)


func try_buy_upgrade(upgrade_cost: Currency) -> bool:
	return wallet.try_substract_self(upgrade_cost)
	
