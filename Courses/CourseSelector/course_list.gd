extends ItemList

var course_dir := ""

signal play_course(path: String, players: Array)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func parse_directory(path: String):
	var courses : Array[String] = []
	print("Path: " + path)
	var dir = DirAccess.open(path)
	if path[path.length()-1] == "/":
		path = path.substr(0, path.length()-1)
	course_dir = path
	
	# Get a list of all Courses by directories within "path"
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			# Open directory and check for metadata file
			if FileAccess.file_exists(path+ "/" + file_name + "/metadata.json"):
				courses.append(file_name)
				# TODO: check for .pck file
		file_name = dir.get_next()
	# Populate list with available courses
	for course in courses:
		add_item(course)


func _on_players_send_players(players: Array) -> void:
	var selected_indices = get_selected_items()
	if selected_indices:
		var selected_course = get_item_text(selected_indices[0])
		emit_signal("play_course", course_dir+"/"+selected_course, players)
