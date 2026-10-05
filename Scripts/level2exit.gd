extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if is_instance_valid(body) and body.get_script() != null:
		
		if body.name == "Player" or body.name == "PlayDog":
			$"..".level += 1
		
