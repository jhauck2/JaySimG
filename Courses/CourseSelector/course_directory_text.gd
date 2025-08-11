extends TextEdit


signal course_directory(path: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# This functions veryifies that the directory in the text box exists and 
# sends it to the course list to populate
func verify_directory() -> bool:
	emit_signal("course_directory", text)
	return true
