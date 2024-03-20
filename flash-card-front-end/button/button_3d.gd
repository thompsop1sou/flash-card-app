class_name Button3D
extends Area3D
## A 3D button. Needs a collision shape to work properly.



# PUBLIC PROPERTIES

## Emitted when the mouse presses the button.
signal down()

## Emitted when the mouse releases the button.
signal up()



# PRIVATE PROPERTIES

# Whether the mouse is currently hovering over the button.
var _mouse_over = false



# PUBLIC METHODS

## Returns whether the mouse is currently hovering over the button.
func is_mouse_over() -> bool:
	return _mouse_over



# PRIVATE METHODS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(func (): _mouse_over = true)
	mouse_exited.connect(func (): _mouse_over = false)

# Handle mouse button clicks.
func _input(event: InputEvent) -> void:
	if _mouse_over:
		if event is InputEventMouseButton:
			if event.pressed:
				down.emit()
			else:
				up.emit()
