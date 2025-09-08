class_name Hurtbox extends Area2D

@export var damage := 1

signal damage_done

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage)
		damage_done.emit(damage)
