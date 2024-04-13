extends CharacterBody2D


var velocidad = 300.0
var salto = -400.0
var saltos_restantes = 1
var dash = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Añade la gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Maneja el salto y doble salto
	if Input.is_action_just_pressed("up") and saltos_restantes > 0:
		velocity.y = salto
		saltos_restantes -= 1
		print(saltos_restantes)
	
	#reset de los saltos restantes
	if is_on_floor():
		saltos_restantes = 1
	
	#Se agrega el Wall Jump
	if is_on_wall() and Input.is_action_just_pressed("up"):
		velocity.y = salto
		velocity.x = -velocity.x
		print("si")
		
	
	#movimiento base
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * velocidad
	else:
		velocity.x = move_toward(velocity.x, 0, velocidad)
	
	# Activa el dash 
	if not dash and Input.is_action_just_pressed("dash"):
		dash = true
		velocidad = 1700
		$Timer.start(0.2)
		

	move_and_slide()

# Reset de stats luego del dash
func _on_timer_timeout():
	$Timer.stop()
	dash = false
	velocidad = 300

