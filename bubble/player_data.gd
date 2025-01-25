class_name PlayerData
extends Node


static var singleton: PlayerData

var wallet: Currency

signal wallet_changed

func _ready() -> void:
	
	if singleton != null:
		get_tree().queue_delete(self)
		return
	else:
		singleton = self
	
	# load wallet if save game
	wallet = Currency.new(20,20,20,20)
	wallet_changed.emit(wallet)


func add_to_wallet(value: Currency):
	wallet.add_self(value)
	wallet_changed.emit(wallet)


func try_buy_upgrade(upgrade_cost: Currency) -> bool:
	if wallet.try_substract_self(upgrade_cost):
		wallet_changed.emit(wallet)
		return true
	return false
