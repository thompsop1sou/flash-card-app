extends Node3D



# PROPERTIES

@export_range(0.0, 1.0, 0.01, "or_greater", "suffix:s")
var card_moving_duration: float = 0.25

var changing: bool = false

var card_scene := preload("res://card/card.tscn")

@onready var draw_stack: Stack = $Cards/DrawStack
@onready var center_card_spot: Node3D = $Cards/CenterCardSpot
@onready var discard_stack: Stack = $Cards/DiscardStack



# METHODS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Add some demo cards to the draw stack
	for i in range(10):
		var new_card: Card = card_scene.instantiate() as Card
		new_card.front_text = "front " + str(i)
		new_card.back_text = "back " + str(i)
		draw_stack.push_card(new_card)
		draw_stack.add_child(new_card)
		new_card.position = draw_stack.get_top_position()
		if new_card.get_orientation() == Card.Orientation.BACK:
			new_card.flip_orientation(false)

# Called when the left arrow is pressed.
func _on_left_arrow_pressed() -> void:
	if not changing:
		changing = true
		if not flip_center(Card.Orientation.FRONT):
			move_from_center(draw_stack)
			move_to_center(discard_stack)

# Called when the right arrow is pressed.
func _on_right_arrow_pressed() -> void:
	if not changing:
		changing = true
		if not flip_center(Card.Orientation.BACK):
			move_from_center(discard_stack)
			move_to_center(draw_stack)

# Tries to flip the center card. Returns true if successful.
func flip_center(target_orientation: Card.Orientation) -> bool:
	var center_card: Card = Utilities.find_first_child(center_card_spot, "Card") as Card
	if is_instance_valid(center_card) and center_card.get_orientation() != target_orientation:
		center_card.flip_orientation(true, func (): changing = false)
		return true
	else:
		return false

# Tries to move the center card to [param stack]. Returns true if successful.
func move_from_center(stack: Stack) -> bool:
	var center_card: Card = Utilities.find_first_child(center_card_spot, "Card") as Card
	if is_instance_valid(center_card):
		stack.push_card(center_card)
		center_card.reparent(stack)
		var card_tween: Tween = create_tween()
		card_tween.tween_property(center_card, "position", stack.get_top_position(), card_moving_duration)
		card_tween.tween_callback(func (): changing = false)
		return true
	else:
		return false

# Tries to move the top card from [param stack] to the center. Returns true if successful.
func move_to_center(stack: Stack):
	var stack_card: Card = stack.pop_card()
	if is_instance_valid(stack_card):
		stack_card.reparent(center_card_spot)
		var card_tween: Tween = create_tween()
		card_tween.tween_property(stack_card, "position", Vector3.ZERO, card_moving_duration)
		card_tween.tween_callback(func (): changing = false)
		return true
	else:
		return false
