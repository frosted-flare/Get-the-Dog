extends CharacterBody3D


const SPEED = 1
const JUMP_VELOCITY = 4.5
var main_scene
var moving = false
var found_food = false
var closest_food = false
var direction = Vector3()
var state = "Idle"
var next_location 
var about_to_jump = false 

func _ready():
	main_scene = $".".owner
	await get_tree().create_timer(1.0).timeout

func _physics_process(delta: float) -> void:
	if state == "Track":
		var current_location = global_transform.origin
		next_location = $NavigationAgent3D.get_next_path_position()
		if $".".global_position.distance_to(next_location) > 1:
			$".".look_at(Vector3(next_location.x,next_location.y,next_location.z))
		var new_velocity = (next_location-current_location).normalized() * 3
		velocity = velocity.move_toward(new_velocity, .25)
		if is_on_floor():
			$Dog.find_child("AnimationPlayer").play("Walk-loop")
	elif state == "Idle":
		$Dog.find_child("AnimationPlayer").stop(false)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	

func _on_timer_timeout() -> void:
	var bullets = main_scene.find_child("Bullets").get_children()
	var closest_food_distance = 10000
	for bullet in bullets:
		if bullet is food_object:
			var distance = global_position.distance_to(bullet.global_position)
			if distance < 1:
				bullet.queue_free()
				closest_food = false
				moving = false
				found_food = false
				state = "Idle"
				velocity = Vector3(0,0,0)

			elif found_food is bool and closest_food is bool:
				if distance < closest_food_distance:
					closest_food_distance = distance
					closest_food = bullet
	
	if is_instance_valid(closest_food) and is_on_floor() and about_to_jump == false:
		found_food = true
		state = "Track"
		$NavigationAgent3D.target_position = closest_food.position


func _on_navigation_agent_3d_link_reached(details: Dictionary) -> void:
	state = "Jump"
	about_to_jump = true
	if $".".global_position.distance_to(details["link_entry_position"]) < $".".global_position.distance_to(details["link_exit_position"]):
		next_location = details["link_exit_position"]
	else:
		next_location = details["link_entry_position"]
	velocity = Vector3(0,0,0)
	$JumpTimer.start()
	$Dog.find_child("AnimationPlayer").stop()
	$Dog.find_child("AnimationPlayer").play("Jump")

func _on_jump_timer_timeout() -> void:
	about_to_jump = false 
	if $".".global_position.distance_to(next_location) > 1:
		$".".look_at(Vector3(next_location.x,next_location.y,next_location.z))
	var current_location = global_transform.origin
	var new_velocity = (next_location-current_location).normalized() * $".".global_position.distance_to(next_location)
	velocity = new_velocity
	velocity.y += 5
	$Dog.find_child("AnimationPlayer").stop(false)
