extends Control

func _ready() -> void:
	%AlertLabel.text = ""
	Events.raid_alert.connect(_set_alert)
	
func _set_alert(alert: String) -> void:
	%AlertLabel.text = alert
	%AudioStreamPlayer.play()
