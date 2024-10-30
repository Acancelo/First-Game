extends Area2D

func _on_body_entered(body):
	# Verifica que el jugador ha tocado el coin
	if body.name == "Player":
		GameManager.add_coin()  # Llama a la función en GameManager
		queue_free()  # Elimina el coin de la escena
