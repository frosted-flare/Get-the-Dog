extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		if body.holding_herb == true:
			var player = body
			var player_ui = body.find_child("Camera3D").find_child("UI")
			player_ui.find_child("QuickTime").visible = false
			player_ui.find_child("Panel").visible = true
			player_ui.find_child("Text").text = "Press E to give dog herb"
			player_ui.visible = true
			player.able_to_interact_give_dog_herb = true
			player.cannon = self

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		if body.holding_herb == true:
			var player = body
			var player_ui = body.find_child("Camera3D").find_child("UI")
			player.able_to_interact_give_dog_herb = false
			player_ui.find_child("Panel").visible = false
