class_name BattleSetUp
extends Node2D

#middle 559x 256y
var pos := Vector2i(259, 256)

var player : Player
var enemy : Enemy
var num : int
var enemy_creator : EnemyCreator = load("res://Scripts/enemy_creator.gd").new()
var turn_order : Array[Character] = []

@onready var battle_manager : BattleManager = $BattleManager
@onready var enemy_list : HBoxContainer = $EnemyListContainer/EnemyList
@onready var skill_list : GridContainer = $SkillListContainer/SkillList

func _init_characters(player_character : Player, collided_enemey : Enemy):
	
	player = player_character
	enemy = collided_enemey
	num = (randi_range(1, 2))
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
		enemies.health_bar.set_up_health_bar()
		enemies.z_index = 1
		enemies.scale = Vector2(2,2)
		enemies.global_position = pos
		enemies.z_index = 1
		pos.x += 300
	_update_enemy_list()
	_update_skill_list()
	
	player.create_stats()
	battle_manager.init_battle(player, turn_order)

func _update_enemy_list():
	for enemies in turn_order:
		var button : PackedScene = load("res://Scenes/EnemyButton.tscn")
		var enemy_button = button.instantiate() as EnemyButton
		enemy_button.init_button(enemies, enemies.enemy_name)
		enemy_button.name = enemy_button.enemy_name
		enemy_button.text = enemy_button.enemy_name
		enemy_list.add_child(enemy_button)
		var enemy_number : int = 2
		if enemy_button.name != enemies.name:
			var new_name : String = enemy_button.enemy_name + " " + str(enemy_number)
			enemy_button.enemy_name = new_name
			enemy_button.name = new_name
			enemies.name = new_name
			enemy_button.text = new_name
			enemy_number += 1
			
		battle_manager.connect_button_signal(enemy_button)


func _update_skill_list():
	for move in player.move_list:
		move.set_up_button()
		skill_list.add_child(move.button)
		battle_manager.connect_skill_signal(move.button)
