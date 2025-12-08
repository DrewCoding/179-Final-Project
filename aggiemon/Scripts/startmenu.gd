extends Control

@onready var player : Player = $"../Player"
@onready var camera : Camera2D = $"../Camera2D"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.can_move = false
	

func _on_start_pressed() -> void:
	print("_on_start_pressed")
	player.can_move = true
	hide()


func _on_exit_pressed() -> void:
	print("_on_exit_pressed")
	get_tree().quit()
