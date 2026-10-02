extends StaticBody3D
var sway_timer = randf_range(0,10)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sway_timer += delta
	$".".position.y = $".".position.y + cos(sway_timer) * 0.001
	$".".position.x = $".".position.x + sin(sway_timer) * 0.004
