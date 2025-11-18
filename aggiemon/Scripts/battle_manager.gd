class_name BattleManager
extends Node2D

@export var command_container : VBoxContainer
@export var attack_button : Button
@export var back1_button : Button
@export var back2_button : Button
@export var enemy_list_container : TextureRect
@export var skill_list_container : TextureRect

var player : Player
var turn_order : Array[Character] = []
var enemy_list : Array[Character] = []
var turn_number : int = 0
var target : Enemy
var active_skill : Skill

var current_turn_index : int = 0
var awaiting_target : bool = false

signal battle_ended()

func connect_button_signal(button : EnemyButton):
	button.who_got_pressed.connect(_enemy_selected)


func connect_skill_signal(button : SkillButton):
	button.what_skill_pressed.connect(_skill_selected)
	
	
func init_battle (p : Player, t : Array[Character]):
	player = p
	turn_order = t
	enemy_list = turn_order
	turn_order.push_front(player)
	attack_button.pressed.connect(_show_skill_list)
	back1_button.pressed.connect(_hide_skill_list)
	back2_button.pressed.connect(_hide_enemy_list)
	
	var output : String = ""
	print("\n-----------------Turn Order-------------------")
	for characters in turn_order:
		output += characters.name + " -> "
	print(output)
	print("----------------------------------------------\n")
	
	_start_combat()

func _start_combat():
	turn_order.sort_custom(func(a, b): 
		if a is Player:
			return true
		if b is Player:
			return false
		return a.speed > b.speed
	)
	current_turn_index = -1
	_next_turn()

func _skill_selected(skill : Skill):
	active_skill = skill
	_hide_skill_list()
	_show_enemy_list()

func _enemy_selected(enemy_button : EnemyButton):
	target = enemy_button.enemy
	print("Selected: ", target.enemy_name)
	
	if active_skill:
		AttackSystem.execute_attack_with_skill(player, target, active_skill)
		print("did ", active_skill.damage, " damage to:", target.enemy_name, 
				" with skill:", active_skill.skill_name)
	
	print("\nEnding player turn...")
	enemy_list_container.visible = false
	command_container.visible = false
	active_skill = null
	awaiting_target = false
	
	await get_tree().create_timer(1.0).timeout
	_next_turn()


func _next_turn():
	turn_order = turn_order.filter(func(c): return is_instance_valid(c) and c.is_alive())
	
	if _check_battle_end():
		return
	
	current_turn_index = (current_turn_index + 1) % turn_order.size()
	
	var current_character = turn_order[current_turn_index]
	print("Current turn: " + current_character.name)
	
	awaiting_target = false
	
	if current_character is Player:
		_start_player_turn()
	elif current_character is Enemy:
		_start_enemy_turn(current_character)

func _check_battle_end() -> bool:
	var player_alive = false
	var enemies_alive = false
	
	for character in turn_order:
		if not is_instance_valid(character):
			continue
		if character is Player:
			player_alive = true
		elif character is Enemy:
			enemies_alive = true
	
	if not player_alive:
		_on_battle_lost()
		return true
	
	if not enemies_alive:
		_on_battle_won()
		return true
	
	return false

func _show_enemy_list():
	enemy_list_container.visible = true


func _hide_enemy_list():
	_show_skill_list()
	enemy_list_container.visible = false


func _show_skill_list():
	skill_list_container.visible = true
	command_container.visible = false
	

func _hide_skill_list():
	skill_list_container.visible = false
	command_container.visible = true
	

func _start_player_turn():
	print("Starting Player's turn.....\n")
	command_container.visible = true
	awaiting_target = true

func _start_enemy_turn(current_enemy : Enemy):
	print("Enemy turn: " + current_enemy.name)
	command_container.visible = false
	
	await get_tree().create_timer(1.0).timeout
	
	var target_character = current_enemy.choose_attack()
	if target_character:
		AttackSystem.execute_attack(current_enemy, target_character, false)
	
	await get_tree().create_timer(1.0).timeout
	_next_turn()

func _on_battle_won():
	print("You won!!")
	await get_tree().create_timer(1.5).timeout
	battle_ended.emit()

func _on_battle_lost():
	print("Defeat!")
	await get_tree().create_timer(1.5).timeout
	battle_ended.emit()
