extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const mouse_sensitivity_x = 1
const mouse_sensitivity_y = 1

@export var able_to_interact_with_cannon = false
@export var able_to_climb = false
@export var able_to_descend = false
@export var ladder = false
@export var climbing = false
@export var descending = false

var cannon_interacting = false

var main_scene
var cannon 

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	main_scene = $".".owner
	cannon = main_scene.find_child("Cannon")
	
	$".".rotation.y = 0
	$Camera3D.rotation.x = 0
	
func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle shoot.
	if Input.is_action_just_pressed("Fire") and cannon_interacting == true:
		cannon.fire()
		
	if Input.is_action_just_pressed("Interact") and cannon_interacting == true:
		$Camera3D.current = true
		cannon.find_child("Model").find_child("Camera3D").current = false
		cannon_interacting = false
				
	elif Input.is_action_just_pressed("Interact") and able_to_interact_with_cannon == true:
		$Camera3D.current = false
		cannon.find_child("Model").find_child("Camera3D").current = true
		cannon_interacting = true
		$Camera3D/UI.visible = false
				
	if Input.is_action_just_pressed("Interact") and able_to_climb == true and not ladder is bool:
		climbing = true
		var move_tween = create_tween()
		move_tween.tween_property($".","global_position",ladder.find_child("StartClimbPoint").global_position,0.25)
		$Camera3D/UI.visible = false

	elif Input.is_action_just_pressed("Interact") and able_to_descend == true and not ladder is bool:
		descending = true
		var move_tween = create_tween()
		move_tween.tween_property($".","global_position",ladder.find_child("EndClimbPoint").global_position,0.25)
		$Camera3D/UI.visible = false

	
	if cannon_interacting == false and climbing == false and descending == false:
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("Left", "Right", "Foward", "Backwards")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		move_and_slide()

	elif climbing == false and descending == false:
		if Input.is_action_pressed("Left"):
			cannon.rotation.y += 0.01
		elif Input.is_action_pressed("Right"):
			cannon.rotation.y -= 0.01
		if Input.is_action_pressed("Foward"):
			cannon.rotation.x += 0.01
			cannon.rotation.x = clamp(cannon.rotation.x,-0.6,0.4)
		elif Input.is_action_pressed("Backwards"):
			cannon.rotation.x -= 0.01
			cannon.rotation.x = clamp(cannon.rotation.x,-0.6,0.4)
	elif climbing == true:
		$".".velocity.y = 2
		$".".velocity.x = 0
		$".".velocity.z = 0
		move_and_slide()
	elif descending == true:
		$".".velocity.y = -2
		$".".velocity.x = 0
		$".".velocity.z = 0
		move_and_slide()

func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		if not cannon_interacting:
			$".".rotation.y -= event.relative.x / 1000
			$Camera3D.rotation.x -= event.relative.y / 1000
			$Camera3D.rotation.x = clamp($Camera3D.rotation.x,-0.85,0.75)
		
	
	
