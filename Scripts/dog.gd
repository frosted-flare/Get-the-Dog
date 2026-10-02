extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var main_scene

func _ready():
	main_scene = $".".owner


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()



func _on_timer_timeout() -> void:
	var bullets = main_scene.find_child("Bullets").get_children()
	var closest_food = false
	var closest_food_distance = 10000
	for bullet in bullets:
		if bullet is food_object:
			var distance = global_position.distance_to(bullet.global_position)
			if distance < 1:
				bullet.queue_free()
				
			if distance < closest_food_distance:
				print("hello")
				closest_food_distance = distance
				closest_food = bullet
				
	if not (closest_food is bool):
		print(closest_food.global_position)

		var direction = global_position.direction_to(closest_food.global_position)
		direction.y = 0
		var turn_tween = create_tween()
		turn_tween.tween_property($".","rotation:y",atan2(direction.x,direction.z),0.25)
		$".".velocity.x = direction.x * 4
		$".".velocity.z = direction.z * 4
		
	else:
		$".".velocity.x = 0
		$".".velocity.z = 0
