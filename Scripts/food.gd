extends Node3D

var reload = false
var main_scene
var food_object = preload("res://Scenes/food_object.tscn")
var launch_strength = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_scene = $".".owner


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		var player = body
		var player_ui = body.find_child("Camera3D").find_child("UI")
		
		player_ui.find_child("Text").text = "Press E to pick up"
		player_ui.visible = true
		player.able_to_interact_with_food = true
		player_ui.find_child("Panel").visible = true



func fire():
	if reload == false:
		var direction = -main_scene.find_child("Player").find_child("Camera3D").global_transform.basis.z
		var food = food_object.instantiate()
		main_scene.find_child("Bullets").add_child(food)
		food.global_position = main_scene.find_child("Player").find_child("Camera3D").find_child("Right_Arm").find_child("Throw_Position").global_position
		food.apply_central_impulse(direction * launch_strength)
		
		reload = true
		$ShootTimer.start()

func _on_shoot_timer_timeout() -> void:
	reload = false


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		var player = body
		var player_ui = body.find_child("Camera3D").find_child("UI")
		player_ui.visible = false
		player.able_to_interact_with_food = false
		player_ui.find_child("Panel").visible = false
