extends Node2D

var battle_screen : Node2D

@onready var over_world : Node2D = $OverWorld
@onready var player_hurt_box : Area2D = $OverWorld/Player/HurtBox

func _ready() -> void:
	player_hurt_box.area_entered.connect(_start_battle) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _start_battle(body):
	call_deferred("_do_battle", body)

func _do_battle(body):
	var enemy = body.get_parent()
	enemy.call_deferred("queue_free")
	
	var load_battle_screen : PackedScene= load("res://Scenes/battle_screen.tscn")
	battle_screen = load_battle_screen.instantiate() as Node2D
	battle_screen.name = "Battle"
	
	#over_world.hide()
	over_world.hide()
	
	add_child(battle_screen)
	print("Body Entered")
	
	var run_button = $Battle/CommandContainer/Run
	run_button.pressed.connect(_end_battle)

func _end_battle():
	battle_screen.queue_free()
	over_world.show()
	
