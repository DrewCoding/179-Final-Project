class_name Turkey
extends Enemy

func _ready() -> void:
	color = Color(1, 1, 1, 1)
	enemy_name = "Turkey"
	xp_value = 25
	super._ready()


func _set_skills():
	var skill : Skill = load("res://Scripts/skills/enemy skills/turkey_slap.gd").new()
	add_skill(skill)
	skill = load("res://Scripts/skills/punch.gd").new()
	add_skill(skill)


func select_a_skill():
	for move in move_list:
		print(move.skill_name)
	var size_of_move_list = move_list.size()
	if(size_of_move_list == 0):
		return null
	
	if ((player_info.defence * 0.5) < player_info.player_instance.defence):
		return move_list[0]
	else:
		var choice = randi_range(0, size_of_move_list - 1)
		return move_list[choice]


func create_stats():
	var level_scaling = (player_info.level) / 2
	xp_value += xp_value * level_scaling
	max_hp = randi_range(15, 20) + level_scaling
	curr_hp = max_hp + level_scaling
	attack = randi_range(4, 5) + level_scaling
	special_attack = randi_range(1, 100) 
	defence = randi_range(5, 10) + level_scaling
	special_defence = randi_range(1, 100)
	speed = randi_range(1, 3) + level_scaling
