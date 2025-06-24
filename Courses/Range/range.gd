extends Node3D

var track_points : bool = false
var trail_timer : float = 0.0
var trail_resolution : float = 0.1
var apex := 0
var ball_data: Dictionary = {"Distance": "---", "Carry": "---", "Offline": "---", "Apex": "---", "VLA": 0.0, "HLA": 0.0}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	ball_data["Distance"] = str($GolfBall.get_distance())
	if $GolfBall.get_ball_state() == Enums.BallState.FLIGHT:
		ball_data["Carry"] = str($GolfBall.get_distance())
	ball_data["Apex"] = str($GolfBall.apex*3)
	var offline = $GolfBall.get_offline()
	var offline_text := "R"
	if offline < 0:
		offline_text = "L"
	offline_text += str(abs(offline))
	ball_data["Offline"] = offline_text
	
	$RangeUI.set_data(ball_data)


func _on_tcp_client_hit_ball(data: Dictionary) -> void:
	ball_data = data.duplicate()
