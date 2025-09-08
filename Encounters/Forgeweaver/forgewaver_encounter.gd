extends Node2D

const void_tear = preload("res://Encounters/Forgeweaver/Void Tear/VoidTear.tscn")
const shielded_attendant = preload("res://Encounters/Forgeweaver/ShieldedAttendant/ShieldedAttendant.tscn")
const wipe_ui = preload("res://Components/Wipe.tscn")
const victory_ui = preload("res://Components/Victory.tscn")

@onready var pylons = get_tree().get_nodes_in_group("pylons") as Array[Pylon]
var active_pylons := 1

var cast_sequence:Array[Callable] = [invoke_collector, astral_harvest]
var wiped := false

func _ready() -> void:
	Events.begin_encounter.connect(encounter_start)
	Events.lost_life.connect(_check_wipe)
	Events.reset_encounter.connect(func(): get_tree().reload_current_scene())
	Events.end_encounter.connect(_end_encounter)

func encounter_start():
	%MusicPlayer.play()
	%VoiceStart.play()
	pylons.shuffle()
	%Forgeweaver.enable_health_bar()
	await %VoiceStart.finished
	await get_tree().create_timer(1).timeout
	cast()

func invoke_collector() -> void:
	Events.raid_alert.emit("Dodge the balls!")
	%InvokeCollectorPlayer.play()
	for i in range(0, active_pylons):
		pylons[i].activate()
	
	if active_pylons < 3:
		pylons.shuffle()
		active_pylons += 1
	await get_tree().create_timer(8).timeout
	cast()

func astral_harvest() -> void:
	Events.raid_alert.emit("Drop the add behind the portal!")
	%VoidTearPlayer.play()
	var pylon = pylons.pick_random() as Pylon
	var tear := void_tear.instantiate()
	tear.position = pylon.void_tear_spawn.global_position
	tear.rotation = pylon.void_tear_spawn.rotation
	get_tree().current_scene.add_child(tear)
	get_tree().create_timer(10).connect("timeout", func(): tear.queue_free())
	
	await get_tree().create_timer(5).timeout
	
	var player = get_tree().get_first_node_in_group("player")
	for pos in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP]:
		var add = shielded_attendant.instantiate()
		get_tree().current_scene.add_child(add)
		add.position = player.position + pos * 50
		add.move_target = pylon.global_position
	
	await get_tree().create_timer(5).timeout
	cast()

func cast() -> void:
	if get_tree().paused:
		return
	var c = cast_sequence.pop_front()
	cast_sequence.push_back(c)
	c.call()

func _check_wipe(lives: int) -> void:
	if lives <= 0 and not wiped:
		wiped = true
		cast_sequence = []
		var wipe = wipe_ui.instantiate()
		get_tree().current_scene.add_child(wipe)

func _end_encounter() -> void:
	cast_sequence = []
	get_tree().current_scene.add_child(victory_ui.instantiate())
