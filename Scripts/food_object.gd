extends RigidBody3D
class_name food_object
@export var anchored = false
var main_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_scene = $".".get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $RayCast3D.is_colliding() and anchored == false and $RayCast3D.get_collider().name != "DogLevelHull" :
		print( $RayCast3D.get_collider().name)
		$".".linear_velocity = Vector3(0,0,0)
		anchored = true
