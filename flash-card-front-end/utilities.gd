extends Node

## Finds the first child node matching a type (or returns null).
static func find_first_child(parent: Node, type: String) -> Node:
	var children: Array[Node] = parent.find_children("*", type, false, false)
	if children.size() > 0:
		return children[0]
	else:
		return null
