extends CharacterBody2D
# ---------------------------- Variables ------------------------------------
const SPEED = 130.0 # Velocidad del personaje
const JUMP_VELOCITY = -300.0 # Velocidad del salto
const MAX_JUMPS = 2  # Número máximo de saltos (doble salto)
const DASH_SPEED = 300.0  # Velocidad del dash
const DASH_DURATION = 0.2  # Duración del dash en segundos
var MAX_ROCKS = 5 # Numero de rocas maximas
var rocks_remaining = MAX_ROCKS  # Rocas disponibles

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumps_left = MAX_JUMPS
var is_dashing = false
var dash_timer = 0.0
var dash_direction = 0.0
var facing_right = true
var can_dash = true
# -------------------------- Cargar escenas -------------------------------
# Cargar la escena de la roca
@onready var rock_scene = preload("res://scenes/rock.tscn")
@onready var animated_sprite = $AnimatedSprite2D
# ------------------------- Funciones -----------------------------------
func _process(delta):
	# Actualiza la dirección del jugador cuando se mueve
	if Input.is_action_pressed("move_right"):
		facing_right = true
	elif Input.is_action_pressed("move_left"):
		facing_right = false

	# Lanza una roca si el jugador presiona el botón y tiene rocas disponibles
	if Input.is_action_just_pressed("throw_rock") and rocks_remaining > 0:
		throw_rock()

	# Recarga rocas si el jugador presiona el botón de recarga
	if Input.is_action_just_pressed("reload_rocks"):
		reload_rocks()

#Funcion para lanzar la roca
func throw_rock():
	if rocks_remaining > 0:
		var rock_instance = rock_scene.instantiate()
		rock_instance.position = position  # Coloca la roca en la posición del jugador
		get_parent().add_child(rock_instance)  # Añade la roca a la escena

		# Reduce el conteo de rocas disponibles
		rocks_remaining -= 1
		print("Rocas restantes:", rocks_remaining)
	else:
		print("No quedan rocas para lanzar.")
		
	# Recarga rocas si el jugador presiona el botón de recarga
	if Input.is_action_just_pressed("reload_rocks"):
		reload_rocks()
#Funcion para recargar rocas
func reload_rocks():
	rocks_remaining = MAX_ROCKS
	print("Rocas recargadas:", rocks_remaining)
	
#Funcion para los saltos
func _physics_process(delta):
	if not is_on_floor() and not is_dashing:
		velocity.y += gravity * delta

	# Restablecer los saltos y la capacidad de hacer dash cuando el jugador está en el suelo
	if is_on_floor():
		jumps_left = MAX_JUMPS
		can_dash = true

	# Manejar el salto
	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1

	# Obtener la dirección del input: -1, 0, 1 (para izquierda, sin movimiento o derecha)
	var direction = Input.get_axis("move_left", "move_right")
	
	# Iniciar el dash si se presiona el botón de dash
	if Input.is_action_just_pressed("dash") and can_dash and direction != 0:
		is_dashing = true
		dash_timer = DASH_DURATION
		dash_direction = direction
		can_dash = false
		velocity.y = 0 

	# Controlar el dash
	if is_dashing:
		velocity.x = dash_direction * DASH_SPEED
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	if not is_dashing:
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
		
		# Reproducir las animaciones
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("walk")
		else:
			animated_sprite.play("jump")

		# Aplicar movimiento horizontal
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Mover al personaje con "move_and_slide"
	move_and_slide()
