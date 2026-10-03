extends RigidBody3D

var main_scene
var player
var lock_tracking_value = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_scene = get_tree().current_scene
	player = main_scene.find_child("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent().name == "Player_Fragments":
		if $RayCast3D.is_colliding():
			$".".freeze = true
			lock_tracking_value = true
			
		if lock_tracking_value == true:
			$".".set_collision_layer_value(2,true)
	
func lock_tracking():
	lock_tracking_value = true
	
