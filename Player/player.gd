class_name Player extends CharacterBody2D

const projectile = preload("res://Player/Projectile/Projectile.tscn")

@export var speed := 200.0
@export var lives := 3

func _process(_delta: float) -> void:
	var aim_direction := global_position.direction_to(get_global_mouse_position())
	if aim_direction.length() > 0.1:
		rotation = aim_direction.angle()
	
	if Input.is_action_just_pressed("shoot"):
		var p = projectile.instantiate()
		p.position = position + (transform.x * 50)
		p.rotation = rotation
		get_tree().current_scene.add_child(p)
		%AudioStreamPlayer.play()

func _physics_process(_delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()

func take_damage(damage: int) -> void:
	%DamagePlayer.play()
	lives -= damage
	if lives < 0:
		lives = 0
	Events.lost_life.emit(lives)
