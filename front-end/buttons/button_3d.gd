class_name Button3D
extends Area3D
## A 3D button. Needs a collision shape to work properly.



# PUBLIC PROPERTIES

## Emitted when the button starts being held down.
signal down()

## Emitted when the button stops being held down.
signal up()

## Emitted when the button is pressed.
signal pressed()

## Whether this button can be pressed.
@export
var enabled: bool = true:
	get:
		return enabled
	set(value):
		enabled = value
		if not enabled:
			_mouse_over = false
			if _down:
				_down = false
				up.emit()



# PRIVATE PROPERTIES

# Whether the mouse is currently hovering over the button.
var _mouse_over = false

# Whether the button is currently pressed down button.
var _down = false



# PUBLIC METHODS

## Returns whether the mouse is currently hovering over the button.
func is_mouse_over() -> bool:
	return _mouse_over

## Returns whether the button is currently being held down.
func is_down() -> bool:
	return _down



# PRIVATE METHODS

# Called when the mouse enters the area of this button.
func _mouse_enter():
	if enabled:
		_mouse_over = true

# Called when the mouse exits the area of this button.
func _mouse_exit():
	if enabled:
		_mouse_over = false
		if _down:
			_down = false
			up.emit()

# Handle mouse button clicks.
func _input(event: InputEvent) -> void:
	var mouse_button_event: InputEventMouseButton = event as InputEventMouseButton
	if is_instance_valid(mouse_button_event) and _mouse_over and enabled:
		if mouse_button_event.pressed:
			_down = true
			down.emit()
		else:
			if _down:
				_down = false
				up.emit()
				pressed.emit()
