extends PanelContainer

var is_open: bool = false
@export var default_button: Button

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		if is_open:
			close_menu()
		else:
			open_menu()

func open_menu() -> void:
	visible = true
	is_open = true
	get_tree().paused = true
	default_button.grab_focus()

func close_menu() -> void:
	visible = false
	is_open = false
	get_tree().paused = false
