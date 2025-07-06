extends MarginContainer

var show_grid := false
#const CELL_SIZE = Vector2(120, 93)
#const GRID_SPACING = Vector2(10, 10)
#const GRID_SIZE = CELL_SIZE + GRID_SPACING

signal rec_button_pressed
signal club_selected(club: String)
signal set_session(dir: String, player_name: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	load_layout()
	for panel in $VBoxContainer.get_children():
		panel.connect("drag_started", Callable(self, "_on_panel_drag_started"))
		panel.connect("drag_ended", Callable(self, "_on_panel_drag_ended"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func set_data(data: Dictionary) -> void:
	$VBoxContainer/Distance.set_data(data["Distance"])
	$VBoxContainer/Carry.set_data(data["Carry"])
	$VBoxContainer/Offline.set_data(data["Offline"])
	$VBoxContainer/Apex.set_data(data["Apex"])
	$VBoxContainer/VLA.set_data("%3.1f" % data["VLA"])
	$VBoxContainer/HLA.set_data("%3.1f" % data["HLA"])


func _on_rec_button_pressed() -> void:
	emit_signal("rec_button_pressed")


func _on_session_recorder_recording_state(value: bool) -> void:
	if value:
		$HBoxContainer/RecButton.text = "REC: On"
		$HBoxContainer/RecButton.tooltip_text = "Stop Recording Range Session"
		$SessionPopUp.open()
	else:
		$HBoxContainer/RecButton.text = "REC: Off"
		$HBoxContainer/RecButton.tooltip_text = "Start Recording Range Session"


func _on_club_selector_club_selected(club: String) -> void:
	emit_signal("club_selected", club)


func _on_session_pop_up_dir_selected(dir: String, player_name: String) -> void:
	$HBoxContainer/PlayerName.text = player_name
	emit_signal("set_session", dir, player_name)
	pass # Replace with function body.



func _on_session_recorder_set_session(user: String, dir: String) -> void:
	$HBoxContainer/PlayerName.text = user
	$SessionPopUp.set_session_data(user, dir)
	
var _edit_mode := true

func toggle_edit_mode():
	_edit_mode = !_edit_mode
	for panel in $VBoxContainer.get_children():
		panel.set_editable(_edit_mode)

func save_layout():
	var config = ConfigFile.new()
	for panel in $VBoxContainer.get_children():
		config.set_value("positions", panel.name, panel.position)
	config.save("user://layout.cfg")

func load_layout():
	var config = ConfigFile.new()
	if config.load("user://layout.cfg") == OK:
		for panel in $VBoxContainer.get_children():
			if config.has_section_key("positions", panel.name):  # <-- not "layout"
				panel.position = config.get_value("positions", panel.name)
				

func _on_panel_drag_started():
	$GridCanvas.show_grid = true
	$GridCanvas.queue_redraw()

func _on_panel_drag_ended():
	$GridCanvas.show_grid = false
	$GridCanvas.queue_redraw()
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_layout()
		get_tree().quit()  # Actually close the game after saving
