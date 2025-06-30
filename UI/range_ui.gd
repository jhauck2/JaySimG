extends MarginContainer

signal rec_button_pressed

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


func _on_rec_button_pressed() -> void:
	emit_signal("rec_button_pressed")


func _on_session_recorder_recording_state(value: bool) -> void:
	if value:
		$HBoxContainer/RecButton.text = "REC: On"
		$HBoxContainer/RecButton.tooltip_text = "Stop Recording Range Session"
	else:
		$HBoxContainer/RecButton.text = "REC: Off"
		$HBoxContainer/RecButton.tooltip_text = "Start Recording Range Session"
