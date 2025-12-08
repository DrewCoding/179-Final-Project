extends Control

@export var character: Player

@export var shop_list: ItemList 
@export var info_label: Label

var skills: Array[Skill] = []


func _ready() -> void:
	visible = false
	_fill_skills_array()
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	
func open() -> void:
	visible = true
	character.can_move = false
	_populate_shop_list()
	info_label.text = ""
	
	
func close() -> void:
	visible = false
	character.can_move = true
	

func _fill_skills_array() -> void:
	skills.append(load("res://Scripts/skills/egg_slam.gd").new())
	skills.append(load("res://Scripts/skills/calculus.gd").new())
	skills.append(load("res://Scripts/skills/itea.gd").new())


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("menu"):
		close()
		get_viewport().set_input_as_handled()


func _populate_shop_list() -> void:
	print("skill_list export is:", shop_list)
	shop_list.clear()
	
	if skills.is_empty():
		info_label.text = "That's all I know..."
		return
	
	for skill in skills:
		shop_list.add_item(skill.skill_name)
	


func _on_shop_list_item_selected(index: int) -> void:
	if index < 0 or index >= skills.size():
		return
	
	character.add_skill(skills[index])
	skills.remove_at(index)
	_populate_shop_list()
