extends Node3D
var main_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_scene = $".".owner

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if main_scene.level == 2:
		$".".rotation.y += 1 * delta
