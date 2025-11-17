extends Node2D

@export var over_world_audio : AudioStreamPlayer

var battle_screen : Node2D

@onready var over_world : Node2D = $OverWorld
@onready var player_hurt_box : Area2D = $OverWorld/Player/HurtBox
@onready var player : Player = $OverWorld/Player
@onready var camera : Camera2D = $OverWorld/Player/Camera2D

func _ready() -> void:
	player_hurt_box.area_entered.connect(_start_battle)
	
	var load_skill : Skill = load("res://Scripts/skills/punch.gd").new()
	player.add_skill(load_skill)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _start_battle(body):
	call_deferred("_start_battle_handler", body)

func _start_battle_handler(body):
	var enemy = body.get_parent()
	
	var load_battle_screen : PackedScene= load("res://Scenes/battle_set_up.tscn")
	battle_screen = load_battle_screen.instantiate() as Node2D
	
	#over_world.hide()
	over_world.hide()
	
	add_child(battle_screen)
	print("Body Entered")
	
	camera.enabled = false
	var battle_set_up : BattleSetUp = $BattleSetUp
	battle_set_up._init_characters(player, enemy)
	
	var run_button = $BattleSetUp/CommandContainer/Run
	run_button.pressed.connect(_end_battle)
	enemy.call_deferred("queue_free")
	
	over_world_audio.stream_paused = true	
	
func _end_battle():
	camera.enabled = true
	battle_screen.queue_free()
	over_world.show()
	over_world_audio.stream_paused = false	
	
