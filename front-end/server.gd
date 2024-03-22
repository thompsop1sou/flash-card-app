extends Node

var server_url: String = ""
@onready var server_key: String = OS.get_environment("FLASHCARD_SERVER_KEY")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Browser.console_log("<" + server_key + ">")

