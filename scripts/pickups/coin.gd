extends Area3D

func _ready():
	var tween = create_tween()
	tween.set_loops()

	tween.tween_property(self, "position:y", position.y - .25, 1)
	tween.tween_property(self, "position:y", position.y, 1)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group('player'):
		body.add_money()
		queue_free()
