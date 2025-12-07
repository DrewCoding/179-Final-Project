class_name Enemy
extends Character

@export var health_bar : HealthBar
@export var animation_player : AnimationPlayer

var enemy_name : String = "Enemy"
var color : Color = Color("FF0000")
var spawner_id : EnemySpawner
var canMove : bool = true
var isMoving : bool = true
var xp_value : int = 15

@onready var sprite : Sprite2D = $Sprite2D


func _ready() -> void:
	sprite.modulate = color
	animation_player.play("Idle")
	if self.get_parent() is EnemySpawner:
		spawner_id = self.get_parent()
	_set_skills()


func _process(_delta):
	if canMove and isMoving:
		isMoving = false
		overworld_enemy_movement()
		await get_tree().create_timer(7.0).timeout
		isMoving = true

	move_and_slide()

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

func overworld_enemy_movement():
	var x_dir = randi_range(-1, 1)
	var y_dir = randi_range(-1, 1)
	velocity.x = 100 * x_dir
	velocity.y = 100 * y_dir
	await get_tree().create_timer(3.0).timeout
	velocity = Vector2.ZERO
	
