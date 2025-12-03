class_name BattleManager
extends Node2D

signal battle_ended()
@export var battle_set_up : BattleSetUp
@export var command_container : VBoxContainer
@export var attack_button : Button
@export var back1_button : Button
@export var back2_button : Button
@export var stat_button : Button
@export var enemy_list_container : TextureRect
@export var skill_list_container : TextureRect
@export var dialogue_box : TextureRect
@export var player_stat_box : TextureRect
@export var text : Label
@export var stat_text : Label

var player : Player
var turn_order : Array[Character] = []
var enemy_list : Array[Character] = []
var turn_number : int = 0
var target : Enemy
var active_skill : Skill

var current_turn_index : int = 0
var awaiting_target : bool = false

@onready var attack_effect : PackedScene = preload("res://Scenes/attack_effect.tscn")
@onready var playerHealth: HealthBar = $"../HealthBar"

func connect_button_signal(button : EnemyButton):
	button.who_got_pressed.connect(_enemy_selected)


func connect_skill_signal(button : SkillButton):
	button.what_skill_pressed.connect(_skill_selected)
	
	
func init_battle (p : Player, t : Array[Character]):
	player = p
	playerHealth.enemy = p
	turn_order = t
	enemy_list = turn_order.duplicate()
	turn_order.push_front(player)
	attack_button.pressed.connect(_show_skill_list)
	back1_button.pressed.connect(_hide_skill_list)
	back2_button.pressed.connect(_hide_enemy_list)
	stat_button.pressed.connect(_show_stat_sheet)
	
	var output : String = ""
	print("\n-----------------Turn Order-------------------")
	for characters in turn_order:
		output += characters.name + " -> "
	print(output)
	print("----------------------------------------------\n")
	
	_start_combat()


func _process(_delta):
	playerHealth.label.text = str(int(player.curr_hp)) + " / " + str(int(player.max_hp))


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
	command_container.visible = false

func _enemy_selected(enemy_button : EnemyButton):
	player_stat_box.visible = false
	enemy_list_container.visible = false
	var string : String
	target = enemy_button.enemy
	print("Selected: ", target.enemy_name)
	
	# Plays the universal attack effect
	var effect = attack_effect.instantiate() as AttackEffect
	effect.global_position = target.global_position
	effect.position.y -= 10
	effect.z_index = 2
	add_child(effect)
	target.shake()
	await get_tree().create_timer(1.0).timeout
	
	if active_skill:
		var damage = AttackSystem.execute_attack_with_skill(player, target, active_skill)
		print("did ", active_skill.damage, " damage to:", target.enemy_name, 
				" with skill:", active_skill.skill_name)
				
		string = ("did " + str(damage) + " damage to " + target.enemy_name 
					+ " with " + active_skill.skill_name)

	dialogue_box.visible = true
	enemy_list_container.visible = false
	command_container.visible = false
	text.text = string
	await get_tree().create_timer(3.0).timeout
	dialogue_box.visible = false
	
	# When a target dies it is removed from the turn order and as a result we also need to
	# dynamically change the buttons in EnemyListContainer/EnemyList
	if target.curr_hp <= 0:
		var count = 0
		for enmy in turn_order:
			if enmy == target:
				turn_order.remove_at(count)
			count += 1
		count = 0
		for enmy in enemy_list:
			print(enmy)
			if enmy == target:
				enemy_list.remove_at(count)
			count += 1
		battle_set_up.update_enemy_container(enemy_list)
		target.queue_free()

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
	
	current_enemy.attack_movement()
	await get_tree().create_timer(1.0).timeout
		
	var enemy_skill : Skill = current_enemy.select_a_skill()
	var damage = AttackSystem.execute_attack_with_skill(current_enemy, player, enemy_skill)
	print("%s hits %s for %d damage!" %[current_enemy.name, player.name, damage])
	
	var string : String = ("%s uses %s for %d damage!" %[current_enemy.name, enemy_skill.skill_name, damage])
	text.text = string
	dialogue_box.visible = true
	await get_tree().create_timer(1.5).timeout
	dialogue_box.visible = false
	_next_turn()


func _on_battle_won():
	print("You won!!")
	await get_tree().create_timer(1.5).timeout
	battle_ended.emit()


func _on_battle_lost():
	print("Defeat!")
	await get_tree().create_timer(1.5).timeout
	battle_ended.emit()
	
func _show_stat_sheet():
	if player_stat_box.visible == false:
		player_stat_box.visible = true
	else:
		player_stat_box.visible = false
		
	stat_text.text = player.get_stat_info()
