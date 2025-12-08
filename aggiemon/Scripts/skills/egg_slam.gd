class_name EggSlam
extends Skill


func _init() -> void: 
	skill_name = "Egg Slam"
	status = false
	special_effect = true
	damage = 30

func effect(character : Character):
	var string: String = ""
	var init_defense = character.speed
	character.speed /= 1.35
	string = "That was one hell of a hit. (%s speed %d -> %d)" %[character.name, init_defense, character.defence]
	return string
