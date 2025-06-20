extends Node3D

var track_points : bool = false
var trail_timer : float = 0.0
var trail_resolution : float = 0.1

var tcp_server : TCPServer = TCPServer.new()
var tcp_connection : StreamPeerTCP = null
var tcp_connected : bool = false
var tcp_data : Array = []
var tcp_string : String = ""
var shot_data : Dictionary
var apex := 0
var resp_200 := {"Code" : 200}
var resp_201 := {"Code": 201, "Message": "JaySimG Player Information"}
var resp_501 := {"Code": 501, "Message": "Failure Occured"}
@onready var ball = $Ball2  # or whatever your ball node is called

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tcp_server.listen(49152)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ball.ball_state != ball.State.REST:
		var dist = Vector2(
			ball.position.x - ball.launch_position.x,
			ball.position.z - ball.launch_position.z
			).length() * 1.09361
		$VBoxContainer/Distance.text = "Distance: " + str(int(dist)) + " yd"

	apex = max(apex, int($Ball2.position.y*1.09361))
	$VBoxContainer/Apex.text = "Apex: " + str(apex*3) + " ft"
	if Input.is_action_just_pressed("hit"):
		$BallTrail.call_deferred("clear_points")
		$Ball2.call_deferred("hit")
		track_points = true
		$BallTrail.add_point($Ball2.position)
	if Input.is_action_just_pressed("reset"):
		$Ball2.call_deferred("reset")
		$Camera3D.call_deferred("reset_camera")
		apex = 0
		track_points = false
		$BallTrail.clear_points()
		
	if track_points:
		trail_timer += delta
		if trail_timer >= trail_resolution:
			$BallTrail.add_point($Ball2.position)
			trail_timer = 0.0


func _on_ball_rest() -> void:
	track_points = false


func _on_tcp_client_hit_ball(_data: Dictionary) -> void:
	track_points = true
	$BallTrail.add_point($Ball2.position)


func _on_ball_2_rest() -> void:
	track_points = false
	pass # Replace with function body.
