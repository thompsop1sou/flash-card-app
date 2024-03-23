class_name Utilities
extends Node

## Finds the first child node matching a type (or returns null).
static func find_first_child(parent: Node, type: String) -> Node:
	var children: Array[Node] = parent.find_children("*", type, false, false)
	if children.size() > 0:
		return children[0]
	else:
		return null

## A class representing the result of a process. Often returned by signals.
class Result:
	# PROPERTIES
	## Whether the Result succeeded (or failed).
	var succeeded: bool = false
	## The actual data/value of the result.
	var value: Variant = null
	# METHODS
	## Constructs a new result indicating success.
	static func new_success(val: Variant = null) -> Result:
		var result := Result.new()
		result.succeeded = true
		result.value = val
		return result
	## Constructs a new result indicating failure.
	static func new_failure(val: Variant = null) -> Result:
		var result := Result.new()
		result.succeeded = false
		result.value = val
		return result
