class_name Enemy
extends Character

@export var health_bar : HealthBar
@export var animation_player : AnimationPlayer

var enemy_name : String = "Enemy 1"
var color : Color = Color("FF0000")
@onready var sprite : Sprite2D = $Sprite2D

func _ready() -> void:
	sprite.modulate = color
	animation_player.play("Idle")

func change_color(alt_color : Color):
	color = alt_color
	
func unhide_healthbar():
	health_bar.visible = true
	health_bar.set_up_health_bar()
