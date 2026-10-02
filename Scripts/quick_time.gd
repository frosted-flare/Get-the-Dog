extends Panel

var timer 
var time_elapsed = 0
var var_last_update = 0
var active = false
var main_scene
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $"../../.."
	main_scene = player.owner

func start():
	timer = $QuickTimeTimer
	timer.start()
	$"..".show()
	$"../Panel".hide()
	active = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active == true:
		time_elapsed += delta
		if time_elapsed-var_last_update > 0.1:
			var_last_update = time_elapsed
			$VBoxContainer/Label.text = str(snapped(timer.time_left,0.1))

func _on_quick_time_timer_timeout() -> void:
	if is_instance_valid(player):
		if player.quick_time == true:
			main_scene.fail_time_event()
		$".".hide()
		if is_instance_valid(player):
			player.quick_time = false
