extends Node3D

var quick_time_text = "Dodge The Fragment!"
var fragment = preload("res://Scenes/fragment.tscn")
var dog = preload("res://Scenes/dog.tscn")
var player
var quicktimekeys = ["K","J","X","Y","Z"]
var in_end = false
var dialogue_active = false
@export var level  = 0

func play_transition():
	player.find_child("Camera3D").find_child("UI").visible = true
	player.find_child("Camera3D").find_child("UI").find_child("Transition").position.y = 1080
	player.find_child("Camera3D").find_child("UI").find_child("Transition").visible = true
	var ui_tween = create_tween()
	ui_tween.tween_property(player.find_child("Camera3D").find_child("UI").find_child("Transition"),"position:y",-1080,4)
	$TransitionTimer.start()
	
# Called when the node enters the scene tree for the first time.

func end_game_scene():
	in_end = true
	player.find_child("Camera3D").current = false
	$EndScene.visible = true
	$EndScene/Camera3D2.current = true
	player.find_child("Camera3D").find_child("UI").find_child("End").visible = true
	player.find_child("Camera3D").find_child("UI").find_child("Panel").visible = false
	player.find_child("Camera3D").find_child("UI").find_child("ItemFind").visible = false
	
	player.find_child("Camera3D").find_child("UI").find_child("Dialogue").show_message("Here we are... At the end of the world. But I am here with you!")
	player.find_child("Camera3D").find_child("UI").find_child("Dialogue").show_message("I can't recap what happened in the last few hours that led us exactly here. Onto this Island.")
	player.find_child("Camera3D").find_child("UI").find_child("Dialogue").show_message("The place I've been looking for what seems decades. The one place that would save you.")
	player.find_child("Camera3D").find_child("UI").find_child("Dialogue").show_message("It cost me everything but I would do it over and over again.
You made it! That's all that counts.")




func setup_level_1():
	player.in_transition = true
	play_transition()
	await get_tree().create_timer(2).timeout 
	$Map/Ship/NavRegion/CharacterBody3D.queue_free()
	player.rotation = Vector3(0,-1.5,0)
	
	$DirectionalLight3D.light_energy = 0.5
	$Map/Ship.sway_amount_v = 0.005
	$Map/Ship.sway_amount_h = 0.08
	$Map/Ship.sway_speed = 2
	$tornado.show()
	$Sea.show()
	$SeaCalm.hide()
	$Camera3D/AnimationPlayer.play("Storm")
	$ThunderSound.play()
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
	$ThunderSound.play()
	player.find_child("Camera3D").find_child("UI").find_child("Dialogue").show_message("I got to reach the end of the ship, so I can reach the next deck and rescue my dog!")
	$RandomFragmentTimer.start()
	
func setup_level_2():
	level = 2
	$tornado.hide()
	player.in_transition = true
	player.dodging = false
	player.velocity = Vector3(0,0,0)
	play_transition()
	var quick_time_key = false
	player.find_child("Camera3D").find_child("UI").find_child("QuickTime").visible = false
	await get_tree().create_timer(2).timeout 
	$DirectionalLight3D.light_energy = 4
	player.speed = 3
	player.jump_speed = 4
	
	$Player.global_position = $"Level 2/Teleport_Pos".global_position
	player.rotation = Vector3(0,-1.75,0)
	await get_tree().create_timer(2).timeout 
	player.find_child("Camera3D").find_child("UI").find_child("Dialogue").show_message("I can use these cannon's to block up the brown piles of Debris.")
	player.in_transition = false
	
func setup_level_3():
	level = 3
	player.in_transition = true
	player.dodging = false
	player.velocity = Vector3(0,0,0)
	play_transition()

	await get_tree().create_timer(2).timeout 
	$Player.global_position = $"Level 3/Teleport_Pos".global_position
	player.find_child("Camera3D").position.y = 0.5
	player.rotation = Vector3(0,-1.75,0)
	player.speed = 2.5
	await get_tree().create_timer(2).timeout 
	player.find_child("Camera3D").find_child("UI").find_child("Dialogue").show_message("I got to reach the end by swimming. However, a shark from the sea has managed to get in the water.")
	$RandomSharkTimer.start()
	player.in_transition = false
		
func setup_level_4():
	level = 4
	player.find_child("Camera3D").position.y = 1.739
	player.in_transition = true
	player.dodging = false
	player.velocity = Vector3(0,0,0)
	play_transition()

	await get_tree().create_timer(2).timeout 
	player.global_position = $DogLevel/NavigationRegion3D2/Teleport_Pos.global_position
	$PlayDog.global_position = $DogLevel/NavigationRegion3D2/Dog_Teleport_Pos.global_position
	player.find_child("Camera3D").find_child("UI").find_child("Dialogue").show_message("I can throw food to the coloured platforms on the otherside, and my dog will follow.")
	player.rotation = Vector3(0,0,0)
	await get_tree().create_timer(2).timeout 
	player.in_transition = false
	player.speed = 5
	player.jump_speed = 5
	
func setup_level_5():
	level = 5
	player.in_transition = true
	player.dodging = false
	player.velocity = Vector3(0,0,0)
	play_transition()

	await get_tree().create_timer(2).timeout 
	$SeaCalm.show()
	$Sea.hide()
	player.find_child("Camera3D").current = false
	$Camera3D.current = true
	$Map/Ship.visible = false
	$Map/BrokenBoat.visible = true
	player.find_child("Camera3D").find_child("UI").find_child("Dialogue").show_message("I need to collect the herb near the water in the center of the island.")
	
func reset_level():
	$FailSound.play()
	if level == 1:
		setup_level_1()
	elif level == 2:
		setup_level_2()
	elif level == 3:
		setup_level_3()
	elif level == 4:
		setup_level_4()
	elif level == 5:
		setup_level_5()
		
func _ready() -> void:
	player = $Player
	#$SeaMusicPlayer.play()
	#player.find_child("Camera3D").find_child("Left_Arm").visible = false
	#player.find_child("Camera3D").find_child("Right_Arm").visible = false
	#await get_tree().create_timer(2).timeout 
	#$Camera3D/AnimationPlayer.play("Boat_Look")
	#
	#player.find_child("Camera3D").find_child("UI").find_child("Dialogue").show_message("On this day 2 years ago I got the news about his illness. 
	#That he would only have 2 more years to live...")
	#player.find_child("Camera3D").find_child("UI").find_child("Dialogue").show_message("Since that day I asked every doctor, 
	#looked through all the books I could find and search for alternative medicines.")
	#player.find_child("Camera3D").find_child("UI").find_child("Dialogue").show_message("I finally found him. A herbalist. He told me there is one thing. 
	#Only one thing that could rescue my best friend from death.")
	#player.find_child("Camera3D").find_child("UI").find_child("Dialogue").show_message("It is a plant that grows where no human lives. 
	#That I would have to search through the depths of the sea. ")
	#player.find_child("Camera3D").find_child("UI").find_child("Dialogue").show_message("I bought this boat with all the money I had left. 
	#Sold my house and quit my Job...")
	#player.find_child("Camera3D").find_child("UI").find_child("Dialogue").show_message("...so I could spend all my time with him and save his life. He is getting weaker.")
	#player.find_child("Camera3D").find_child("UI").find_child("Dialogue").show_message("The last few weeks he slept more and didn't even hunt the dolphins anymore. 
	#Each night I'm worried he wouldn't wake up the next day. ")
	#player.find_child("Camera3D").find_child("UI").find_child("Dialogue").show_message("I have to hurry! I'm getting closer. I Just know it")
		#
	#while true:
		#await get_tree().create_timer(0.25).timeout 
		#if dialogue_active == false:
			#break
			#
	#await get_tree().create_timer(3.0).timeout 
	#$Map/Ship/NavRegion/CharacterBody3D.go_to_pos($Map/Ship/NavRegion/Position1.global_position)
	#await get_tree().create_timer(3.0).timeout 
	#$Map/Ship/NavRegion/CharacterBody3D.go_to_pos($Map/Ship/NavRegion/Position2.global_position)
	#await get_tree().create_timer(3.0).timeout 
	#$Map/Ship/NavRegion/CharacterBody3D.go_to_pos($Map/Ship/NavRegion/Position3.global_position)
	#await get_tree().create_timer(3.0).timeout 
	#$Map/Ship/NavRegion/CharacterBody3D.go_to_pos($Map/Ship/NavRegion/Position4.global_position)
	#await get_tree().create_timer(3).timeout 
	#
	#setup_level_1()
	#$SeaMusicPlayer.stop()
	#while true:
		#await get_tree().create_timer(0.25).timeout 
		#if level == 2:
			#break
			#
	#$WinSound.play()
	#setup_level_2()
	#
	#while true:
		#await get_tree().create_timer(0.25).timeout 
		#if level == 3:
			#break
	#$WinSound.play()
	#setup_level_3()
	#
	#while true:
		#await get_tree().create_timer(0.25).timeout 
		#if level == 4:
			#break
	#$WinSound.play()
	setup_level_4()

	while true:
		await get_tree().create_timer(0.25).timeout 
		if level == 5:
			break
			
	$WinSound.play()
	setup_level_5()
	await get_tree().create_timer(2).timeout 
	$SeaMusicPlayer.play()
	$Map/BrokenBoat/Dog/AnimationPlayer2.play("DogSwim")
	$Map/BrokenBoat/SwimmingPlayer/AnimationPlayer2.play("Swim")
	await get_tree().create_timer(3).timeout 
	
	player.in_transition = true
	player.dodging = false
	player.velocity = Vector3(0,0,0)
	play_transition()

	await get_tree().create_timer(2).timeout 
	player.global_position = $IslandRegion/Island2/PlayerIslandSpawn.global_position
	$Camera3D.current = false
	player.find_child("Camera3D").current = true
	player.rotation = Vector3(0,0,0)
	$Map/BrokenBoat/Dog.queue_free()
	$Map/BrokenBoat/SwimmingPlayer.queue_free()
	$Food.queue_free()

	await get_tree().create_timer(2).timeout 
	
	player.in_transition = false
	$Dog.visible = true
	player.find_child("Camera3D").find_child("UI").find_child("ItemFind").visible = true
	
func quick_time_event():
	
	var player_ui = player.find_child("Camera3D").find_child("UI")
	var key = str(quicktimekeys[randi_range(0,4)])
	
	player_ui.find_child("QuickTime").show()
	player_ui.find_child("QuickTime").position.y = 1080
	var ui_tween = create_tween()
	ui_tween.tween_property(player_ui.find_child("QuickTime"),"position:y",0,1)
	player_ui.show()
	player_ui.find_child("QuickTime").find_child("QuickTimeText").text = quick_time_text
	player_ui.find_child("QuickTime").find_child("Label2").text = key
	player.quick_time_key = key
	player_ui.find_child("QuickTime").find_child("QuickTimeTimer").wait_time = 2
	
	player_ui.find_child("QuickTime").start()
	
	player.quick_time = true
	
func shark_quick_time_event():
	
	var player_ui = player.find_child("Camera3D").find_child("UI")
	var key = str(quicktimekeys[randi_range(0,4)])

	player_ui.find_child("QuickTime").find_child("QuickTimeText").text = "Dodge the shark"
	player_ui.find_child("QuickTime").show()
	player_ui.find_child("QuickTime").position.y = 1080
	var ui_tween = create_tween()
	ui_tween.tween_property(player_ui.find_child("QuickTime"),"position:y",0,1)
	player_ui.show()
	player_ui.find_child("QuickTime").find_child("Label2").text = key
	player.quick_time_key = key
	player_ui.find_child("QuickTime").find_child("QuickTimeTimer").wait_time = 3
	
	player_ui.find_child("QuickTime").start()
	
	player.shark_quick_time = true

func fail_time_event():
	reset_level()
	
func pass_time_event():
	if level == 3:
		player.swim_dodge()
	else:
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
	
func _on_random_shark_timer_timeout() -> void:
	if randi_range(1,50) == 1 and player.quick_time == false and player.swimming == true:
		shark_quick_time_event()
