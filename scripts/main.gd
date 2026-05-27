extends Node3D

var chunks: Array[Node3D]
const CHUNK = preload("uid://c7oqgwj1xwqjl")
const CHUNK_LENGTH = 20
const CHUNK_COUNT = 4

func _ready() -> void:
	for i in range(CHUNK_COUNT):
		var chunk = CHUNK.instantiate()
		chunk.reload.connect(on_chunk_passed)
		chunk.position.z = -(i * CHUNK_LENGTH)
		add_child(chunk)
		chunks.append(chunk)

func update_money(money):
	$UI/MoneyLabel.text = '$ ' + str(money)

func on_chunk_passed():
	$Player.increase_speed()
	recycle_chunk()

func recycle_chunk():
	var old_chunk = chunks.pop_front()
	var last_chunk = chunks[chunks.size() - 1]
	old_chunk.position.z = last_chunk.position.z - CHUNK_LENGTH
	old_chunk.randomize_chunk()
	chunks.append(old_chunk)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("pause"):
		$UI/PauseMenu.show()
		get_tree().paused = true




func _on_player_lose_health(health) -> void:
	if health == 2:
		$UI/HealthControl/HBoxContainer/Heart3.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if health == 1:
		$UI/HealthControl/HBoxContainer/Heart2.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if health <= 0:
		$UI/HealthControl/HBoxContainer/Heart1.modulate = Color(1.0, 1.0, 1.0, 1.0)
		print('start timer')
		$DeathTimer.start()


func _on_death_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
