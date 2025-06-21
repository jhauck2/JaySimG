extends Node3D

var track_points : bool = false
var trail_timer : float = 0.0
var trail_resolution : float = 0.1
var apex := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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


func _on_tcp_client_hit_ball(_data: Dictionary) -> void:
	track_points = true
	$BallTrail.add_point($Ball.position)
