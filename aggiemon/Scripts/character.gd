class_name Character
extends CharacterBody2D

var movement_speed = 300
#stats
var curr_hp = 0
var max_hp = 0
var attack = 0
var special_attack = 0
var defence = 0
var special_defence = 0
var speed = 0
var move_list : Array[Skill] = []

signal health_changed(new_hp: int)
signal died()

func create_stats():
	max_hp = randi_range(1, 150)
	curr_hp = max_hp
	attack = randi_range(1, 100)
	special_attack = randi_range(1, 100)
	defence = randi_range(1, 100)
	special_defence = randi_range(1, 100)
	speed = randi_range(1, 100)

func add_skill(skill : Skill):
	move_list.push_back(skill)

func take_damage(damage: int):
	curr_hp = max(0, curr_hp - damage)
	health_changed.emit(curr_hp)
	
	if curr_hp <= 0:
		died.emit()

func is_alive() -> bool:
	return curr_hp > 0
