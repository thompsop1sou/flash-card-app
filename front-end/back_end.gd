extends Node



# PUBLIC PROPERTIES

## A signal indicating an open request was completed.
signal open_request_completed(open_request_result: Utilities.Result)

## A signal indicating a save request was completed.
signal save_request_completed(save_request_result: Utilities.Result)

## The URL of the back-end server.
const SERVER_URL: String = "http://localhost:3000"



# PUBLIC METHODS

## Makes a request to the back-end server to open a flashcard set called [param flashcard_set_name].
func open_request(flashcard_set_name: String) -> void:
	# Set up a new http_request
	var http_request := HTTPRequest.new()
	add_child(http_request)
	http_request.timeout = 5.0
	http_request.request_completed.connect(func(_rslt, _code, _hdrs, _body): http_request.queue_free())
	# Set up the request parameters
	var full_url: String = SERVER_URL + "/open"
	var flashcard_set_data: String = "{\"name\": \"" + flashcard_set_name + "\"}"
	# Actually make the request
	http_request.request(full_url, ["Content-Type:application/json"], HTTPClient.METHOD_POST, flashcard_set_data)
	http_request.request_completed.connect(_open_request_callback)

## Makes a request to the back-end server to save a flashcard set called [param flashcard_set_name].
func save_request(flashcard_set_name: String, flashcard_set_contents: String) -> void:
	# Set up a new http_request
	var http_request := HTTPRequest.new()
	add_child(http_request)
	http_request.timeout = 5.0
	http_request.request_completed.connect(func(_rslt, _code, _hdrs, _body): http_request.queue_free())
	# Set up the request parameters
	var full_url: String = SERVER_URL + "/save"
	var flashcard_set_data: String = "{\"name\": \"" + flashcard_set_name + "\", \"cards\": " + flashcard_set_contents + " }"
	# Actually make the request
	http_request.request(full_url, ["Content-Type:application/json"], HTTPClient.METHOD_POST, flashcard_set_data)
	http_request.request_completed.connect(_save_request_callback)



# PRIVATE METHODS

# Called after receiving a response from the back-end server when trying to open a flashcard set.
func _open_request_callback(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray):
	match response_code:
		# If the open request succeeded, indicate that to the user and pass back the retrieved data
		HTTPClient.RESPONSE_OK:
			Browser.alert("Successfully opened the flashcard set.")
			var open_request_result := Utilities.Result.new_success()
			var body_json = JSON.parse_string(body.get_string_from_utf8())
			if typeof(body_json) == TYPE_DICTIONARY and body_json.has("cards"):
				open_request_result.value = body_json["cards"]
			open_request_completed.emit(open_request_result)
		# Otherwise, if it failed in some way, indicate that to the user
		_:
			Browser.alert("There was an error trying to open the flashcard set.")
			var open_request_result := Utilities.Result.new_failure()
			open_request_completed.emit(open_request_result)

# Called after receiving a response from the back-end server when trying to save a flashcard set.
func _save_request_callback(_result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray):
	match response_code:
		# If the save request succeeded, indicate that to the user
		HTTPClient.RESPONSE_OK, HTTPClient.RESPONSE_CREATED:
			Browser.alert("Successfully saved the flashcard set.")
			var save_request_result := Utilities.Result.new_success()
			save_request_completed.emit(save_request_result)
		# Otherwise, if it failed in some way, indicate that to the user
		_:
			Browser.alert("There was an error trying to save the flashcard set.")
			var save_request_result := Utilities.Result.new_failure()
			save_request_completed.emit(save_request_result)
