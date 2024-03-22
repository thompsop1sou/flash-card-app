extends Control



# PRIVATE PROPERTIES

# Keep references to the two sub-menus
@onready var _open_text_submit: TextSubmit = $CenterContainer/OpenTextSubmit
@onready var _save_text_submit: TextSubmit = $CenterContainer/SaveTextSubmit



# PUBLIC METHODS

## Will open a popup for opening a flashcard set.
func open() -> void:
	visible = true
	_open_text_submit.visible = true
	var flashcard_set_name = await _open_text_submit.submitted
	print(flashcard_set_name)
	_open_text_submit.visible = false
	visible = false

## Will open a popup for saving a flashcard set.
func save() -> void:
	visible = true
	_save_text_submit.visible = true
	var flashcard_set_name = await _save_text_submit.submitted
	print(flashcard_set_name)
	_save_text_submit.visible = false
	visible = false
