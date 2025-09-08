class_name Pylon extends Sprite2D

const mote = preload("res://Encounters/Forgeweaver/Pylon/mote/mote.tscn")

@export var void_tear_spawn: Marker2D

const rotation_variance := 20
const max_spawn := 4
var spawned_motes := 0

func activate() -> void:
	spawned_motes = 0
	%SpawnTimer.start()
	%AnimationPlayer.play("flash")

func _spawn_motes() -> void:
	for angle in range(0, 360, 45):
		var m = mote.instantiate()
		get_tree().current_scene.add_child(m)
		m.global_position = global_position
		m.global_rotation = deg_to_rad(angle) + deg_to_rad(randi_range(-rotation_variance, rotation_variance))

func _on_spawn_timer_timeout() -> void:
	_spawn_motes()
	spawned_motes += 1
	
	if (spawned_motes >= max_spawn):
		%SpawnTimer.stop()
