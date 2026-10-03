extends RigidBody3D
class_name food_object

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Decay.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $RayCast3D.is_colliding():
		$".".linear_velocity = Vector3(0,0,0)

func _on_decay_timeout() -> void:
	self.queue_free()
