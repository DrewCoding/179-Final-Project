extends Node2D

var battle_screen : Node2D

@onready var over_world : Node2D = $OverWorld
@onready var player_hurt_box : Area2D = $OverWorld/Player/HurtBox
@onready var player : Player = $OverWorld/Player
@onready var camera : Camera2D = $OverWorld/Player/Camera2D

func _ready() -> void:
	player_hurt_box.area_entered.connect(_start_battle) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _start_battle(body):
	call_deferred("_do_battle", body)

func _do_battle(body):
	var enemy = body.get_parent()
	
	var load_battle_screen : PackedScene= load("res://Scenes/battle_screen.tscn")
	battle_screen = load_battle_screen.instantiate() as Node2D
	battle_screen.name = "Battle"
	
	#over_world.hide()
	over_world.hide()
	
	add_child(battle_screen)
	print("Body Entered")
	
	camera.enabled = false
	var battle_manager : BattleManager = $Battle/BattleManager
	battle_manager._init_characters(player, enemy)
	
	var run_button = $Battle/CommandContainer/Run
	run_button.pressed.connect(_end_battle)
	enemy.call_deferred("queue_free")

func _end_battle():
	camera.enabled = true
	battle_screen.queue_free()
	over_world.show()
	
