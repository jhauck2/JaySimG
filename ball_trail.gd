extends MeshInstance3D

var points : Array = [Vector3.ZERO, Vector3.ZERO]
var color : Color = Color.RED
var material : ORMMaterial3D = ORMMaterial3D.new()
@export var ball: RigidBody3D  # Assign your ball node in the editor

func _ready():
	mesh = ImmediateMesh.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
func _process(_delta):
	if ball:
		add_point(ball.global_transform.origin)
	draw()

func setColor(a):
	color = a
	material.albedo_color = color

func draw():
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP, material)
	for point in points:
		mesh.surface_add_vertex(point)
	mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

func add_point(point: Vector3):
	#points.append(points[-1])
	if points.size() > 300:
		points.pop_front()
	points.append(point)

func clear_points():
	points = [Vector3.ZERO, Vector3.ZERO]


func _on_tcp_client_hit_ball(_data: Dictionary) -> void:
	call_deferred("clear_points")
