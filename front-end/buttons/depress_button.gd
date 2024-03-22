extends Button3D



# PRIVATE PROPERTIES

# Keep a reference to the child MeshInstance3D node.
var _mesh: MeshInstance3D



# PRIVATE METHODS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Make sure everything is set up for Button3D
	super()
	# Find the mesh
	_mesh = Utilities.find_first_child(self, "MeshInstance3D") as MeshInstance3D
	if not is_instance_valid(_mesh):
		Browser.console_log(str(self) + " cannot find a mesh")
	# Connect up signals
	down.connect(_on_down)
	up.connect(_on_up)

# Called when the button is pressed down.
func _on_down() -> void:
	_mesh.scale.z *= 0.25

# Called when the button is released.
func _on_up() -> void:
	_mesh.scale.z *= 4.0
