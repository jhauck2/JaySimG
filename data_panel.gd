extends PanelContainer
@export var label: String = "Label"
@export var data: String = "---"
@export var units: String = "units"

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
