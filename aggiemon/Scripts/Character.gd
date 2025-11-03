class_name Player
extends CharacterBody2D

@export var animation_player : AnimationPlayer

var facing_left : bool = true
var idling : bool = false
@onready var sprite : Sprite2D = $Sprite2D

func _process(_delta: float) -> void:
	# Add the gravity.
	if(Input.is_action_pressed("ui_up")):
		position.y -= 5
		animation_player.play("Walk_Up")
		idling = false
	elif(Input.is_action_pressed("ui_down")):
		position.y += 5 
		animation_player.play("Walk_down")
		idling = false
	elif(Input.is_action_pressed("ui_right")):
		if(sprite.flip_h == true):
			sprite.flip_h = false
		facing_left = false
		idling = false
		animation_player.play("Walk_X")
		position.x += 5 
	elif(Input.is_action_pressed("ui_left")):
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
	move_and_slide()
