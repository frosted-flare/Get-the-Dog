extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_return_pressed() -> void:
	get_tree().paused = false
	$".".visible = false
	$".".get_parent().visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
func _on_settings_pressed() -> void:
	$".".visible = false
	$"../Settings".visible = true

func _on_return_to_pause_pressed() -> void:
	$".".visible = true
	$"../Settings".visible = false
