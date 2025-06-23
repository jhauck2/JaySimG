extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
