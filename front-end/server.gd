extends Node



# PROPERTIES

## The URL of the server.
const SERVER_URL: String = "http://localhost:3000"



# METHODS

## Makes a request to the server to open a flashcard set called [param flashcard_set_name].
func request_open(flashcard_set_name: String,
				callback: Callable = func(_rslt, _code, _hdrs, _body): pass) -> void:
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
	http_request.request_completed.connect(callback)

## Makes a request to the server to save a flashcard set called [param flashcard_set_name].
func request_save(flashcard_set_name: String, flashcard_set_contents: String,
				callback: Callable = func(_rslt, _code, _hdrs, _body): pass) -> void:
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
	http_request.request_completed.connect(callback)
