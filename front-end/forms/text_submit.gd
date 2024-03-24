@tool
class_name TextSubmit
extends PanelContainer



# PUBLIC PROPERTIES

## Emitted when the name is submitted
signal completed(result: Utilities.Result)

## The text to be displayed on the label.
@export_multiline
var label_text: String = "":
	get:
		return label_text
	set(value):
		label_text = value
		if is_instance_valid(_label):
			_label.text = label_text

## The placeholder text to be displayed in the line edit.
@export_multiline
var placeholder_text: String = "":
	get:
		return placeholder_text
	set(value):
		placeholder_text = value
		if is_instance_valid(_line_edit):
			_line_edit.placeholder_text = placeholder_text

## The actual text to be displayed in the line edit.
@export_multiline
var edit_text: String = "":
	get:
		return edit_text
	set(value):
		edit_text = value
		if is_instance_valid(_label):
			_line_edit.text = edit_text

## The text to be displayed on the submit button.
@export_multiline
var submit_text: String = "":
	get:
		return submit_text
	set(value):
		submit_text = value
		if is_instance_valid(_submit_button):
			_submit_button.text = submit_text

## The text to be displayed on the cancel button.
@export_multiline
var cancel_text: String = "":
	get:
		return cancel_text
	set(value):
		cancel_text = value
		if is_instance_valid(_cancel_button):
			_cancel_button.text = cancel_text



# PRIVATE PROPERTIES

# Keep references to some important nodes.
@onready var _label: Label = $MarginContainer/VBoxContainer/Label
@onready var _line_edit: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/LineEdit
@onready var _submit_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/SubmitButton
@onready var _cancel_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/CancelButton



# PRIVATE METHODS

# Called when the submit button is pressed.
func _on_submit_button_pressed() -> void:
	var result := Utilities.Result.new_success(_line_edit.text)
	completed.emit(result)

# Called when the submit button is pressed.
func _on_text_submitted(text: String) -> void:
	var result := Utilities.Result.new_success(text)
	completed.emit(result)

# Called when the cancel button is pressed.
func _on_cancel_button_pressed() -> void:
	var result := Utilities.Result.new_failure("")
	completed.emit(result)
