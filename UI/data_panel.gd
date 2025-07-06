extends PanelContainer
@export var label: String = "Label"
@export var data: String = "---"
@export var units: String = "units"

const CELL_SIZE = Vector2(120, 93)
const GRID_SPACING = Vector2(10, 10)
const GRID_SIZE = CELL_SIZE + GRID_SPACING
signal drag_started
signal drag_ended

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_label(label)
	set_data(data)
	set_units(units)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func set_label(l: String):
	label = l
	$VBoxContainer/Label.text = l
	

func set_data(value: String):
	data = value
	$VBoxContainer/Data.text = value
	

func set_units(u: String):
	units = u
	$VBoxContainer/Units.text = units
	

var dragging := false
var drag_offset := Vector2.ZERO

func _gui_input(event):
	if event is InputEventMouseButton:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				emit_signal("drag_started")
				dragging = true
				drag_offset = get_global_mouse_position() - global_position
			else:
				emit_signal("drag_ended")
				dragging = false
				snap_to_grid()
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset

const GRID_ORIGIN := Vector2(15, 15	)

func snap_to_grid():
	var global_snap_x = round((global_position.x - GRID_ORIGIN.x) / GRID_SIZE.x) * GRID_SIZE.x + GRID_ORIGIN.x
	var global_snap_y = round((global_position.y - GRID_ORIGIN.y) / GRID_SIZE.y) * GRID_SIZE.y + GRID_ORIGIN.y
	global_position = Vector2(global_snap_x, global_snap_y)
