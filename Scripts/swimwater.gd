extends Area3D

var player = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		player = body 
		body.swimming = true
		body.speed = 7.5

func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		body.swimming = false
		body.speed = 10
		
func _on_area_entered(area: Area3D) -> void:
	if area.name == "CamArea" and not (player is bool):
		player.find_child("UI").find_child("Underwater").visible = true
		player.find_child("UI").visible = true
		player.find_child("SwimTimer").start()
		
func _on_area_exited(area: Area3D) -> void:
	if area.name == "CamArea" and not (player is bool):
		player.find_child("UI").find_child("Underwater").visible = false
