extends Control


func _on_boton_jugar_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_boton_opciones_pressed():
	get_tree().change_scene_to_file("res://scenes/options.tscn")


func _on_boton_salir_pressed():
	get_tree().quit()
	
