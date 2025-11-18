class_name HealthBar
extends ProgressBar

@export var enemy : Enemy
@export var label : Label
# Called when the node enters the scene tree for the first time.

func set_up_health_bar():
	if enemy:
		enemy.health_changed.connect(_on_health_changed)
		_on_health_changed(enemy.curr_hp)

func _on_health_changed(_new_hp: int = 0):
	self.max_value = enemy.max_hp
	self.value = enemy.curr_hp
	
	label.text = str(int(self.value)) + " / " + str(int(self.max_value))

func update_health_bar():
	self.max_value = enemy.max_hp
	self.value = enemy.curr_hp
	
	label.text = str(int(self.value)) + " / " + str(int(self.max_value))
