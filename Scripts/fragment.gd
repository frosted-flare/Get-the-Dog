extends RigidBody3D

var main_scene
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_scene = get_tree().current_scene
	player = main_scene.find_child("Player")
	self.global_position = player.global_position + Vector3(0,20,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.global_position.x = player.global_position.x
	self.global_position.z = player.global_position.z
