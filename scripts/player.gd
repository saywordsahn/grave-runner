extends CharacterBody3D

signal on_lose_health(health)
signal on_money_pickup(money)

const FOOTSTEP_GRASS_001 = preload("uid://b3uj6wpmyhnvk")
const FOOTSTEP_GRASS_002 = preload("uid://dpe5vdkx7y452")
const FOOTSTEP_GRASS_003 = preload("uid://bprin6kimky43")
const FOOTSTEP_GRASS_004 = preload("uid://ob2ta7oyfbw6")

const JUMP_VELOCITY = 4.5

var forward_speed = 3.0
var horizontal_speed = 3.0

var money = 0
var health = 3
var is_alive = true

var footstep_sounds = [
	FOOTSTEP_GRASS_001,
	FOOTSTEP_GRASS_002,
	FOOTSTEP_GRASS_003,
	FOOTSTEP_GRASS_004,
]

@onready var animation_player: AnimationPlayer = $character/AnimationPlayer
@onready var footstep_audio: AudioStreamPlayer3D = $FootstepAudio
@onready var hit_particles: GPUParticles3D = $HitParticles


func _ready() -> void:
	footstep_audio.volume_db = -12
	animation_player.play("walk")


func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		animation_player.play("jump")
	else:
		animation_player.play("walk")

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and is_alive:
		velocity.y = JUMP_VELOCITY

	# Forward movement
	velocity.z = -forward_speed

	# Horizontal movement
	velocity.x = 0

	if Input.is_action_pressed("move_left") and is_alive:
		velocity.x = -horizontal_speed

	if Input.is_action_pressed("move_right") and is_alive:
		velocity.x = horizontal_speed

	move_and_slide()


func hit() -> void:
	health -= 1

	$HitAudio.play()
	on_lose_health.emit(health)

	if health <= 0:
		kill_player()
	else:
		hit_particles.restart()
		velocity.y = 4


func kill_player() -> void:
	is_alive = false

	$DieParticles.restart()
	$character.hide()

	animation_player.stop()

	forward_speed = 0
	footstep_audio.volume_db = -80


func increase_speed() -> void:
	forward_speed += 0.5


func add_money() -> void:
	money += 1

	on_money_pickup.emit(money)

	$CoinPickupAudio.play()


func play_footstep() -> void:
	if is_on_floor():
		var sound = footstep_sounds.pick_random()

		footstep_audio.stream = sound

		# Slight pitch variation helps a lot
		footstep_audio.pitch_scale = randf_range(0.92, 1.08)

		footstep_audio.play()
