extends Node



# PUBLIC PROPERTIES

## A signal indicating an open request was successful.
signal open_request_succeeded(card_str_pairs: Array)

## A signal indicating a save request was successful.
signal save_request_succeeded()

## The URL of the server.
const SERVER_URL: String = "http://localhost:3000"



# PUBLIC METHODS

## Makes a request to the server to open a flashcard set called [param flashcard_set_name].
func open_request(flashcard_set_name: String) -> void:
	# Set up a new http_request
	var http_request := HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(func(_rslt, _code, _hdrs, _body): http_request.queue_free())
	# Set up the request parameters
	var full_url: String = SERVER_URL + "/open"
	var server_key: String = "FLASHCARD_SERVER_KEY:" + OS.get_environment("FLASHCARD_SERVER_KEY")
	var flashcard_set_data: String = "{\"name\": \"" + flashcard_set_name + "\"}"
	# Actually make the request
	http_request.request(full_url, [server_key, "Content-Type:application/json"], HTTPClient.METHOD_POST, flashcard_set_data)
	http_request.request_completed.connect(_open_request_callback)

## Makes a request to the server to save a flashcard set called [param flashcard_set_name].
func save_request(flashcard_set_name: String, flashcard_set_contents: String) -> void:
	# Set up a new http_request
	var http_request := HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(func(_rslt, _code, _hdrs, _body): http_request.queue_free())
	# Set up the request parameters
	var full_url: String = SERVER_URL + "/save"
	var server_key: String = "FLASHCARD_SERVER_KEY:" + OS.get_environment("FLASHCARD_SERVER_KEY")
	var flashcard_set_data: String = "{\"name\": \"" + flashcard_set_name + "\", \"cards\": " + flashcard_set_contents + " }"
	# Actually make the request
	http_request.request(full_url, [server_key, "Content-Type:application/json"], HTTPClient.METHOD_POST, flashcard_set_data)
	http_request.request_completed.connect(_save_request_callback)



# PRIVATE METHODS

# Called after receiving a response from the server when trying to open a flashcard set.
func _open_request_callback(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray):
	# Indicate if the user is unauthorized
	if response_code == HTTPClient.RESPONSE_UNAUTHORIZED:
		Browser.alert("Not authorized to access the server.")
		return
	# Parse the body
	var body_string: String = body.get_string_from_utf8()
	var body_json = JSON.parse_string(body_string)
	# If the body was successfuly parsed...
	if typeof(body_json) == TYPE_DICTIONARY and body_json.has("name"):
		# If received 200 OK, indicate success to the user and emit signal with data
		if response_code == HTTPClient.RESPONSE_OK and body_json.has("cards"):
			Browser.alert("Successfully opened the flashcard set \"" + str(body_json["name"]) + "\".")
			open_request_succeeded.emit(body_json["cards"])
		# Otherwise, indicate an error to the user
		else:
			Browser.alert("Error while trying to open the flashcard set \"" + str(body_json["name"]) + "\".")
	# If the body was not parsed, indicate an error to the user
	else:
		Browser.alert("Error while trying to open the flashcard set.")

# Called after receiving a response from the server when trying to save a flashcard set.
func _save_request_callback(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray):
	# Indicate if the user is unauthorized
	if response_code == HTTPClient.RESPONSE_UNAUTHORIZED:
		Browser.alert("Not authorized to access the server.")
		return
	# Parse the body
	var body_string: String = body.get_string_from_utf8()
	var body_json = JSON.parse_string(body_string)
	# If the body was successfuly parsed...
	if typeof(body_json) == TYPE_DICTIONARY and body_json.has("name"):
		# If received 200 OK, indicate success to the user and emit signal
		if response_code == HTTPClient.RESPONSE_OK:
			Browser.alert("Successfully saved the flashcard set \"" + str(body_json["name"]) + "\".")
			save_request_succeeded.emit()
		# Otherwise, indicate an error to the user
		else:
			Browser.alert("Error while trying to save the flashcard set \"" + str(body_json["name"]) + "\".")
	# If the body was not parsed, indicate an error to the user
	else:
		Browser.alert("Error while trying to save the flashcard set.")
