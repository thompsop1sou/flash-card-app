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
		var num_results = JavaScriptBridge.eval("results.length")
		var to_delete: Array[int] = []
		for i in range(num_results):
			# Handle results that are done
			if JavaScriptBridge.eval("results[" + str(i) + "].done"):
				console.log("will delete " + str(i))
				var result_value = JavaScriptBridge.eval("results[" + str(i) + "].value")
				callbacks[i].call(result_value)
		# Delete any results that were done
		for i in to_delete:
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
		JavaScriptBridge.eval("const uploader = document.createElement('INPUT');
			uploader.type = 'file';
			uploader.click();
			console.log('results: ', results);
			const i = results.length;
			results.push({done: false, value: null});
			uploader.addEventListener('change', () => {
				if (uploader.files.length == 0) {
					results[i].done = true;
				} else {
					uploader.files[0].text().then((value) => {
						results[i].done = true;
						results[i].value = value;
					}, (error) => {
						results[i].done = true;
					});
				}
			});")

# TODO: For testing... this should actually swap the card set on the table
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("upload") and running:
		upload(temp)

# TODO: For testing... this should actually swap the card set on the table
func temp(results: String) -> void:
	console.log(results)
