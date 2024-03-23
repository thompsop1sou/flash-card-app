extends Control



# PRIVATE PROPERTIES

# Keep references to the two sub-menus.
@onready var _open_text_submit: TextSubmit = $CenterContainer/OpenTextSubmit
@onready var _save_text_submit: TextSubmit = $CenterContainer/SaveTextSubmit



# PUBLIC METHODS

## Will open a popup to get the name of a flashcard set to open.
func get_open_name() -> String:
	# Make everything visible
	visible = true
	_open_text_submit.visible = true
	# Get the name to open
	var open_name = await _open_text_submit.submitted
	# Make everything invisible
	_open_text_submit.visible = false
	visible = false
	# Return the name the user entered
	return open_name

## Will open a popup for saving a flashcard set.
func get_save_name() -> String:
	# Make everything visible
	visible = true
	_save_text_submit.visible = true
	# Get the name to save as
	var save_name = await _save_text_submit.submitted
	# Make everything invisible
	_save_text_submit.visible = false
	visible = false
	# Return the name the user entered
	return save_name
