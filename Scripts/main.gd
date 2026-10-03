extends Node3D

var quick_time_text = "Dodge The Fragment!"
var fragment = preload("res://Scenes/fragment.tscn")
var player
var part = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $Player
	
	
	# Run Scene #
	
	part = 1
	
	$RandomFragmentTimer.start()
	
	var mast_fall_tween = create_tween()
	mast_fall_tween.tween_property($Boat/Mast,"rotation:x",0,20).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func quick_time_event():
	var player_ui = player.find_child("Camera3D").find_child("UI")
	
	player_ui.show()
	player_ui.find_child("QuickTime").find_child("QuickTimeText").text = quick_time_text
	player_ui.find_child("QuickTime").find_child("QuickTimeTimer").wait_time = 1
	player_ui.find_child("QuickTime").start()
	player_ui.find_child("QuickTime").show()
	player.quick_time = true

func fail_time_event():
	$Player.death()
	
func pass_time_event():
	var new_fragment = fragment.instantiate()
	new_fragment.global_position = player.global_position + Vector3(0,10,0)
	$Player_Fragments.add_child(new_fragment)
	player.dodge()

func _on_random_fragment_timer_timeout() -> void:

	if randi_range(1,2) == 1 and player.quick_time == false and part == 1:
		quick_time_event()
	if randi_range(1,3) == 1 and part == 1:
		var new_fragment = fragment.instantiate()
		new_fragment.global_position = player.global_position + Vector3(randi_range(-2,2),randi_range(30,50),randi_range(10,30))
		new_fragment.lock_tracking()
		$Player_Fragments.add_child(new_fragment)
