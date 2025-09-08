extends Sprite2D

@export var max_health := 1000.0
@export var health := 1000.0
@export var bullet_dmg := 3

@export var speed := 200.0
var move_target: Vector2

@onready var pylons = get_tree().get_nodes_in_group("pylons")

func _ready() -> void:
	%ProgressBar.visible = false
	%Area2D.monitoring = false
	%ProgressBar.max_value = max_health
	health = max_health
	
	move_target = position
	var move_timer = Timer.new()
	add_child(move_timer)
	move_timer.wait_time = 5
	move_timer.connect("timeout", _next_move_target)
	move_timer.start()
	
func _physics_process(delta: float) -> void:
	if (move_target - position).length() >= texture.get_width():
		position = position.move_toward(move_target, delta * speed)

func _on_area_2d_area_entered(area: Area2D) -> void:
	health -= bullet_dmg
	%ProgressBar.value = health
	area.get_parent().queue_free()
	
	if health <= 0:
		health = 0
		Events.end_encounter.emit()

func enable_health_bar() -> void:
	%ProgressBar.visible = true
	%Area2D.monitoring = true
	
func _next_move_target() -> void:
	move_target = pylons.pick_random().global_position
