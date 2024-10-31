extends Area2D

# Velocidad de la roca, que será establecida por el jugador al lanzarla
var speed = 300

func _process(delta):
	# Mueve la roca en función de su velocidad
	position.x += speed * delta

	# Elimina la roca si sale de la pantalla
	if position.x > get_viewport_rect().size.x or position.x < 0:
		queue_free()
