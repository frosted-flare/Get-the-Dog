extends CharacterBody3D



const mouse_sensitivity_x = 1
const mouse_sensitivity_y = 1

@export var able_to_interact_with_cannon = false
@export var able_to_interact_with_food = false
@export var able_to_interact_with_lockbox = false
@export var able_to_interact_pickup = false
@export var able_to_interact_give_dog_herb = false
@export var able_to_get_herb = false
@export var able_to_climb = false
@export var able_to_descend = false
@export var ladder = false
@export var climbing = false
@export var descending = false
@export var holding_food = false
@export var speed = 10
@export var quick_time = false
@export var shark_quick_time = false
@export var jump_speed = 4.5
@export var holding_herb = false

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
var aim_time = 0 
var quick_time_key = false
var itemspickedup = {"wood":0,"stone":0,"branch":0,"sharp_stone":0}
var ablepickupitem = false
var saved_dog = false
var game_end = false
var game_end_timer_started = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	main_scene = $".".owner
	
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
	
	if dodging == false and main_scene.level != 3:
		$Camera3D.position.y = 0.739
	
	if Input.is_action_pressed("Interact"):
		$Camera3D/UI/Dialogue.text_debounce = 0.01
	else:
		$Camera3D/UI/Dialogue.text_debounce = 0.05

	# Handle jump.
	if Input.is_action_pressed("Jump") and main_scene.level != 0 and in_transition == false:
		if swimming:
			velocity.y = jump_speed / 2
		elif is_on_floor():
			velocity.y = jump_speed
			
	if Input.is_action_pressed("Menu"):
		get_tree().paused = true
		$Camera3D/UI/Dialogue.paused = true
		$Camera3D/UI/PauseMenu.visible = true
		$Camera3D/UI.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.is_action_pressed("Interact") and game_end == true:
		main_scene.end_game_scene()
	
	if saved_dog == true and itemspickedup["wood"] == 5 and itemspickedup["stone"] == 12 and itemspickedup["branch"] == 3 and itemspickedup["sharp_stone"] == 2 and game_end_timer_started == false:
		$Camera3D/UI/Panel/Text.text = "Press E to place campfire(End the game)"
		$Camera3D/UI/Panel.visible = true
		$GameEndTimer.start()
		game_end_timer_started = true
		
	if Input.is_action_just_pressed("Interact") and able_to_interact_pickup and not (ablepickupitem is bool):
		var item_name = str(ablepickupitem.get_script().get_global_name())
		itemspickedup[item_name] = itemspickedup[item_name] + 1
		if item_name == "wood":
			$Camera3D/UI/ItemFind/VBoxContainer/Back2/Wood.text = "Wood:" + str(itemspickedup[item_name]) + "/5"
			if itemspickedup[item_name] == 5:
				$Camera3D/UI/ItemFind/VBoxContainer/Back2.visible = false
		elif item_name == "stone":
			$Camera3D/UI/ItemFind/VBoxContainer/Back3/Stones.text = "Stones:" + str(itemspickedup[item_name]) + "/12"
			if itemspickedup[item_name] == 12:
				$Camera3D/UI/ItemFind/VBoxContainer/Back3.visible = false
		elif item_name == "branch":
			$Camera3D/UI/ItemFind/VBoxContainer/Back4/Branches.text = "Branches:" + str(itemspickedup[item_name]) + "/3"
			if itemspickedup[item_name] == 3:
				$Camera3D/UI/ItemFind/VBoxContainer/Back4.visible = false
		elif item_name == "sharp_stone":
			$"Camera3D/UI/ItemFind/VBoxContainer/Back5/Sharp Stone".text = "SharpStones:" + str(itemspickedup[item_name]) + "/2"
			if itemspickedup[item_name] == 2:
				$Camera3D/UI/ItemFind/VBoxContainer/Back5.visible = false
				
		ablepickupitem.queue_free()
		
	# Handle shoot.
	if Input.is_action_pressed("Fire") and cannon_interacting == true:
		cannon.fire()
	# Handle shoot.
	if Input.is_action_just_pressed("Fire") and holding_food == true and cannon_interacting == false:
		aim_time = 0
	if Input.is_action_pressed("Fire") and holding_food == true and cannon_interacting == false:
		aim_time += delta
	elif Input.is_action_just_released("Fire") and holding_food == true and cannon_interacting == false:
		food_box.fire(aim_time)
	# Handle quicktime.
	if not (quick_time_key is bool):
		if Input.is_action_just_pressed("QuickTime1") and quick_time_key == "K":
			
			var ui_tween = create_tween()
			ui_tween.tween_property($Camera3D/UI/QuickTime,"position:y",1080,1)
			quick_time = false
			quick_time_key = false

			main_scene.pass_time_event()
		elif Input.is_action_just_pressed("QuickTime2") and quick_time_key == "J":
			
			var ui_tween = create_tween()
			ui_tween.tween_property($Camera3D/UI/QuickTime,"position:y",1080,1)
			quick_time = false
			quick_time_key = false
			main_scene.pass_time_event()
		elif Input.is_action_just_pressed("QuickTime3") and quick_time_key == "X":
			
			var ui_tween = create_tween()
			ui_tween.tween_property($Camera3D/UI/QuickTime,"position:y",1080,1)
			quick_time = false
			quick_time_key = false
			main_scene.pass_time_event()
		elif Input.is_action_just_pressed("QuickTime4") and quick_time_key == "Y":
			
			var ui_tween = create_tween()
			ui_tween.tween_property($Camera3D/UI/QuickTime,"position:y",1080,1)
			quick_time = false
			quick_time_key = false
			main_scene.pass_time_event()
		elif Input.is_action_just_pressed("QuickTime5") and quick_time_key == "Z":
			var ui_tween = create_tween()
			ui_tween.tween_property($Camera3D/UI/QuickTime,"position:y",1080,1)
			quick_time = false
			quick_time_key = false
			main_scene.pass_time_event()

	if Input.is_action_just_pressed("Fire") and lockbox_interacting == true:
		if $Camera3D/UI/LockBox/Node2D/Panel/Dial.rotation > 1 and $Camera3D/UI/LockBox/Node2D/Panel/Dial.rotation < 2:
			main_scene.unlock_lock_box()
			lockbox_interacting = false
			$Camera3D/UI.visible = false
			$Camera3D/UI/LockBox.visible = false
		else:
			pass
		
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
		$Camera3D/UI.visible = true
		$Camera3D/UI/LockBox.visible = true
		$Camera3D/UI/Panel.visible = false
		
	if Input.is_action_just_pressed("Interact") and able_to_climb == true and not ladder is bool:
		climbing = true
		var move_tween = create_tween()
		move_tween.tween_property($".","global_position",ladder.find_child("StartClimbPoint").global_position,0.25)
		$Camera3D/UI.visible = false
		
	if Input.is_action_just_pressed("Interact") and able_to_interact_give_dog_herb and holding_herb == true:
		$Camera3D/UI/ItemFind/VBoxContainer/Back7.visible = false
		main_scene.find_child("PlayDog").global_position = main_scene.find_child("Dog").global_position 
		main_scene.find_child("Dog").queue_free()
		saved_dog = true
		$Camera3D/UI/ItemFind/VBoxContainer/Back2.visible = true
		$Camera3D/UI/ItemFind/VBoxContainer/Back3.visible = true
		$Camera3D/UI/ItemFind/VBoxContainer/Back4.visible = true
		$Camera3D/UI/ItemFind/VBoxContainer/Back5.visible = true
		main_scene.find_child("Pickups").position = Vector3(-24.57,3.7,37.4)

		able_to_interact_give_dog_herb = false
		
	if Input.is_action_just_pressed("Interact") and able_to_get_herb:
			$Camera3D/UI/ItemFind/VBoxContainer/Back6.visible = false
			holding_herb = true
			$Camera3D/UI/ItemFind/VBoxContainer/Back7.visible = true


		
	if Input.is_action_just_pressed("Interact") and able_to_interact_with_food == true:
		holding_food = true
		$Camera3D/RemoteTransform3D.remote_path = food_box.get_path()
		able_to_interact_with_food = false
		$Camera3D/UI/Panel.visible = false

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
		
	if dodging == true and main_scene.level != 3:
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
				$Camera3D.rotation.x = clamp($Camera3D.rotation.x,-1.1,1.5)
				
func death():
	dead = true
	$Camera3D/UI.visible = true
	$Camera3D/UI/Death.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func reset():
	pass
		
func dodge():
	dodging = true
	velocity = transform.basis.z * 15
	velocity.y += 2
			
func swim_dodge():
	if global_position.y < -296.7:
		velocity.y += 2
	else:
		velocity.y -= 8
	$"../Shark".global_position = global_position
	$"../Shark/AnimationPlayer".play("SharkAttack")
	
		
func _on_game_end_timer_timeout() -> void:
	game_end = true

func _on_swim_timer_timeout() -> void:
	main_scene.reset_level()
