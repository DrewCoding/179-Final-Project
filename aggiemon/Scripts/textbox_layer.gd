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
	
	await get_tree().create_timer(4.0).timeout 
	hide_textbox()
