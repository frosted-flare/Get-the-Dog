extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		$"..".level = 2
		var camera = body.find_child("Camera3D")
		camera.position.y = 0.739
		camera.position.x = 0
		camera.find_child("Right_Arm").position.y = -0.316
		camera.find_child("Left_Arm").position.y = -0.316
		camera.rotation.y = 0
