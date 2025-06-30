# Records the current range session for later use/analysis.
# Current session is a dictionary.
# Each shot is formatted as a dictionary. See template below
#
"""
{
	"User": "Player1",
	"Date": "2025-06-30"
	"SessionID": 1,
	"Shots": [
		{"Shot": 1, 
		"Club": "Dr",
		"Speed": 147.5,
		"SpinAxis": -13.2,
		"TotalSpin": 3250.0,
		"HLA": 2.3,
		"VLA": 14.3,
		"TotalDistance": 132,
		"CarryDistance": 126,
		"OfflineDistance": 5,
		"Apex": 78}, 
		
		{"Shot": 2,
		...,
		}
		]
}
"""

extends Node

var recording : bool = false
var session_data : Dictionary = {}
var username : String = "Player1"
var session_id : int = 0
var date : String = ""
var current_club : String = "Dr"
var shot_number : int = 0

signal recording_state(value: bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func toggle_recording():
	recording = not recording
	if recording:
		start_recording()
	else:
		stop_recording()
		
	emit_signal("recording_state", recording)
		
func start_recording():
	session_id += 1
	date = Time.get_date_string_from_system()
	session_data = {"User": username, "Date": date, "SessionID": session_id, "Shots": []}
	
	
func record_shot(shot_data: Dictionary):
	var data = shot_data.duplicate()
	shot_number += 1
	data["Shot"] = shot_number
	session_data["Shots"].append(data)
	
func stop_recording():
	var filename : String = username + "_" + date + "_" + str(session_id) + ".json"
	var save_file = FileAccess.open("user://"+filename, FileAccess.WRITE)
	var json_string = JSON.stringify(session_data)
	save_file.store_line(json_string)



func _on_golf_ball_rest(shot_data: Dictionary) -> void:
	if recording:
		record_shot(shot_data)
