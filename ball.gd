extends CharacterBody3D

var omega := Vector3.ZERO
var rolling = false
var on_ground := false
var floor_norm := Vector3(0.0, 1.0, 0.0)

var mass = 0.04592623
var radius = 0.021335
var A = PI*radius*radius # Cross-sectional area
var I = 0.4*mass*radius*radius # Moment of inertia
var u_k = 0.4 # friction coefficient with the ground
var u_kr = 0.2 # friction coefficient with the ground while rolling

var rho = 1.225 # Air density (kg/m^3)
var nu = 0.00001789 # Air Viscosity
var nu_k = 0.0000146 # Air Kinematic Viscosity
var nu_g = 0.0012 # Grass Viscosity (estimate somewhere between air and water)

enum State {REST, FLIGHT, ROLLOUT}
var state : State = State.REST

signal rest

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	on_ground = position.y < 0.022
	
	var F_g := Vector3(0.0, -9.81*mass, 0) # force of gravity
	var F_m := Vector3.ZERO # Magnus force
	var F_d := Vector3.ZERO # Drag force
	var F_f := Vector3.ZERO # Frictional force
	var F_gd := Vector3.ZERO # Drag force from grass
	
	var T_d := Vector3.ZERO # Viscous torque
	var T_f := Vector3.ZERO # Frictional torque
	var T_g := Vector3.ZERO # Grass drag torque
	
	if on_ground:
		# Force of viscous drag from grass
		F_gd = velocity*(-6*PI*radius*nu_g)
		F_gd.y = 0.0
		
		# velocity of the bottom of the ball relative to the ground with spin included
		var b_vel : Vector3 = floor_norm.cross(omega)*radius
		b_vel = b_vel + velocity
		if b_vel.length() < 0.05: # rolling without slipping
			b_vel = velocity.normalized()
			F_f = b_vel*(-u_k*mass*9.81)
		else: # ball slipping
			b_vel = b_vel.normalized()
			F_f = b_vel*(-u_k*mass*9.81)
			T_f = (floor_norm*-radius).cross(F_f)
			
		# Viscous Torque
		T_g = omega.normalized()*-6.0*PI*radius*nu_g
	else: # ball in air
		var speed := velocity.length()
		var spin := 0.0
		if speed > 0.5:
			spin = omega.length()*radius/speed
			
		var Re : float = speed*radius*2.0/nu_k
		
		# Magnus and drag coefficients
		# original
		#var S : float = 0.5*rho*PI*radius*radius*radius*(-3.25*spin+1.99)
		#first tweak
		var S : float = 0.5*rho*PI*radius*radius*radius*(-2.4*spin+1.75)
		
		
		var Cd := 0.0 # Drag coefficient
		if Re < 87500.0:
			Cd = 0.000000000129*Re*Re - 0.0000259*Re + 1.50
		else:
			Cd = 0.0000000000191*Re*Re - 0.0000054*Re + 0.56
		
		# Magnus force
		F_m = omega.cross(velocity)*S
		# Viscous Torque
		var Cdm := Cd/3.0
		#T_d = omega.normalized()*-0.5*Cdm*rho*A
		T_d = -8.0*PI*nu*radius*radius*radius*omega
		
		# Drag force
		F_d = velocity*-speed*Cd*rho*A/2.0*1.3 # *1.05 factor used to dial in distances
		
	# Total force
	var F : Vector3 = F_g + F_d + F_m + F_f + F_gd
	
	# Total torque
	var T : Vector3 = T_d + T_f + T_g 
	
	velocity = velocity + F/mass*delta
	omega = omega + T/I*delta
	
	
	# Collisions
	var collision = move_and_collide(velocity*delta)
	if collision:
		if velocity.length() > 0.5:
			velocity = bounce(velocity, collision.get_normal())
		else:
			velocity = Vector3.ZERO
			state = State.REST
			emit_signal("rest")
			


func bounce(vel, normal) -> Vector3:
	# component of velocity parallel to floor normal
	var vel_norm : Vector3 = vel.project(normal)
	var speed_norm : float = vel_norm.length()
	# component of velocity orthoganal to normal
	var vel_orth : Vector3 = vel - vel_norm
	var speed_orth : float = vel_orth.length()
	#component of angular velocity parallel to normal
	var omg_norm : Vector3 = omega.project(normal)
	# component of angular velocity orthoganal to normal
	var omg_orth : Vector3 = omega - omg_norm
	
	var speed : float = velocity.length()
	var theta_1 : float = velocity.angle_to(normal)
	var theta_c : float = 15.4 * speed * theta_1 / 18.6 / 44.4 # Eq 18 from reference
	
	# final orthoganal speed
	var v2_orth = 5.0/7.0*speed*sin(theta_1-theta_c) - 2.0*radius*omg_norm.length()/7.0
	# orthoganal restitution
	if speed_orth < 0.01:
		vel_orth = Vector3.ZERO
	else:
		vel_orth = vel_orth.limit_length(v2_orth)
		
	# final orthoganal angular velocity
	var w2h : float = v2_orth/radius
	# orthoganal angular restitution
	if omg_orth.length() < 0.1:
		omg_orth = Vector3.ZERO
	else:
		omg_orth = omg_orth.limit_length(w2h)
		
	# normal restitution
	var e : float = 0.0
	if speed_norm < 20.0:
		e = 0.12
	else:
		e = 0.510 - 0.0375*speed_norm + 0.000903*speed_norm*speed_norm
	
	vel_norm = vel_norm*-e
	
	omega = omg_norm + omg_orth
	
	return vel_norm + vel_orth
	

func hit():
	# 8 iron test shot - 100 mph, 20.8 deg launch, 1.7 deg horz launch, 7494 rpm, 2.7 degree spin axis offset
	state = State.FLIGHT
	position = Vector3.ZERO
	velocity = Vector3(44.7*cos(20.8*PI/180.0)*cos(1.7*PI/180.0), 44.7*sin(20.8*PI/180.0), 44.7*sin(1.7*PI/180.0))
	omega = Vector3(0.0, 784.0*sin(2.7*PI/180.0), 784.0*cos(2.7*PI/180.0))
	
func hit_from_data(data : Dictionary):
	position = Vector3(0.0, 0.05, 0.0)
	velocity = Vector3(data["Speed"]*0.44704, 0, 0).rotated(
					Vector3(0.0, 0.0, 1.0), data["VLA"]*PI/180.0).rotated(
						Vector3(1.0, 0.0, 0.0), data["HLA"]*PI/180.0)
	omega = Vector3(0.0, 0.0, data["TotalSpin"]*0.10472).rotated(Vector3(1.0, 0.0, 0.0), -data["SpinAxis"]*PI/180)
	
	
func reset():
	position = Vector3(0.0, 0.1, 0.0)
	velocity = Vector3.ZERO
	omega = Vector3.ZERO
	state = State.REST
