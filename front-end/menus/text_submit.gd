@tool
class_name TextSubmit
extends PanelContainer



# PUBLIC PROPERTIES

## Emitted when the name is submitted
signal submitted(text: String)

## The text to be displayed on the label.
@export_multiline
var label_text: String:
	get:
		return label_text
	set(value):
		label_text = value
		if is_instance_valid(_label):
			_label.text = label_text

## The placeholder text to be displayed in the line edit.
@export_multiline
var placeholder_text: String:
	get:
		return placeholder_text
	set(value):
		placeholder_text = value
		if is_instance_valid(_label):
			_line_edit.placeholder_text = placeholder_text

## The text to be displayed on the button.
@export_multiline
var button_text: String:
	get:
		return button_text
	set(value):
		button_text = value
		if is_instance_valid(_button):
			_button.text = button_text



# PRIVATE PROPERTIES

# Keep references to some important nodes.
@onready var _label: Label = $MarginContainer/VBoxContainer/Label
@onready var _line_edit: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/LineEdit
@onready var _button: Button = $MarginContainer/VBoxContainer/HBoxContainer/Button



# PRIVATE METHODS

# Called when the submit button is pressed.
func _on_button_pressed() -> void:
	submitted.emit(_line_edit.text)

# Called when the submit button is pressed.
func _on_text_submitted(text: String) -> void:
	submitted.emit(text)
