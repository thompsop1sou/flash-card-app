extends Control



# PRIVATE PROPERTIES

# Keep references to the two sub-menus.
@onready var _text_submit: TextSubmit = $CenterContainer/TextSubmit



# PUBLIC METHODS

## Will open a popup to get the name of a flashcard set to open.
func get_open_name() -> Utilities.Result:
	# Make everything visible
	visible = true
	_text_submit.visible = true
	# Set the text of the text submit form
	_text_submit.label_text = "Enter the name of a flashcard set to open:"
	_text_submit.placeholder_text = "My Flashcard Set"
	_text_submit.edit_text = ""
	_text_submit.submit_text = "Open"
	_text_submit.cancel_text = "Cancel"
	# Get the name to open
	var open_name_result: Utilities.Result = await _text_submit.completed
	# Make everything invisible
	_text_submit.visible = false
	visible = false
	# Return the name the user entered
	return open_name_result

## Will open a popup for saving a flashcard set.
func get_save_name() -> Utilities.Result:
	# Make everything visible
	visible = true
	_text_submit.visible = true
	# Set the text of the text submit form
	_text_submit.label_text = "Enter a name for saving this flashcard set:"
	_text_submit.placeholder_text = "My Flashcard Set"
	_text_submit.edit_text = ""
	_text_submit.submit_text = "Save"
	_text_submit.cancel_text = "Cancel"
	# Get the name to save as
	var save_name_result: Utilities.Result = await _text_submit.completed
	# Make everything invisible
	_text_submit.visible = false
	visible = false
	# Return the name the user entered
	return save_name_result
