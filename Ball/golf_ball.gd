extends Node3D


var track_points : bool = false
var trail_timer : float = 0.0
var trail_resolution : float = 0.1
var apex : int = 0
var carry: int = 0

signal good_data
signal bad_data
signal rest

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("hit"):
		$BallTrail.call_deferred("clear_points")
		$Ball.call_deferred("hit")
		track_points = true
		$BallTrail.add_point($Ball.position)
	if Input.is_action_just_pressed("reset"):
		$Ball.call_deferred("reset")
		apex = 0
		carry = 0
		track_points = false
		$BallTrail.clear_points()
		
	if track_points:
		apex = max(apex, int($Ball.position.y*1.09361))
		if $Ball.state == Enums.BallState.FLIGHT:
			carry = int(Vector2($Ball.position.x, $Ball.position.z).length()*1.09361)
		trail_timer += delta
		if trail_timer >= trail_resolution:
			$BallTrail.add_point($Ball.position)
			trail_timer = 0.0

func get_distance() -> int:
	return int(Vector2($Ball.position.x, $Ball.position.z).length()*1.09361)
	
func get_offline() -> int:
	return int($Ball.position.z)

func validate_data(data: Dictionary) -> bool:
	# TODO: implement data validation
	if data:
		return true
	else:
		return false


func reset_ball():
	$Ball.call_deferred("reset")
	$BallTrail.clear_points()
	apex = 0
	carry = 0
	

func _on_ball_rest() -> void:
	track_points = false
	emit_signal("rest")


func get_ball_state():
	return $Ball.state


func _on_tcp_client_hit_ball(data: Dictionary) -> void:
	var success : bool = validate_data(data)
	if success:
		emit_signal("good_data")
	else:
		emit_signal("bad_data")
		return
	
	track_points = true
	apex = 0
	$BallTrail.call_deferred("clear_points")
	$BallTrail.call_deferred("add_point", $Ball.position)
	$Ball.call_deferred("hit_from_data", data)
