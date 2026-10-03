extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		var player = body
		var player_ui = body.find_child("Camera3D").find_child("UI")
		player_ui.find_child("QuickTime").visible = false
		player_ui.find_child("Panel").visible = true
		player_ui.find_child("Text").text = "Press E to climb"
		player_ui.visible = true
		player.able_to_climb = true
		player.ladder = self
		
func _on_start_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		var player = body
		var player_ui = body.find_child("Camera3D").find_child("UI")
		player_ui.visible = false
		player.able_to_climb = false
		player.ladder = false
		player_ui.find_child("Panel").visible = false
	
func _on_end_to_leave_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		var player = body
		if player.climbing == true:
			var move_tween = create_tween()
			move_tween.tween_property(player,"global_position",$"EndPoint".global_position,1)
			player.climbing = false

func _on_end_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		var player = body
		var player_ui = body.find_child("Camera3D").find_child("UI")
		player_ui.find_child("Text").text = "Press E to descend"
		player_ui.visible = true
		player.able_to_descend = true
		player.ladder = self

func _on_end_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		var player = body
		var player_ui = body.find_child("Camera3D").find_child("UI")
		player_ui.visible = false
		player.able_to_descend = false
		player.ladder = false
		
func _on_start_to_leave_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		var player = body
		if player.descending == true:
			player.descending = false
