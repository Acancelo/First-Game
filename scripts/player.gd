extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const MAX_JUMPS = 2  # Número máximo de saltos (doble salto)
const DASH_SPEED = 300.0  # Velocidad del dash
const DASH_DURATION = 0.2  # Duración del dash en segundos

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumps_left = MAX_JUMPS
var is_dashing = false
var dash_timer = 0.0
var dash_direction = 0.0
var can_dash = true
var coin_counter = 0 # Contador para el score de los coin

@onready var animated_sprite = $AnimatedSprite2D

func _on_area_2d_area_entered(area):
	if area.is_in_group("Coin"):
		set_coin(coin_counter + 1)
		print(coin_counter)

# Contador de coin
func set_coin(new_coin_counter: int) -> void:
	coin_counter = new_coin_counter

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
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")

		# Aplicar movimiento horizontal
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Mover al personaje con "move_and_slide"
	move_and_slide()
