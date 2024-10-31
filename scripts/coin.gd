extends Area2D

func _on_body_entered(body):
	# Verifica que el jugador ha tocado el coin
	if body.name == "Player":
		$AudioStreamPlayer.playing = true
		GameManager.add_coin()  # Llama a la función en GameManager
		await get_tree().create_timer(0.1).timeout
		queue_free()  # Elimina el coin de la escena
