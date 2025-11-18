class_name Enemy
extends Character

@export var health_bar : HealthBar
@export var animation_player : AnimationPlayer
@export var music : AudioStream

var enemy_name : String = "Enemy"
var color : Color = Color("FF0000")

@onready var sprite : Sprite2D = $Sprite2D


func _ready() -> void:
	sprite.modulate = color
	animation_player.play("Idle")

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
