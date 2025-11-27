class_name Enemy
extends Character

@export var health_bar : HealthBar
@export var animation_player : AnimationPlayer

var enemy_name : String = "Enemy"
var color : Color = Color("FF0000")

@onready var sprite : Sprite2D = $Sprite2D


func _ready() -> void:
	sprite.modulate = color
	animation_player.play("Idle")
	_set_skills()


func change_color(alt_color : Color):
	color = alt_color
	
	
func unhide_healthbar():
	health_bar.visible = true
	health_bar.update_health_bar()


func choose_attack():
	var targets = get_tree().get_nodes_in_group("player")
	if targets.size() > 0:
		return targets[0]
	return null


func _set_skills():
	var skill1 : Skill = load("res://Scripts/skills/punch.gd").new()
	self.add_skill(skill1)

func shake():
	var original_pos : Vector2 = self.global_position
	var tween = create_tween()
	
	tween.tween_property(self, "position", original_pos + Vector2(20,0), 0.05)
	tween.tween_property(self, "position", original_pos, 0.05)

func attack_movement():
	var original_pos : Vector2 = self.global_position
	var tween = create_tween()
	
	tween.tween_property(self, "position", original_pos + Vector2(0,40), 0.15)
	tween.tween_property(self, "position", original_pos, 0.15)
