extends Area2D

# Velocidad de la roca
var speed = 300

func _process(delta):
	position.x += speed * delta  # Ajusta la dirección de acuerdo a tus necesidades

	# Elimina la roca si sale de la pantalla
	if position.x > get_viewport_rect().size.x or position.x < 0:
		queue_free()
