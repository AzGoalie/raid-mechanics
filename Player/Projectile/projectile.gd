class_name PlayerProjectile extends Sprite2D

@export var speed := 600.0

func _physics_process(delta: float) -> void:
	var distance := speed * delta
	var motion := transform.x * distance
	position += motion

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
