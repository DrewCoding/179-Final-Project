class_name BattleManager
extends Node2D

#middle 559x 256y
var pos := Vector2i(259, 256)

var player : Player
var enemy : Enemy
var num : int
var enemy_creator : EnemyCreator = load("res://Scripts/enemy_creator.gd").new()
var turn_order : Array[Character] = []
	
func _init_characters(player_character : Player, collided_enemey : Enemy):
	
	player = player_character
	enemy = collided_enemey
	num = (randi_range(0, 2))
	_create_extra_enemies(num)

func _create_extra_enemies(number : int):
	
	var initial_enemy : Enemy = enemy_creator.enemy_builder_default()
	turn_order.push_back(initial_enemy)
	
	for i in range(number):
		var created_enemy : Enemy = enemy_creator.enemy_builder()
		turn_order.push_back(created_enemy)
	_place_enemies()

func _place_enemies():
	for enemies in turn_order:
		add_child(enemies)
		enemies.unhide_healthbar()
		enemies.z_index = 1
		enemies.scale = Vector2(2,2)
		enemies.global_position = pos
		enemies.z_index = 1
		pos.x += 300
		
		

	
