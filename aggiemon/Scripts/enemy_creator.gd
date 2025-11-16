class_name EnemyCreator

var enemy_template : PackedScene = load("res://Scenes/enemy.tscn")
var created_enemy : Enemy


func enemy_builder_default():
	var enemy = enemy_template.instantiate() as Enemy
	enemy.enemy_name = "Red"
	enemy.name = enemy.enemy_name
	enemy.create_stats()
	return enemy
	
func enemy_builder():
	var num = randi_range(0, 1)
	match num:
		0 : created_enemy = _enemy_type_1()
		1 : created_enemy = _enemy_type_2()

	return created_enemy
	
func _enemy_type_1():
	var enemy = enemy_template.instantiate() as Enemy
	enemy.change_color(Color("4400ff"))
	enemy.enemy_name = "Blue"
	enemy.name = enemy.enemy_name
	enemy.create_stats()
	return enemy

func _enemy_type_2():
	var enemy = enemy_template.instantiate() as Enemy
	enemy.change_color(Color("660066"))
	enemy.enemy_name = "Purple"
	enemy.name = enemy.enemy_name
	enemy.create_stats()
	return enemy
