class_name Player
extends CharacterBody2D

@export var animation_player : AnimationPlayer

var facing_left : bool = true
var idling : bool = false

@onready var sprite : Sprite2D = $Sprite2D

func _process(_delta: float) -> void:
	#var input_direction = Input.get_action_strength("ui_right")
	#velocity.x = input_direction * 300
	if(Input.is_action_pressed("up")):
		animation_player.play("Walk_Up")
		position.y -= 4
	elif(Input.is_action_pressed("down")):
		animation_player.play("Walk_down")
		position.y += 4
	elif(Input.is_action_pressed("right")):
		if(sprite.flip_h == true):
			sprite.flip_h = false
		facing_left = false
		idling = false
		animation_player.play("Walk_X")
		position.x += 5
	elif(Input.is_action_pressed("left")):
		if(sprite.flip_h == false):
			sprite.flip_h = true
		facing_left = true
		idling = false
		animation_player.play("Walk_X")
		position.x -= 5
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
