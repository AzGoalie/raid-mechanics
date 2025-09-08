extends Control

func _ready() -> void:
	Events.lost_life.connect(_set_lives)
	
func _set_lives(lives: int) -> void:
	%Lives.text = str(lives)
