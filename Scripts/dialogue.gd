extends Panel
var stack = []
var main_scene
@export var text_debounce = 0.05
@export var paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	main_scene = get_owner().get_owner()

func show_message(text):
	if stack == []:
		stack.append(text)
		while true:
			main_scene.dialogue_active = true
			$".".show()
			var completed_text = ""
			
			for letter in stack[0]:
				
				completed_text = completed_text + letter
				$Box/Text.text = completed_text
				await get_tree().create_timer(text_debounce).timeout 
				while true:
					if paused == false:
						break
					await get_tree().create_timer(0.1).timeout 

				
			await get_tree().create_timer(2).timeout 
			stack.remove_at(0)
			if stack == []:
				main_scene.dialogue_active = false
				$".".hide()
				break
	else:
		stack.append(text)
