extends Node3D

var quick_time_text = "Dodge The Fragment!"
var fragment = preload("res://Scenes/fragment.tscn")
var dog = preload("res://Scenes/dog.tscn")
var player
@export var level  = 0

func play_transition():
	player.find_child("Camera3D").find_child("UI").visible = true
	player.find_child("Camera3D").find_child("UI").find_child("Transition").position.y = 1080
	player.find_child("Camera3D").find_child("UI").find_child("Transition").visible = true
	var ui_tween = create_tween()
	ui_tween.tween_property(player.find_child("Camera3D").find_child("UI").find_child("Transition"),"position:y",-1080,4)
	$TransitionTimer.start()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $Player
	
	player.find_child("Camera3D").find_child("Left_Arm").visible = false
	player.find_child("Camera3D").find_child("Right_Arm").visible = false
	await get_tree().create_timer(2).timeout 
	$Camera3D/AnimationPlayer.play("Boat_Look")
	
	await get_tree().create_timer(3.0).timeout 
	$Map/Ship/NavRegion/CharacterBody3D.go_to_pos($Map/Ship/NavRegion/Position1.global_position)
	await get_tree().create_timer(3.0).timeout 
	$Map/Ship/NavRegion/CharacterBody3D.go_to_pos($Map/Ship/NavRegion/Position2.global_position)
	await get_tree().create_timer(3.0).timeout 
	$Map/Ship/NavRegion/CharacterBody3D.go_to_pos($Map/Ship/NavRegion/Position3.global_position)
	await get_tree().create_timer(3.0).timeout 
	$Map/Ship/NavRegion/CharacterBody3D.go_to_pos($Map/Ship/NavRegion/Position4.global_position)
	await get_tree().create_timer(3).timeout 
	player.in_transition = true
	play_transition()
	await get_tree().create_timer(2).timeout 
	$Map/Ship/NavRegion/CharacterBody3D.queue_free()
	player.rotation = Vector3(0,-1.5,0)
	
	$DirectionalLight3D.light_energy = 0.5
	$Map/Ship.sway_amount_v = 0.005
	$Map/Ship.sway_amount_h = 0.08
	$Map/Ship.sway_speed = 2
	$Camera3D/AnimationPlayer.play("Storm")
	await get_tree().create_timer(4).timeout 
	player.in_transition = false
	$Map/Ship/NavRegion/Lightning.visible = true
	await get_tree().create_timer(0.5).timeout 
	$Map/Ship/NavRegion/Lightning.visible = false
	$MusicPlayer.play()
	# Level 1 #

	$Player.global_position = $Map/ShipLevel/Spawn.global_position
	player.find_child("Camera3D").current = true
	$Camera3D.current = false
	level = 1
	$Map/Ship.sway_amount_v = 0
	$Map/Ship.sway_amount_h = 0
	$Map/Ship.sway_speed = 0
	
	$RandomFragmentTimer.start()
	player.find_child("Camera3D").find_child("UI").find_child("Info").visible = true
	player.find_child("Camera3D").find_child("UI").find_child("Info").find_child("Text").text = "Get To The Other End Of The Boat!"
	
	
	while true:
		await get_tree().create_timer(0.25).timeout 
		if level == 2:
			break
	player.find_child("Camera3D").find_child("UI").find_child("Info").visible = false
	player.in_transition = true
	player.dodging = false
	player.velocity = Vector3(0,0,0)
	play_transition()

	await get_tree().create_timer(2).timeout 
	$Player.global_position = $"Level 2/Teleport_Pos".global_position
	player.rotation = Vector3(0,0,0)
	await get_tree().create_timer(2).timeout 
	player.in_transition = false
	while true:
		await get_tree().create_timer(0.25).timeout 
		if level == 3:
			break
	player.in_transition = true
	player.dodging = false
	player.velocity = Vector3(0,0,0)
	play_transition()

	await get_tree().create_timer(2).timeout 
	$Player.global_position = $Deck2/Teleport_Pos.global_position
	player.find_child("Camera3D").find_child("UI").find_child("Info").visible = true
	player.find_child("Camera3D").find_child("UI").find_child("Info").find_child("Text").text = "Swim to the end!"
	await get_tree().create_timer(2).timeout 
	player.in_transition = false
	player.swimming = true
	player.speed = 7.5
	player.find_child("UI").find_child("Underwater").visible = true
	player.find_child("UI").visible = true
	player.find_child("SwimTimer").start()
	
	while true:
		await get_tree().create_timer(0.25).timeout 
		if level == 4:
			break

	player.find_child("Camera3D").find_child("UI").find_child("Info").visible = false
	level = 4
	player.in_transition = true
	player.dodging = false
	player.velocity = Vector3(0,0,0)
	play_transition()

	await get_tree().create_timer(2).timeout 
	player.global_position = $NavigationRegion3D2/Deck3/Teleport_Pos.global_position
	player.rotation = Vector3(0,0,0)
	await get_tree().create_timer(2).timeout 
	player.in_transition = false

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func quick_time_event():
	var player_ui = player.find_child("Camera3D").find_child("UI")
	
	player_ui.find_child("QuickTime").show()
	player_ui.find_child("QuickTime").position.y = 1080
	var ui_tween = create_tween()
	ui_tween.tween_property(player_ui.find_child("QuickTime"),"position:y",0,1)
	player_ui.show()
	player_ui.find_child("QuickTime").find_child("QuickTimeText").text = quick_time_text
	player_ui.find_child("QuickTime").find_child("QuickTimeTimer").wait_time = 2
	player_ui.find_child("QuickTime").start()
	
	player.quick_time = true

func fail_time_event():
	$Player.death()
	
func pass_time_event():
	var new_fragment = fragment.instantiate()
	new_fragment.global_position = player.global_position + Vector3(0,10,0)
	$Player_Fragments.add_child(new_fragment)
	player.dodge()

func _on_random_fragment_timer_timeout() -> void:
	if randi_range(1,30) == 1 and player.quick_time == false and level == 1:
		quick_time_event()
	if randi_range(1,2) == 1 and level == 1:
		var new_fragment = fragment.instantiate()
		$Player_Fragments.add_child(new_fragment)
		new_fragment.global_position = player.global_position + Vector3(randi_range(-10,10),randi_range(30,50),randi_range(0,20))
		
		new_fragment.lock_tracking()

func _on_transition_timer_timeout() -> void:
	player.find_child("Camera3D").find_child("UI").find_child("Transition").position.y = 1080
	player.find_child("Camera3D").find_child("UI").find_child("Transition").visible = false

func unlock_lock_box():
	$Food.global_position = $LockBox.global_position - Vector3(0,0.8,0)
	$LockBox.queue_free()
	
