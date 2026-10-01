extends Node3D

var cannon_ball = preload("res://Scenes/cannon_ball.tscn")

var main_scene
var cannon_strength = 50
var reload = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_scene = $".".owner

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func fire():
	if reload == false:
		var direction = -global_transform.basis.z
		var ball = cannon_ball.instantiate()
		ball.global_position = $Model/Out.global_position
		main_scene.find_child("Bullets").add_child(ball)
		ball.apply_central_impulse(direction * cannon_strength)
		
		reload = true
		$ShootTimer.start()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		var player = body
		var player_ui = body.find_child("Camera3D").find_child("UI")
		
		player_ui.find_child("Text").text = "Press E to interact"
		player_ui.visible = true
		player.able_to_interact_with_cannon = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		var player = body
		var player_ui = body.find_child("Camera3D").find_child("UI")
		player_ui.visible = false
		player.able_to_interact_with_cannon = false
		
func _on_shoot_timer_timeout() -> void:
	reload = false
