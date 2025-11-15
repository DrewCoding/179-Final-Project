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

func create_stats():
	max_hp = randi_range(1, 150)
	curr_hp = max_hp
	attack = randi_range(1, 100)
	special_attack = randi_range(1, 100)
	defence = randi_range(1, 100)
	special_defence = randi_range(1, 100)
	speed = randi_range(1, 100)
