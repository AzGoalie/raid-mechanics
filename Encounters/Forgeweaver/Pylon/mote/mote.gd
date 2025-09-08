extends AnimatedSprite2D

@export var speed := 150.0

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_hurtbox_damage_done(_dmg) -> void:
	queue_free()
