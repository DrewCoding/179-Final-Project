class_name BattleManager
extends Node2D

@export var attack_button : Button
@export var back1_button : Button
@export var enemy_list_container : TextureRect

var player : Player
var turn_order : Array[Character] = []
var enemy_list : Array[Character] = []
var turn_number : int = 0
var target : Enemy

func connect_button_signal(button : EnemyButton):
	button.who_got_pressed.connect(_enemy_selected)
	
func init_battle (p : Player, t : Array[Character]):
	player = p
	turn_order = t
	enemy_list = turn_order
	attack_button.pressed.connect(_show_enemy_list)
	back1_button.pressed.connect(_hide_enemy_list)
	
func _start_battle():
	for character in turn_order:
		if character is Player:
			_start_player_turn()


func _show_enemy_list():
	enemy_list_container.visible = true


func _hide_enemy_list():
	enemy_list_container.visible = false


func _start_player_turn():
	pass

func _enemy_selected(enemy_button : EnemyButton):
	target = enemy_button.enemy
	print("Selected: ", target)
