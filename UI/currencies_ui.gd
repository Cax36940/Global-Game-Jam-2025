class_name CurrenciesUI
extends GridContainer


func set_currencies_txt(wallet: Currency) -> void:
	$"HBoxContainer/NaValue".text = str(wallet.na)
	$"HBoxContainer2/ClValue".text = str(wallet.cl)
	$"HBoxContainer3/HValue".text = str(wallet.h)
	$"HBoxContainer4/OValue".text = str(wallet.o)


func _ready() -> void:
	if PlayerData.singleton != null:
		PlayerData.singleton.wallet_changed.connect(set_currencies_txt)
		set_currencies_txt(PlayerData.singleton.wallet)
