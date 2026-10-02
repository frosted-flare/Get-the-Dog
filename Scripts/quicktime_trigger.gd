extends Area3D

var main_scene
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_scene = $".".owner
	player = main_scene.find_child("Player")
	
func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		var player = body
		var player_ui = body.find_child("Camera3D").find_child("UI")
		
		player_ui.find_child("QuickTime").start()
		player.quick_time = true
