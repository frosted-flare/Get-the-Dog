extends Area3D

var main_scene
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_scene = $".".owner
	player = main_scene.find_child("Player")
	
func _process(delta: float) -> void:
	pass
	
func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		main_scene.quick_time_event()
