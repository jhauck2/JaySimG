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
	$VBoxContainer/Label.text = "Distance: " + str($GolfBall.get_distance()) + " yd"
	$VBoxContainer/Label2.text = "Apex: " + str($GolfBall.apex*3) + " ft"
