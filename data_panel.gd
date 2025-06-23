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
func _process(delta: float) -> void:
	pass


func set_label(label: String):
	$VBoxContainer/Label.text = label
	

func set_data(value: String):
	$VBoxContainer/Data.text = value
	

func set_units(units: String):
	$VBoxContainer/Units.text = units
