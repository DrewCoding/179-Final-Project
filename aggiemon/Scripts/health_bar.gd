class_name HealthBar
extends ProgressBar

@export var enemy : Enemy
@export var label : Label
# Called when the node enters the scene tree for the first time.

func update_health_bar():
	self.max_value = enemy.max_hp
	self.value = enemy.curr_hp
	
	label.text = str(int(self.value)) + " / " + str(int(self.max_value))
