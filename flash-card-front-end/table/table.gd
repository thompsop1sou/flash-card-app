class_name Table
extends Node3D
## A table for displaying flashcards. Is meant to be attached to the scene [code]table.tscn[/code].



# PUBLIC PROPERTIES



# PRIVATE PROPERTIES

var _card_scene := preload("res://card/card.tscn")

@onready var _draw_stack: Stack = $DrawStack
@onready var _discard_stack: Stack = $DiscardStack


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(5):
		var new_card: Card = _card_scene.instantiate() as Card
		_draw_stack.push_card(new_card)
		if new_card.get_orientation() == Card.Orientation.BACK:
			new_card.flip_orientation(false)
	for i in range(5):
		var new_card: Card = _card_scene.instantiate() as Card
		_discard_stack.push_card(new_card)
		if new_card.get_orientation() == Card.Orientation.FRONT:
			new_card.flip_orientation(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("rmb"):
		$Card.flip_orientation()
