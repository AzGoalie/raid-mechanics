class_name ShieldedAttendant extends Sprite2D

@export var move_target: Vector2
@export var speed := 150.0

var shielded := true

func _process(delta: float) -> void:
	position = position.move_toward(move_target, speed * delta)

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Pylon:
		var player = get_tree().get_first_node_in_group("player") as Player
		player.take_damage(1)
		visible = false
		%AudioStreamPlayer.play()
		await %AudioStreamPlayer.finished
		queue_free()
	elif parent is PlayerProjectile:
		if not shielded:
			queue_free()
	else:
		material = null
		shielded = false
