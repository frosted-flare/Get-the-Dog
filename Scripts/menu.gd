extends Node2D

var fullscreen = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_fullscreen_pressed() -> void:
	fullscreen = not fullscreen
	if fullscreen == true:
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED

func _on__pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_2_pressed() -> void:
	$CanvasLayer/Settings.show()
	$CanvasLayer/Main.hide()
	
func _on_3_pressed() -> void:
	$CanvasLayer/Main.hide()
	$CanvasLayer/Credits.show()
	
func _on_4_pressed() -> void:
	get_tree().quit()

func _on_texture_button_pressed() -> void:
	$CanvasLayer/Settings.hide()
	$CanvasLayer/Main.show()


func _on_texture_2_button_pressed() -> void:
	$CanvasLayer/Main.show()
	$CanvasLayer/Credits.hide()
