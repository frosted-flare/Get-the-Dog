extends CharacterBody3D


const SPEED = 1
const JUMP_VELOCITY = 4.5
var main_scene
var moving = false
var found_food = false
var closest_food = false
var direction = Vector3()

func _ready():
	main_scene = $".".owner
	await get_tree().create_timer(1.0).timeout
	$MoveTimer.start()


func _physics_process(delta: float) -> void:
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
			
			elif found_food == false and closest_food == false:
				if distance < closest_food_distance:
					closest_food_distance = distance
					closest_food = bullet
					found_food = true
	if moving == true:
		if is_instance_valid(closest_food):
			$".".velocity.x = direction.x * 3
			$".".velocity.z = direction.z * 3
		
	else:
		$".".velocity.x = 0
		$".".velocity.z = 0
		

func _on_move_timer_timeout():
	moving = true
	$TurnTimer.start()

func _on_turn_timer_timeout() -> void:
	$MoveTimer.start()
	var velocity_tween = create_tween()
	velocity_tween.tween_property($".","velocity",Vector3(0,0,0),0.1)
	moving = false
	if not (closest_food is bool):
		direction = self.global_position.direction_to(closest_food.global_position)
		direction.y = 0
		direction.x += randf_range(-0.7,0.7)
		direction.z += randf_range(-0.7,0.7)
		var turn_tween = create_tween()
		var turn_angle = $".".global_transform.basis.z.angle_to(direction)
		turn_tween.tween_property($".","rotation:y",atan2(direction.x,direction.z),randf_range(0.2,0.5))
