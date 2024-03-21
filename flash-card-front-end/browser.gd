extends Node



# PUBLIC PROPERTIES

## Whether the game is currently running in a browser.
var is_running: bool = false

## Can be used to print logs or errors to the browser console.
var console: JavaScriptObject = null



# PRIVATE PROPERTIES

# An array of callbacks which will be called when their corresponding JS results finish.
var _callbacks: Array[Callable] = []



# PUBLIC METHODS

## A wrapper for the JS [code]alert()[/code] method.
## Will call Godot's [code]print()[/code] method if the game is not running in the browser.
func alert(text: String) -> void:
	if is_running:
		JavaScriptBridge.eval("alert(`" + text + "`)")
	else:
		print(text)

## Has the browser prompt the user to download [param text] in a file called [param filename].
## [param type] can be values such as "json" or "plain".
func download(text: String, filename: String, type: String) -> void:
	if is_running:
		JavaScriptBridge.eval("const downloader = document.createElement('a');\n" +
			"downloader.href = 'data:text/" + type + ";charset=utf-8,' + encodeURIComponent(`" + text + "`);\n" +
			"downloader.target = '_blank';\n" +
			"downloader.download = '" + filename + "';\n" +
			"downloader.click();")
	else:
		printerr("Cannot download without a browser.")

## Has the browser prompt the user to upload a file. Will attempt to get the contents of that file
## and pass it back as a parameter in [param callback].
func upload(callback: Callable) -> void:
	if is_running:
		_callbacks.append(callback)
		JavaScriptBridge.eval("const uploader = document.createElement('INPUT');\n" +
			"uploader.type = 'file';\n" +
			"uploader.click();\n" +
			"const i = results.length;\n" +
			"results.push({done: false, value: null});\n" +
			"uploader.addEventListener('change', () => {\n" +
			"	if (uploader.files.length == 0) {\n" +
			"		results[i].done = true;\n" +
			"	} else {\n" +
			"		uploader.files[0].text().then((value) => {\n" +
			"			results[i].done = true;\n" +
			"			results[i].value = value;\n" +
			"		}, (error) => {\n" +
			"			results[i].done = true;\n" +
			"		});\n" +
			"	}\n" +
			"});")
	else:
		printerr("Cannot upload without a browser.")



# PRIVATE METHODS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_running = OS.has_feature('web')
	if is_running:
		console = JavaScriptBridge.get_interface("console")
		JavaScriptBridge.eval("var results = []", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_running:
		# Check all of the results
		var num_results = _callbacks.size()
		var indices_to_delete: Array[int] = []
		for i in range(num_results):
			# Handle results that are done
			if JavaScriptBridge.eval("results[" + str(i) + "].done"):
				indices_to_delete.append(i)
				var result_value = JavaScriptBridge.eval("results[" + str(i) + "].value")
				_callbacks[i].call_deferred(result_value)
		# Delete any results that were done
		for i in indices_to_delete:
			JavaScriptBridge.eval("results.splice(" + str(i) + ", 1)")
			_callbacks.remove_at(i)
