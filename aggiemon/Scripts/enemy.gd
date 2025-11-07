class_name Enemy
extends CharacterBody2D

@export var animation_player : AnimationPlayer

@onready var sprite : Sprite2D = $Sprite2D

func _ready() -> void:
	sprite.modulate = Color(1, 0.5, 0.5)
	animation_player.play("Idle")
