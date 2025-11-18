class_name Player
extends Character

@export var animation_player : AnimationPlayer
@export var player_speed = 300

var facing_left : bool = true
var idling : bool = false
var in_battle : bool = false

@onready var sprite : Sprite2D = $Sprite2D

func set_battle_mode(enabled: bool):
	in_battle = enabled

func _process(_delta: float) -> void:
	if in_battle:
		return
	var input_horizontal = Input.get_action_strength("right") - Input.get_action_strength("left")
	var input_vertical = Input.get_action_strength("up") - Input.get_action_strength("down")
	
	self.velocity.x = player_speed * input_horizontal
	self.velocity.y = -player_speed * input_vertical
	self.velocity = velocity.limit_length(player_speed)

	if(Input.is_action_pressed("up")):
		animation_player.play("Walk_Up")
	elif(Input.is_action_pressed("down")):
		animation_player.play("Walk_down")
	elif(Input.is_action_pressed("right")):
		if(sprite.flip_h == true):
			sprite.flip_h = false
		facing_left = false
		idling = false
		animation_player.play("Walk_X")
	elif(Input.is_action_pressed("left")):
		if(sprite.flip_h == false):
			sprite.flip_h = true
		facing_left = true
		idling = false
		animation_player.play("Walk_X")
	else:
		if facing_left:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
		if not idling:
			animation_player.play("Idle")
			idling = true
	if Input.is_action_just_released("up"):
		animation_player.pause()
	if Input.is_action_just_released("down"):
		animation_player.pause()
		
	move_and_slide()
