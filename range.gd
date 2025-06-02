extends Node3D

var track_points : bool = false
var trail_timer : float = 0.0
var trail_resolution : float = 0.1

var tcp_server : TCPServer = TCPServer.new()
var tcp_connection : StreamPeerTCP = null
var tcp_connected : bool = false
var tcp_data : String = ""

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
		if tcp_connection.get_status() == StreamPeerTCP.STATUS_NONE: #disconnected
			tcp_connected = false
		else:
			tcp_data = tcp_connection.get_string()
			if tcp_data:
				print(tcp_data)
	
	$Label.text = "Distance: " + str(int($Ball.position.x))
	if Input.is_action_just_pressed("hit"):
		$BallTrail.call_deferred("clear_points")
		$Ball.call_deferred("hit")
		track_points = true
		$BallTrail.add_point($Ball.position)
	if Input.is_action_just_pressed("reset"):
		$Ball.call_deferred("reset")
		track_points = false
		$BallTrail.clear_points()
		
	if track_points:
		trail_timer += delta
		if trail_timer >= trail_resolution:
			$BallTrail.add_point($Ball.position)
			trail_timer = 0.0


func _on_ball_rest() -> void:
	track_points = false
