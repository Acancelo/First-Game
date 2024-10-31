extends Node

@onready var coin_label = $UI/CoinLabel  # Ajusta esta ruta a la ubicación de tu Label

# Cantidad de coins recogidos
var coin_count: int = 0

# Función para aumentar el número de coins
func add_coin() -> void:
	coin_count += 1
	if coin_label:
		coin_label.text = "Coin Count: %d" % coin_count  # Actualiza el texto del Label
	else:
		print("Error: coin_label es null y no se puede actualizar el texto.")
	print("Coins recolectados: ", coin_count)  # Imprime el conteo actual de coins
