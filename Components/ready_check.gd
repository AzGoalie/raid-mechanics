extends Control

var countdown_time = 5

func _ready() -> void:
	reset()

func _on_ready_button_pressed() -> void:
	get_tree().paused = false
	%PanelContainer.visible = false
	%ControlsPanel.visible = false
	%Countdown.visible = true
	
	%Countdown.text = str(countdown_time)
	%CountdownPlayer.play()
	%CountdownTimer.start()
	
	await %CountdownPlayer.finished
	Events.begin_encounter.emit()


func _on_countdown_timer_timeout() -> void:
	countdown_time -= 1
	%Countdown.text = str(countdown_time)
	
	if countdown_time > 0:
		%CountdownTimer.start()
	else:
		%Countdown.visible = false

func reset() -> void:
	get_tree().paused = true
	%PanelContainer.visible = true
	%ControlsPanel.visible = true
	%Countdown.visible = false
	%AudioStreamPlayer.play()
	countdown_time = 5
