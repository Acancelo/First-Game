extends Node
var coin_counter = 0 # Contador para el score de los coin
@onready var coin_label = %Score


func _on_body_entered(area):
	if area.is_in_group("Coin"):
		set_coin(coin_counter + 1)
		print(coin_counter)

# Contador de coin
func set_coin(new_coin_counter: int) -> void:
	coin_counter = new_coin_counter
	coin_label.text = "Coin Count: " + str(coin_counter)
