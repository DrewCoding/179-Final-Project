class_name EnemySpawner
extends Node2D

@export var enemy_scene : PackedScene

var enemy : Enemy

func _ready() -> void:
	enemy = enemy_scene.instantiate() as Enemy
	print(self.global_position)
	add_child(enemy)
	enemy.global_position = self.global_position
	
func spawn_enemy():
	await get_tree().create_timer(10).timeout
	enemy = enemy_scene.instantiate() as Enemy
	add_child(enemy)
	enemy.global_position = self.global_position
