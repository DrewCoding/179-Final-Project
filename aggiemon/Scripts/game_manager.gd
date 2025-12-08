extends Node2D

@export var over_world_audio : AudioStreamPlayer

var battle_screen : Node2D

@onready var over_world : Node2D = $OverWorld
@onready var player_hurt_box : Area2D = $OverWorld/Player/HurtBox
@onready var player : Player = $OverWorld/Player
@onready var camera : Camera2D = $OverWorld/Camera2D

func _ready() -> void:
	player_hurt_box.area_entered.connect(_start_battle)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _start_battle(body):
	call_deferred("_start_battle_handler", body)

func _start_battle_handler(body):
	if has_node("BattleSetUp"):
		return
		
	var enemy = body.get_parent()
	
	if not enemy is Enemy:
		return
	
	var load_battle_screen : PackedScene= load("res://Scenes/battle_set_up.tscn")
	battle_screen = load_battle_screen.instantiate() as Node2D
	
	#over_world.hide()
	over_world.hide()
	
	add_child(battle_screen)
	print("Body Entered")
	
	for child in get_children():
		if child is Enemy:
			child.canMove = false
	camera.enabled = false
	player.set_battle_mode(true)
	var battle_set_up : BattleSetUp = $BattleSetUp
	
	battle_set_up._init_characters(player, enemy)
	
	var battle_manager : BattleManager = battle_set_up.get_node("BattleManager")
	if battle_manager:
		battle_manager.battle_ended.connect(_end_battle)
	
	var run_button = $BattleSetUp/CommandContainer/Run
	run_button.pressed.connect(_end_battle)
	run_button.pressed.connect(_start_enemy_respawn)
	enemy.call_deferred("queue_free")
	
	over_world_audio.stream_paused = true	
	
func _end_battle():
	camera.enabled = true
	player.set_battle_mode(false)
	battle_screen.queue_free()
	over_world.show()
	over_world_audio.stream_paused = false

func _start_enemy_respawn():
	var battle_set_up : BattleSetUp = $BattleSetUp
	battle_set_up.start_enemy_respawn()
	player_info.restore_player_stats()
