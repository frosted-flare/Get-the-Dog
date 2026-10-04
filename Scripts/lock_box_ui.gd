extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $"../../..".lockbox_interacting == true:
		$Node2D/Panel/Dial.rotation += 3*delta
	if 	$Node2D/Panel/Dial.rotation >= 4.5:
		$Node2D/Panel/Dial.rotation = -1.8
