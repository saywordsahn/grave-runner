extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_button_mouse_entered() -> void:
	$MouseEnteredAudio.play()


func _on_resume_button_pressed() -> void:
	$MouseClickAudio.play()
	get_tree().paused = false
	hide()
