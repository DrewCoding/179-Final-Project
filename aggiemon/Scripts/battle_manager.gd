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
	_next_turn()


func _skill_selected(skill : Skill):
	active_skill = skill
	_hide_skill_list()
	_show_enemy_list()

func _enemy_selected(enemy_button : EnemyButton):
	target = enemy_button.enemy
	print("Selected: ", target.enemy_name)
	target.curr_hp -= active_skill.damage
	
	print("did ", active_skill.damage, " damage to:", target.enemy_name, 
			" with skill:", active_skill.skill_name)
			
	target.health_bar.update_health_bar()
	
	print("\nEnding player turn...")
	enemy_list_container.visible = false
	command_container.visible = false
	

func _next_turn():
	var current_character : Character = turn_order.pop_front()
	if current_character is Enemy:
		_hide_skill_list()
		_start_enemy_turn(current_character)
	else:
		_start_player_turn()


func _show_enemy_list():
	enemy_list_container.visible = true


func _hide_enemy_list():
	_show_skill_list()
	enemy_list_container.visible = false


func _show_skill_list():
	skill_list_container.visible = true
	

func _hide_skill_list():
	skill_list_container.visible = false
	

func _start_player_turn():
	print("Starting Player's turn.....\n")

func _start_enemy_turn(current_enemy : Enemy):
	var _e = current_enemy
	pass
