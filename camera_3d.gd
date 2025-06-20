extends Camera3D

@export var target: Node3D
@export var follow_offset := Vector3(-6, 2, 0)  # behind and slightly above
@export var follow_speed := 5.0
@onready var ball_trail = get_node("../BallTrail")
@onready var ball = get_node("../Ball2")  # Adjust path if needed
var start_transform: Transform3D
#var desired_position = target.global_transform.origin + target.global_transform.basis * follow_offset


var follow_enabled := false
var delay_timer := 0.0
@export var delay_duration := 3.0  # seconds


	
func _ready():
	call_deferred("_link_trail")
	delay_timer = 0.0
	follow_enabled = false
	start_transform = global_transform
	start_transform = target.global_transform.translated(Vector3(-6, 2, 0))

func _link_trail():
	if ball_trail and ball:
		ball_trail.ball = ball
	else:
		print("⚠️ Ball or BallTrail is null!")
		
func _process(delta):
	if not follow_enabled:
		delay_timer += delta
		if delay_timer >= delay_duration:
			follow_enabled = true
		return

	if follow_enabled and target:
		var desired_position = target.global_transform.origin + target.global_transform.basis * follow_offset
		global_transform.origin = global_transform.origin.lerp(desired_position, delta * follow_speed)
		look_at(target.global_transform.origin, Vector3.UP)

func reset_camera():
	global_transform = start_transform
	follow_enabled = false  # disable follow after reset
	
func reset_follow_timer():
	delay_timer = 0.0
	follow_enabled = false
