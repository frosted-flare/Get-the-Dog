extends CharacterBody3D
class_name dog

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
var in_air = false

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
			$DogMesh.find_child("AnimationPlayer").play("Walk-loop")
	elif state == "Idle":
		$DogMesh.find_child("AnimationPlayer").stop(false)
		velocity = Vector3(0,0,0)

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if $RayCast3D.is_colliding() and state == "Jump" and in_air == false:
		state = "Track"
		update_target()
	move_and_slide()
	
func update_target():
	var bullets = main_scene.find_child("Bullets").get_children()
	var closest_food_distance = 10000
	if not (closest_food is bool):
		if closest_food.global_position.y > -320:
			closest_food = false
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

			elif found_food is bool and closest_food is bool and bullet.anchored == true and bullet.global_position.y > -320:
				if distance < closest_food_distance and distance < 10:
					closest_food_distance = distance
					closest_food = bullet
					found_food = true
					moving = true
					state = "Track"
					$NavigationAgent3D.target_position = closest_food.global_position
					
			
func _on_timer_timeout() -> void:
	if state != "Jump":
		update_target()

func _on_navigation_agent_3d_link_reached(details: Dictionary) -> void:
	state = "Jump"
	about_to_jump = true
	if $".".global_position.distance_to(details["link_entry_position"]) < $".".global_position.distance_to(details["link_exit_position"]):
		next_location = details["link_exit_position"]
	else:
		next_location = details["link_entry_position"]
	velocity = Vector3(0,0,0)
	$JumpTimer.start()
	$DogMesh.find_child("AnimationPlayer").stop()
	$DogMesh.find_child("AnimationPlayer").play("Jump")
	in_air = true

func _on_jump_timer_timeout() -> void:
	about_to_jump = false 
	if $".".global_position.distance_to(next_location) > 1:
		$".".look_at(Vector3(next_location.x,next_location.y,next_location.z))
	var current_location = global_transform.origin
	var new_velocity = (next_location-current_location).normalized() * $".".global_position.distance_to(next_location)
	velocity = new_velocity
	velocity.y += 5
	$DogMesh.find_child("AnimationPlayer").stop(false)
	$JumpAirTimer.start()
	in_air = true

func _on_jump_air_timer_timeout() -> void:
	in_air = false
	
func go_to_pos(pos):
	found_food = true
	moving = true
	state = "Track"
	$NavigationAgent3D.target_position = pos


func _on_navigation_agent_3d_target_reached() -> void:
	found_food = false
	state = "Idle"
	velocity = Vector3(0,0,0)
	
	
	
