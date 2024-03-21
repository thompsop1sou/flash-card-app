@tool
class_name Card
extends Node3D
## A flashcard. Is meant to be attached to the scene [code]card.tscn[/code].



# PUBLIC PROPERTIES

## The text that will appear on the front side of the card.
@export_multiline
var front_text: String = "front":
	get:
		return front_text
	set(value):
		front_text = value
		if is_instance_valid(_front_label):
			_front_label.text = front_text

## The text that will appear on the back side of the card.
@export_multiline
var back_text: String = "back":
	get:
		return back_text
	set(value):
		back_text = value
		if is_instance_valid(_back_label):
			_back_label.text = back_text

## How long the total flipping animation should last.
@export_range(0.0, 1.0, 0.01, "or_greater", "suffix:s")
var flipping_duration: float = 0.25

## An enumeration of the different orientations that a card can be in.
enum Orientation {FRONT, TO_FRONT, BACK, TO_BACK}



# PRIVATE PROPERTIES

# The current orientation of the card.
var _orientation := Orientation.FRONT

# The rotation angles corresponding to front and back orientation
const _epsilon: float = PI / (180.0 * 60.0)  # 1/60th of a degree
var _front_angle: float = _epsilon
var _back_angle: float = PI - _epsilon

# Keep references to the front and back labels.
@onready var _front_label: Label = $FrontMesh/FrontViewport/FrontLabel
@onready var _back_label: Label = $BackMesh/BackViewport/BackLabel



# PUBLIC METHODS

## Flips the orientation of this card to the opposite of what it currently is.
## If [param animated], will use a tween to flip the card over a period of 0.5 seconds.
func flip_orientation(animated: bool = true, callback: Callable = Callable()) -> void:
	# Animate the card using a tween
	if animated:
		match _orientation:
			# Flip the card to the back if currently on the front
			Card.Orientation.FRONT:
				_animate_card_flip(_back_angle, Card.Orientation.BACK, callback)
			# Flip the card to the front if currently on the back
			Card.Orientation.BACK:
				_animate_card_flip(_front_angle, Card.Orientation.FRONT, callback)
			# Don't do anything if the card is currently changing
			_:
				pass
	# Just flip the card immediately
	else:
		match _orientation:
			# Flip the card to the back if currently on the front
			Card.Orientation.FRONT:
				rotation.y = _back_angle
				_orientation = Card.Orientation.BACK
				callback.call()
			# Flip the card to the front if currently on the back
			Card.Orientation.BACK:
				rotation.y = _front_angle
				_orientation = Card.Orientation.FRONT
				callback.call()
			# Don't do anything if the card is currently changing
			_:
				pass

## Returns the current orientation of the card.
## (Use this instead of accessing [member Card._orientation] directly.)
func get_orientation() -> Card.Orientation:
	return _orientation



# PRIVATE METHODS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Make sure the text on the labels is correct
	front_text = front_text
	back_text = back_text
	# Set it up to be rotated toward the front
	rotation.y = _front_angle
	_orientation = Card.Orientation.FRONT

# Sets up the tweens for animating the card flip.
func _animate_card_flip(rotation_y: float, orientation: Card.Orientation, callback: Callable) -> void:
	# Rotation
	var rotating_tween: Tween = create_tween()
	var target_rotation := Vector3(rotation.x, rotation_y, rotation.z)
	rotating_tween.tween_property(self, "rotation", target_rotation, flipping_duration)
	# Orientation of card and callback
	_orientation = orientation + 1
	rotating_tween.tween_callback(func (): _orientation = orientation)
	rotating_tween.tween_callback(callback)
	# Translation
	_tween_translate_up()

# Helper for _animate_card_flip() that moves the card up.
func _tween_translate_up():
	var translating_tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	var target_translation := Vector3(position.x, position.y, position.z + 1.5)
	translating_tween.tween_property(self, "position", target_translation, flipping_duration / 2.0)
	translating_tween.tween_callback(_tween_translate_down)

# Helper for _animate_card_flip() that moves the card down.
func _tween_translate_down():
	var translating_tween: Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	var target_translation := Vector3(position.x, position.y, position.z - 1.5)
	translating_tween.tween_property(self, "position", target_translation, flipping_duration / 2.0)
