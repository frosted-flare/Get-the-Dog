extends CharacterBody3D


const JUMP_VELOCITY = 4.5

const mouse_sensitivity_x = 1
const mouse_sensitivity_y = 1

@export var able_to_interact_with_cannon = false
@export var able_to_interact_with_food = false
@export var able_to_interact_with_lockbox = false
@export var able_to_climb = false
@export var able_to_descend = false
@export var ladder = false
@export var climbing = false
@export var descending = false
@export var holding_food = false
@export var speed = 10
@export var quick_time = false

var cannon_interacting = false
var lockbox_interacting = false
var dodging = false
var sway_timer = 0
var main_scene
var cannon 
var food_box
var dead = false
var swimming = false
var in_transition = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	main_scene = $".".owner
	cannon = main_scene.find_child("Cannon")
	
	$".".rotation.y = 3
	$Camera3D.rotation.x = 0
	food_box = main_scene.find_child("Food")
	
func _physics_process(delta: float) -> void:
	if dead == true:
		return
		
	# Add the gravity.
	if not is_on_floor():
		if swimming == false:
			
			velocity += get_gravity() * delta
		else:
			velocity += get_gravity() * delta / 10
	else:
		dodging = false
	
	if dodging == false:
		$Camera3D.position.y = 0.739
			
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and main_scene.level != 0 and in_transition == false:
		if swimming:
			velocity.y = JUMP_VELOCITY / 2
		elif is_on_floor():
			velocity.y = JUMP_VELOCITY
			
	# Handle shoot.
	if Input.is_action_just_pressed("Fire") and cannon_interacting == true:
		cannon.fire()
	# Handle shoot.
	if Input.is_action_just_pressed("Fire") and holding_food == true and cannon_interacting == false:
		food_box.fire()
	# Handle quicktime.
	if Input.is_action_just_pressed("Fire") and quick_time == true:
		var ui_tween = create_tween()
		ui_tween.tween_property($Camera3D/UI/QuickTime,"position:y",1080,1)
		quick_time = false
		main_scene.pass_time_event()
		
	if Input.is_action_just_pressed("Interact") and cannon_interacting == true:
		$Camera3D.current = true
		cannon.find_child("Camera3D").current = false
		cannon_interacting = false
		$".".show()
		$"../Food".show()

	elif Input.is_action_just_pressed("Interact") and able_to_interact_with_cannon == true:
		$Camera3D.current = false
		cannon.find_child("Camera3D").current = true
		cannon_interacting = true
		$Camera3D/UI.visible = false
		$".".hide()
		$"../Food".hide()
	
	if Input.is_action_just_pressed("Interact") and lockbox_interacting == true:
		pass

	elif Input.is_action_just_pressed("Interact") and able_to_interact_with_lockbox == true:
		lockbox_interacting = true

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
		
	if Input.is_action_just_pressed("Interact") and able_to_interact_with_food == true:
		holding_food = true
		$Camera3D/RemoteTransform3D.remote_path = food_box.get_path()

	if cannon_interacting == false and climbing == false and descending == false and dodging == false:
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("Left", "Right", "Foward", "Backwards")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction and main_scene.level != 0  and in_transition == false:
			sway_timer += delta * 10
			if $"..".level == 1:
				$Camera3D.position.y = $Camera3D.position.y + sin(sway_timer) * 0.004
				$Camera3D.position.x = $Camera3D.position.x + sin(sway_timer) * 0.016
				$Camera3D/Right_Arm.position.y = $Camera3D/Right_Arm.position.y + cos(sway_timer) * 0.008
				$Camera3D/Left_Arm.position.y = $Camera3D/Left_Arm.position.y + cos(sway_timer-PI) * 0.008 
				$Camera3D.rotation.y = cos(sway_timer) * 0.008

			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		elif main_scene.level != 0 and in_transition == false:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
			$Camera3D.position.y = $Camera3D.position.y + sin(0) * 0.004
			$Camera3D.position.x = $Camera3D.position.x + sin(0) * 0.016
		move_and_slide()
		
	if dodging == true:
		$Camera3D.position.y = -0.25
		move_and_slide()
	
	
	elif climbing == false and descending == false:
		if cannon_interacting == true:
			if Input.is_action_pressed("Left"):
				cannon.rotation.y += 0.3 * delta
			elif Input.is_action_pressed("Right"):
				cannon.rotation.y -= 0.3 * delta
			if Input.is_action_pressed("Foward"):
				cannon.rotation.x += 0.3 * delta
				cannon.rotation.x = clamp(cannon.rotation.x,-0.6,0.4)
			elif Input.is_action_pressed("Backwards"):
				cannon.rotation.x -= 0.3 * delta
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
	if dead == false and main_scene.level != 0 and in_transition == false:
		if event is InputEventMouseMotion and dodging == false:
			if not cannon_interacting:
				$".".rotation.y -= event.relative.x / 1000
				$Camera3D.rotation.x -= event.relative.y / 1000
				$Camera3D.rotation.x = clamp($Camera3D.rotation.x,-0.85,1.5)
				
func death():
	dead = true
	pass
		
func dodge():
	dodging = true
	velocity = transform.basis.z * 15
	velocity.y += 2
