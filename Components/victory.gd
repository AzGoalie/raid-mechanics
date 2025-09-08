extends Control

func _ready() -> void:
	get_tree().paused = true
	await %AudioStreamPlayer.finished
	Events.reset_encounter.emit()
