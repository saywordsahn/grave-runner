extends Node

# ------------------------
# AUDIO PLAYERS
# ------------------------

var music_player : AudioStreamPlayer
var sfx_players : Array[AudioStreamPlayer] = []

const SFX_POOL_SIZE := 12

# ------------------------
# SOUND LIBRARY
# ------------------------

var sounds := {
	#"button_hover": preload("res://audio/ui/hover.wav"),
	#"button_click": preload("res://audio/ui/click.wav"),
	#"footstep_1": preload("res://audio/footsteps/step1.wav"),
	#"footstep_2": preload("res://audio/footsteps/step2.wav"),
	#"jump": preload("res://audio/player/jump.wav"),
	#"hurt": preload("res://audio/player/hurt.wav")
}

# ------------------------
# READY
# ------------------------

func _ready():

	# Music player
	music_player = AudioStreamPlayer.new()
	add_child(music_player)

	# SFX pool
	for i in SFX_POOL_SIZE:

		var player = AudioStreamPlayer.new()

		player.bus = "SFX"

		add_child(player)

		sfx_players.append(player)

# ------------------------
# PLAY SOUND
# ------------------------

func play_sound(sound_name : String, volume_db := 0.0, pitch := 1.0):

	if !sounds.has(sound_name):
		push_warning("Sound not found: " + sound_name)
		return

	var player = _get_available_player()

	if player == null:
		return

	player.stream = sounds[sound_name]
	player.volume_db = volume_db
	player.pitch_scale = pitch

	player.play()

# ------------------------
# RANDOMIZED SOUND
# ------------------------

func play_sound_random(
	sound_name : String,
	volume_db := 0.0,
	pitch_min := 0.95,
	pitch_max := 1.05
):

	play_sound(
		sound_name,
		volume_db,
		randf_range(pitch_min, pitch_max)
	)

# ------------------------
# MUSIC
# ------------------------

func play_music(music : AudioStream, volume_db := 0.0):

	if music_player.stream == music:
		return

	music_player.stream = music
	music_player.volume_db = volume_db
	music_player.play()

func stop_music():
	music_player.stop()

# ------------------------
# PLAYER POOL
# ------------------------

func _get_available_player():

	for player in sfx_players:

		if !player.playing:
			return player

	return null
