extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_message(text):
	$".".show()
	var completed_text = ""
	
	for letter in text:
		completed_text = completed_text + letter
		$Text.text = completed_text
		await get_tree().create_timer(0.1).timeout 
	
