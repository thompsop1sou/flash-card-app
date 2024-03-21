extends Node

var running: bool = false

var console: JavaScriptObject = null
var document: JavaScriptObject = null
var callbacks: Array[Callable] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	running = OS.has_feature('web')
	if running:
		console = JavaScriptBridge.get_interface("console")
		document = JavaScriptBridge.get_interface("document")
		JavaScriptBridge.eval("var results = []", true)

func _process(delta: float) -> void:
	if running:
		# Check all of the results
		var num_results = callbacks.size()
		var indices_to_delete: Array[int] = []
		for i in range(num_results):
			# Handle results that are done
			if JavaScriptBridge.eval("results[" + str(i) + "].done"):
				indices_to_delete.append(i)
				var result_value = JavaScriptBridge.eval("results[" + str(i) + "].value")
				callbacks[i].call_deferred(result_value)
		# Delete any results that were done
		for i in indices_to_delete:
			JavaScriptBridge.eval("results.splice(" + str(i) + ", 1)")
			callbacks.remove_at(i)

func download(text: String, filename: String, type: String) -> void:
	if running:
		JavaScriptBridge.eval("const downloader = document.createElement('a');\n" +
			"downloader.href = 'data:text/" + type + ";charset=utf-8,' + encodeURIComponent(`" + text + "`);\n" +
			"downloader.target = '_blank';\n" +
			"downloader.download = '" + filename + "';\n" +
			"downloader.click();")

func upload(callback: Callable) -> void:
	if running:
		callbacks.append(callback)
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
