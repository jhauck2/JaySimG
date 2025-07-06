extends Control

var show_grid := false
const CELL_SIZE = Vector2(120, 93)
const GRID_SPACING = Vector2(10, 10)
const GRID_SIZE = CELL_SIZE + GRID_SPACING

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
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	# Force GridCanvas to stretch to fill its parent (RangeUI)
	anchor_left = 0.0
	anchor_top = 0.0
	anchor_right = 1.0
	anchor_bottom = 1.0

	offset_left = 0.0
	offset_top = 0.0
	offset_right = 0.0
	offset_bottom = 0.0
	
