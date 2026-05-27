extends Node3D
signal reload

const COIN = preload("uid://2ed8bsfiqca2")
const HAY_BALE = preload("uid://0cjo1jhdi8pe")

var path_xs = [-2 + 4/3 - 1/6,
	-2 + 4/3 * 2 - 1/6,
	-2 + 4/3 * 3 - 1/6
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VisibleOnScreenNotifier3D.visible = true
	randomize_chunk()

func clear_coins():
	for child in get_children():
		if child.is_in_group("coins"):
			child.queue_free()

func clear_obstacles():
	for child in get_children():
		if child.is_in_group("obstacles"):
			child.queue_free()

func randomize_chunk():
	
	clear_coins()
	clear_obstacles()
	
	for z in range(-10, 10, 1):
		
		var rand = randf_range(0, 1)
		
		if rand < .2:
			var coin = COIN.instantiate()
			coin.position.z = -z
			coin.position.y = 1
			coin.position.x = path_xs.pick_random()
			add_child(coin)
		elif rand < .3:
			var obstacle = HAY_BALE.instantiate()
			obstacle.position.z = -z
			obstacle.position.x = path_xs.pick_random()
			add_child(obstacle)


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	reload.emit()
