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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tcp_server.listen(49152)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# TCP Server
	if not tcp_connected:
		tcp_connection = tcp_server.take_connection()
		if tcp_connection:
			print("We have a tcp connection at " + tcp_connection.get_connected_host())
			tcp_connected = true
	else: # read from the connection
		tcp_connection.poll()
		var tcp_status : StreamPeerTCP.Status = tcp_connection.get_status()
		if tcp_status == StreamPeerTCP.STATUS_NONE: #disconnected
			tcp_connected = false
			print("tcp disconnected")
		elif tcp_status == StreamPeerTCP.STATUS_CONNECTED:
			var bytes_avail := 0
			tcp_data = []
			bytes_avail = tcp_connection.get_available_bytes()
			if bytes_avail > 0:
				tcp_data = tcp_connection.get_data(bytes_avail)
			if tcp_data:
				tcp_string = ""
				for byte in tcp_data[1]:
					tcp_string += char(byte)
				
				var json := JSON.new()
				var error := json.parse(tcp_string)
				if error == OK:
					shot_data = json.data
					if shot_data["ShotDataOptions"]["ContainsBallData"]:
						$BallTrail.call_deferred("clear_points")
						$Ball.call_deferred("hit_from_data", shot_data["BallData"])
						track_points = true
						$BallTrail.add_point($Ball.position)
				
	
	$VBoxContainer/Label.text = "Distance: " + str(int(Vector2($Ball.position.x, $Ball.position.z).length()*1.09361)) + " yd"
	apex = max(apex, int($Ball.position.y*1.09361))
	$VBoxContainer/Label2.text = "Apex: " + str(apex*3) + " ft"
	if Input.is_action_just_pressed("hit"):
		$BallTrail.call_deferred("clear_points")
		$Ball.call_deferred("hit")
		track_points = true
		$BallTrail.add_point($Ball.position)
	if Input.is_action_just_pressed("reset"):
		$Ball.call_deferred("reset")
		apex = 0
		track_points = false
		$BallTrail.clear_points()
		
	if track_points:
		trail_timer += delta
		if trail_timer >= trail_resolution:
			$BallTrail.add_point($Ball.position)
			trail_timer = 0.0


func _on_ball_rest() -> void:
	track_points = false
