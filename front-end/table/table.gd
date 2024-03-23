extends Node3D



# PROPERTIES

## How long it takes for cards to move from one stack to another.
@export_range(0.0, 1.0, 0.01, "or_greater", "suffix:s")
var card_moving_duration: float = 0.25

## Whether this table is currently changing the positions of cards.
var changing: bool = false

# Preload the card scene.
var card_scene := preload("res://card/card.tscn")

# Keep a reference to the various stacks on the table.
@onready var draw_stack: Stack = $Cards/DrawStack
@onready var center_card_spot: Node3D = $Cards/CenterCardSpot
@onready var discard_stack: Stack = $Cards/DiscardStack

# Keep a reference to the menu manager
@onready var menu_manager: Control = $MenuManager



# PUBLIC METHODS

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

# Function loads up a new set of flashcards to the table.
func load_card_str_pairs(card_str_pairs) -> void:
	# Ensure the data passed in is valid
	if typeof(card_str_pairs) != TYPE_ARRAY:
		Browser.alert("Error loading flashcard set: Data is not an array.")
		return
	for card_str_pair in card_str_pairs:
		if typeof(card_str_pair) != TYPE_DICTIONARY or not card_str_pair.has("front") or not card_str_pair.has("back"):
			Browser.alert("Error loading flashcard set: Bad data at index " + str(card_str_pairs.find(card_str_pair)) + ".")
			return
	# Clear the current stacks
	draw_stack.clear()
	for child in draw_stack.get_children():
		child.queue_free()
	discard_stack.clear()
	for child in discard_stack.get_children():
		child.queue_free()
	for child in center_card_spot.get_children():
		child.queue_free()
	# Add the cards that were passed in
	card_str_pairs.reverse()
	for card_str_pair: Dictionary in card_str_pairs:
		var new_card: Card = card_scene.instantiate() as Card
		new_card.front_text = card_str_pair["front"]
		new_card.back_text = card_str_pair["back"]
		draw_stack.push_card(new_card)
		draw_stack.add_child(new_card)
		new_card.position = draw_stack.get_top_position()
		if new_card.get_orientation() == Card.Orientation.BACK:
			new_card.flip_orientation(false)

# Function saves the current set of flashcards as an array of dictionaries.
func save_card_str_pairs() -> Array[Dictionary]:
	var card_str_pairs: Array[Dictionary] = []
	# Add cards from the discard stack
	for card: Card in discard_stack.get_cards():
		card_str_pairs.append({"front": card.front_text, "back": card.back_text})
	# Add the center card (if there is one)
	var center_card = Utilities.find_first_child(center_card_spot, "Card")
	if is_instance_valid(center_card):
		card_str_pairs.append({"front": center_card.front_text, "back": center_card.back_text})
	# Add cards from the draw stack
	var draw_cards: Array[Card] = draw_stack.get_cards()
	draw_cards.reverse()
	for card: Card in draw_cards:
		card_str_pairs.append({"front": card.front_text, "back": card.back_text})
	# Return everything that was accumulated
	return card_str_pairs



# PRIVATE METHODS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Add some demo cards to the draw stack
	var card_str_pairs: Array[Dictionary] = []
	for i in range(10):
		card_str_pairs.append({"front": "front " + str(i), "back": "back " + str(i)})
	load_card_str_pairs(card_str_pairs)

# Disables all buttons.
func _disable_buttons() -> void:
	for button: Button3D in $Buttons.get_children():
		button.enabled = false

# Enables all buttons.
func _enable_buttons() -> void:
	for button: Button3D in $Buttons.get_children():
		button.enabled = true

# Called when the open button is pressed.
func _on_open_pressed() -> void:
	# Popup to get user-entered name
	_disable_buttons()
	var open_name_result: Utilities.Result = await menu_manager.get_open_name()
	_enable_buttons()
	# If a name was submitted, make a request to the server
	if open_name_result.succeeded:
		Server.open_request(open_name_result.value)
		var open_request_result: Utilities.Result = await Server.open_request_completed
		# If the request succeeded, load up the cards
		if open_request_result.succeeded:
			load_card_str_pairs(open_request_result.value)

# Called when the save button is pressed.
func _on_save_pressed() -> void:
	# Popup to get user-entered name
	_disable_buttons()
	var save_name_result: Utilities.Result = await menu_manager.get_save_name()
	_enable_buttons()
	# If a name was submitted, make a request to the server
	if save_name_result.succeeded:
		Server.save_request(save_name_result.value, JSON.stringify(save_card_str_pairs()))

# Called when the left arrow is pressed.
func _on_left_arrow_pressed() -> void:
	# Only do something if not already in the process of changing
	if not changing:
		changing = true
		# Try to flip the center card first
		var flipped_center = flip_center(Card.Orientation.FRONT)
		# If that doesn't work, try moving the cards
		if not flipped_center:
			var moved_from_center = move_from_center(draw_stack)
			var moved_to_center = move_to_center(discard_stack)
			# If neither of those works, indicate that nothing is changing
			if not moved_from_center and not moved_to_center:
				changing = false

# Called when the loop button is pressed.
func _on_loop_pressed() -> void:
	# Move the center card if there is one
	var center_card: Card = Utilities.find_first_child(center_card_spot, "Card") as Card
	if is_instance_valid(center_card):
		# Orient it correctly
		if center_card.get_orientation() == Card.Orientation.BACK:
			center_card.flip_orientation(false)
		# Move it to the draw stack
		draw_stack.push_card(center_card)
		center_card.reparent(draw_stack)
		center_card.position = draw_stack.get_top_position()
	# Move all of the cards from the discard stack
	var discard_card = discard_stack.pop_card()
	while is_instance_valid(discard_card):
		# Orient it correctly
		if discard_card.get_orientation() == Card.Orientation.BACK:
			discard_card.flip_orientation(false)
		# Move it to the draw stack
		draw_stack.push_card(discard_card)
		discard_card.reparent(draw_stack)
		discard_card.position = draw_stack.get_top_position()
		# Get a reference to the next discard card
		discard_card = discard_stack.pop_card()

# Called when the right arrow is pressed.
func _on_right_arrow_pressed() -> void:
	# Only do something if not already in the process of changing
	if not changing:
		changing = true
		# Try to flip the center card first
		var flipped_center = flip_center(Card.Orientation.BACK)
		# If that doesn't work, try moving the cards
		if not flipped_center:
			var moved_from_center = move_from_center(discard_stack)
			var moved_to_center = move_to_center(draw_stack)
			# If neither of those works, indicate that nothing is changing
			if not moved_from_center and not moved_to_center:
				changing = false

# Called when the download button is pressed.
func _on_download_pressed() -> void:
	var text: String = JSON.stringify(save_card_str_pairs(), "    ")
	Browser.download(text, "flashcards.json", "json")

# Called when the upload button is pressed.
func _on_upload_pressed() -> void:
	Browser.upload(_upload_callback)

# Definition of the callback function used with Browser.upload().
func _upload_callback(results: String) -> void:
	load_card_str_pairs(JSON.parse_string(results))
