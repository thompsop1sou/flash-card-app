extends Node

## Reset a tween.
func reset_tween(tween: Tween) -> Tween:
	if is_instance_valid(tween) and tween.is_valid():
		tween.kill()
	return create_tween()

## Finds the first child node matching a type (or returns null).
func find_first_child(parent: Node, type: String) -> Node:
	var children: Array[Node] = parent.find_children("*", type, false, false)
	if children.size() > 0:
		return children[0]
	else:
		return null
