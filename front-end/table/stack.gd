class_name Stack
extends Node3D
## A stack of flashcards.



# PUBLIC PROPERTIES

## How far apart each card is from the one below it.
@export_range(0.0, 1.0, 0.01, "or_greater", "suffix:m")
var spacing: float = 0.05



# PRIVATE PROPERTIES

# All of the cards that are part of the stack.
var _cards: Array[Card] = []



# PUBLIC METHODS

## Returns the position of the top card in the stack.
func get_top_position() -> Vector3:
	return Vector3(0.0, 0.0, spacing * _cards.size())

## Adds a card to the top of this stack.
func push_card(new_card: Card) -> void:
	if not _cards.has(new_card):
		_cards.push_back(new_card)

## Removes a card from the top of the stack.
func pop_card() -> Card:
	return _cards.pop_back()

## Clears all cards out of the stack.
func clear() -> void:
	_cards.clear()

## Returns a duplicate of the array of cards in this stack.
func get_cards() -> Array[Card]:
	return _cards.duplicate()
