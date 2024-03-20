class_name Stack
extends Node3D
## A stack of flashcards.



# PUBLIC PROPERTIES

@export_range(0.0, 1.0, 0.01, "or_greater", "suffix:m")
var spacing: float = 0.05



# PRIVATE PROPERTIES

var _cards: Array[Card] = []



# PUBLIC METHODS

## Adds a card to the top of this stack.
func push_card(new_card: Card) -> void:
	if not _cards.has(new_card):
		_cards.push_back(new_card)
		if is_instance_valid(new_card.get_parent()):
			new_card.reparent(self)
		else:
			add_child(new_card)
		new_card.position = Vector3(0.0, 0.0, (_cards.size() + 1) * spacing)

## Removes a card from the top of this stack.
func pop_card() -> Card:
	if _cards.size() > 0:
		remove_child(_cards.front())
		return _cards.pop_back()
	else:
		return null
