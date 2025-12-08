extends CanvasLayer


@onready var textbox_container = $Textbox
@onready var label = $Textbox/Panel/MarginContainer/HBoxContainer/Label
@onready var text_sfx: AudioStreamPlayer = $TextSFX

var tween

func _ready() -> void:
	hide_textbox()

func hide_textbox():
	label.text = ""
	textbox_container.hide()
	
func show_textbox():
	textbox_container.show()
	
func add_text(text):
	label.text = text
	show_textbox()
	if text_sfx:
		if text_sfx.playing:
			text_sfx.stop()
		text_sfx.play()
	
	# Calculate display time based on text length (roughly 0.05 seconds per character, minimum 4 seconds)
	var display_time = max(4.0, text.length() * 0.05)
	await get_tree().create_timer(display_time).timeout 
	hide_textbox()
