extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func fire():
	var direction_y = $".".rotation.y # Horizontal
	var direction_x = $Pivot.rotation.x # Vertical
	

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		var player = body
		var player_ui = body.find_child("Camera3D").find_child("UI")
		player_ui.visible = true
		player.able_to_interact_with_cannon = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		var player = body
		var player_ui = body.find_child("Camera3D").find_child("UI")
		player_ui.visible = false
		player.able_to_interact_with_cannon = false
