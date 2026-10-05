extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_return_to_pause_pressed() -> void:
	$".".visible = true
	$"../Settings".visible = false
	$ButtonSound.play()

func _on__pressed() -> void:
	get_tree().paused = false
	$".".visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$"../Dialogue".paused = false
	$ButtonSound.play()

func _on_number_2_pressed() -> void:
	$".".visible = false
	$"../Settings".visible = true
	$ButtonSound.play()

func _on_texture_button_3_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	$ButtonSound.play()
