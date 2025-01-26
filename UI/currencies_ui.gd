class_name CurrenciesUI
extends GridContainer


func set_currencies_txt(wallet: Currency) -> void:
	$"HBoxContainer/Na+".text = "Na+ : " + str(wallet.na)
	$"HBoxContainer2/Cl-".text = "Cl- : " + str(wallet.cl)
	$"HBoxContainer3/H+".text = "H+ : " + str(wallet.h)
	$"HBoxContainer4/O-".text = "O- : " + str(wallet.o)


func _ready() -> void:
	if PlayerData.singleton != null:
		PlayerData.singleton.wallet_changed.connect(set_currencies_txt)
		set_currencies_txt(PlayerData.singleton.wallet)
