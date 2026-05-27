extends CharacterBody3D

@export var speed: float = 2.0

var direction = 1

func _physics_process(delta):
	velocity.x = direction * speed
	move_and_slide()

func _on_timer_timeout():
	direction *= -1

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group('player'):
		print('ouch')
