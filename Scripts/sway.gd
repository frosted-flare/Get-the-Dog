extends Node3D
var sway_timer = randf_range(0,10)
@export var sway_amount_h = 0.004
@export var sway_amount_v = 0.0005
@export var sway_speed  = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sway_timer += delta * sway_speed
	$".".position.y = $".".position.y + cos(sway_timer) * sway_amount_v
	$".".position.x = $".".position.x + sin(sway_timer) * sway_amount_h
