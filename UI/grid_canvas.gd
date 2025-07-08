extends Control

var show_grid := false
const CELL_SIZE = Vector2(120, 93)
const GRID_SPACING = Vector2(10, 10)
const GRID_SIZE = CELL_SIZE + GRID_SPACING
const GRID_ORIGIN := Vector2(15, 15	)
		
func _draw():
	if not show_grid:
		return

	var container = get_node("../VBoxContainer")
	var padding_correction := Vector2(0, 20)  # Adjust Y as needed
	var offset = container.global_position - global_position + padding_correction
	var size = get_viewport_rect().size
	var origin = Vector2(0, 0)  # if we need to offset the grid (x+10 for the top)
	for x in range(0, size.x, GRID_SIZE.x):
		var grid_x = x + offset.x + origin.x
		draw_line(Vector2(grid_x, 0), Vector2(grid_x, size.y), Color.GRAY)
	for y in range(0, size.y, GRID_SIZE.y):
		var grid_y = y + offset.y + origin.y
		draw_line(Vector2(0, grid_y), Vector2(size.x, grid_y), Color.GRAY)

func _ready():
	# Force GridCanvas to stretch to fill its parent (RangeUI)
	anchor_left = 0.0
	anchor_top = 0.0
	anchor_right = 1.0
	anchor_bottom = 1.0

	offset_left = 0.0
	offset_top = 0.0
	offset_right = 0.0
	offset_bottom = 0.0

func snap_to_grid(panel: Control):
	var global_snap_x = round((panel.global_position.x - GRID_ORIGIN.x) / GRID_SIZE.x) * GRID_SIZE.x + GRID_ORIGIN.x
	var global_snap_y = round((panel.global_position.y - GRID_ORIGIN.y) / GRID_SIZE.y) * GRID_SIZE.y + GRID_ORIGIN.y
	panel.global_position = Vector2(global_snap_x, global_snap_y)

var _edit_mode := true

func toggle_edit_mode():
	_edit_mode = !_edit_mode
	for panel in $VBoxContainer.get_children():
		panel.set_editable(_edit_mode)

func save_layout():
	var config = ConfigFile.new()
	var container = get_node("../VBoxContainer")  # Adjust path as needed
	for panel in container.get_children():
		config.set_value("positions", panel.name, panel.position)
	config.save("user://layout.cfg")

func load_layout():
	var config = ConfigFile.new()
	if config.load("user://layout.cfg") == OK:
		var container = get_node("../VBoxContainer")  # Adjust path as needed
		for panel in container.get_children():
			if config.has_section_key("positions", panel.name):  # <-- not "layout"
				panel.position = config.get_value("positions", panel.name)
				
func _on_panel_drag_started():
	show_grid = true
	queue_redraw()

func _on_panel_drag_ended():
	show_grid = false
	queue_redraw()
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_layout()
		get_tree().quit()  # Actually close the game after saving
