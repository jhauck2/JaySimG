extends RigidBody3D

var launch_velocity: Vector3 = Vector3.ZERO
var launch_spin: Vector3 = Vector3.ZERO
var launch_position: Vector3
var launched: bool = false

var omega := Vector3.ZERO
var rolling = false
var on_ground := false
var floor_norm := Vector3(0.0, 1.0, 0.0)

var ball_mass = 0.04592623
var radius = 0.021335
var A = PI*radius*radius # Cross-sectional area
var I = 0.4*mass*radius*radius # Moment of inertia
var u_k = 0.4 # friction coefficient with the ground
var u_kr = 0.2 # friction coefficient with the ground while rolling

var rho = 1.225 # Air density (kg/m^3)
var mu = 0.00001802 # Air Dynamic Viscosity
var nu = 0.00001470 # Air Kinematic Viscosity
var nu_g = 0.0012 # Grass Viscosity (estimate somewhere between air and water)

enum State {REST, FLIGHT, ROLLOUT}
var ball_state = State.REST

signal rest
signal hit_success
signal hit_failure

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mass = 0.04592623
	custom_integrator = true
	pass


func _process(_delta: float) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta: float) -> void:
	#on_ground = position.y < 0.022
	#
	#var F_g := Vector3(0.0, -9.81*mass, 0) # force of gravity
	#var F_m := Vector3.ZERO # Magnus force
	#var F_d := Vector3.ZERO # Drag force
	#var F_f := Vector3.ZERO # Frictional force
	#var F_gd := Vector3.ZERO # Drag force from grass
	#
	#var T_d := Vector3.ZERO # Viscous torque
	#var T_f := Vector3.ZERO # Frictional torque
	#var T_g := Vector3.ZERO # Grass drag torque
	#
	#if on_ground:
		#linear_velocity *= 0.98  # dampen rollout
		#omega *= 0.95  # or even 0.9 for stronger damping
		## Force of viscous drag from grass
		#F_gd = linear_velocity*(-6*PI*radius*nu_g)
		#F_gd.y = 0.0
		#
		## velocity of the bottom of the ball relative to the ground with spin included
		#var b_vel : Vector3 = floor_norm.cross(omega)*radius
		#b_vel = b_vel + linear_velocity
		#if b_vel.length() < 0.05: # rolling without slipping
			#b_vel = linear_velocity.normalized()
			#F_f = b_vel*(-u_k*mass*9.81)
		#else: # ball slipping
			#b_vel = b_vel.normalized()
			#F_f = b_vel*(-u_k*mass*9.81)
			#T_f = (floor_norm*-radius).cross(F_f)
			#
		## Viscous Torque
		#T_g = omega.normalized()*-6.0*PI*radius*nu_g
		#F_m = Vector3.ZERO
		#T_d = Vector3.ZERO
		#F_d = Vector3.ZERO
	#else: # ball in air
		#var speed := linear_velocity.length()
		#var spin := 0.0
		#if speed > 0.5:
			#spin = omega.length()*radius/speed
			#
		#var Re : float = rho*speed*radius*2.0/mu
		#
		## Magnus and drag coefficients
		## original
		#var S : float = 0.5*rho*A*radius*(-3.25*spin+1.99)
		##first tweak
		##var S : float = 0.5*rho*A*radius*(-2.4*spin+1.75)
		#
		#
		#var Cd := 0.0 # Drag coefficient
		## Original
		##if Re < 50000.0:
			##Cd = 0.6
		##elif Re < 87500.0:
			##Cd = 0.000000000129*Re*Re - 0.0000259*Re + 1.50
		##else:
			##Cd = 0.0000000000191*Re*Re - 0.0000054*Re + 0.56
			#
		## Tweaked
		#if Re < 50000.0:
			#Cd = 0.6
		#elif Re < 87500.0:
			#Cd = 0.000000000129*Re*Re - 0.0000225*Re + 1.50
		#else:
			#Cd = 0.00000000001925*Re*Re - 0.0000052*Re + 0.56
		#
		## Magnus force
		#F_m = omega.cross(linear_velocity)*S
		## Viscous Torque
		#T_d = -8.0*PI*mu*radius*radius*radius*omega
		#
		## Drag force
		#F_d = linear_velocity*-speed*Cd*rho*A/2.0
		#
	## Total force
	#var F : Vector3 = F_g + F_d + F_m + F_f + F_gd
	#
	## Total torque
	#var T : Vector3 = T_d + T_f + T_g 
	#
	#linear_velocity = linear_velocity + F/mass*delta
	#omega = omega + T/I*delta
	#
	#
	## Collisions
	#var collision = move_and_collide(linear_velocity*delta)
	#if collision:
		#if linear_velocity.length() > 0.5:
			#linear_velocity = bounce(linear_velocity, collision.get_normal())
		#else:
			#linear_velocity = Vector3.ZERO
			#ball_state = State.REST
			#emit_signal("rest")
			#


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
	
	var speed : float = linear_velocity.length()
	var theta_1 : float = linear_velocity.angle_to(normal)
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
	# sleeping = false
	# can_sleep = false  # for testing
	launch_position = position

	var data : Dictionary = {
	"Speed": 100.0,
	"VLA": 22.0,
	"HLA": 1.1,
	"TotalSpin": 6000.0,
	"SpinAxis": 0.5
	}
	
	var max_vla = 45.0
	data["VLA"] = clamp(data["VLA"], 0.0, max_vla)

	ball_state = State.FLIGHT
	position = Vector3(0.0, 0.5, 0.0)
	var speed = data["Speed"] * 0.44704  # Convert mph to m/s
	var vla = deg_to_rad(data["VLA"])
	var direction = Vector3(cos(vla), sin(vla), 0).normalized()
	#var vla = deg_to_rad(data["VLA"])   # vertical launch angle
	var hla = deg_to_rad(data["HLA"])   # horizontal launch angle

# Convert polar angles to a 3D direction vector
	#var direction = Vector3(
	#sin(hla) * cos(vla),
	#sin(vla),
	#-cos(vla)).normalized()
	#var direction = Vector3(1, 0, 0)  # pure X-axis, no vertical or horizontal offset

	launch_velocity = direction * speed
	if global_position.y > 60.0 and linear_velocity.y > 0.0:
		linear_velocity.y *= 0.98  # dampen upward velocity slightly

	var spin = Vector3(0, 0, data["TotalSpin"] * 0.10472).rotated(
		Vector3(1, 0, 0), -deg_to_rad(data["SpinAxis"])
	)

	# Store for use in _integrate_forces
	launch_spin = spin
	launched = true
	print("Launch velocity:", launch_velocity.length())
	
		
func hit_from_data(data : Dictionary):
	# TODO: check data integrity
	# emit hit_failure signal if bad data
	ball_state = State.FLIGHT
	position = Vector3(0.0, 0.05, 0.0)
	linear_velocity = Vector3(data["Speed"]*0.44704, 0, 0).rotated(
					Vector3(0.0, 0.0, 1.0), data["VLA"]*PI/180.0).rotated(
						Vector3(1.0, 0.0, 0.0), data["HLA"]*PI/180.0)
	omega = Vector3(0.0, 0.0, data["TotalSpin"]*0.10472).rotated(Vector3(1.0, 0.0, 0.0), -data["SpinAxis"]*PI/180)
	
	emit_signal("hit_success")
	
	
func reset():
	position = Vector3(0.0, 0.1, 0.0)
	linear_velocity = Vector3.ZERO
	omega = Vector3.ZERO
	ball_state = State.REST


func _on_tcp_client_hit_ball(data: Dictionary) -> void:
	call_deferred("hit_from_data", data)
	
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var linear_velocity = state.linear_velocity
	var angular_velocity = state.angular_velocity
	var on_ground = global_position.y < 0.022
	
	if launched:
		state.linear_velocity = launch_velocity
		state.angular_velocity = launch_spin
		omega = launch_spin
		launched = false
		return  # Prevent physics from clobbering it

	if ball_state == State.REST:
		state.linear_velocity = Vector3.ZERO
		state.angular_velocity = Vector3.ZERO
		omega = Vector3.ZERO
		return
		
	var collision = move_and_collide(linear_velocity * state.step)
	if collision:
		if linear_velocity.length() > 0.5:
			linear_velocity = bounce(linear_velocity, collision.get_normal())
		else:
			linear_velocity = Vector3.ZERO
			angular_velocity = Vector3.ZERO
			omega = Vector3.ZERO
			ball_state = State.REST
			emit_signal("rest")
			return
			
# ✅ Apply forces only if in air
	var F = Vector3.ZERO
	var T = Vector3.ZERO
	if not on_ground:
		# Gravity
		F += Vector3(0, -9.81 * mass, 0)

		# Drag and Magnus
		var speed = linear_velocity.length()
		if speed > 0:
			var spin = omega.length() * radius / speed
			var Re = rho * speed * radius * 2.0 / mu
			# Copilot thing the drag is too low at 0.6 raised to 1.
			var Cd = 1.0 if Re < 87500.0 else 0.00000000001925 * Re * Re - 0.0000052 * Re + 0.56
			#var S = 0.5 * rho * A * radius * (-3.25 * spin + 1.99)
			var S = 0.5 * rho * A * radius * (-3.25 * spin + 1.83)  # exaggerate spin lift decay
			var F_d = -linear_velocity.normalized() * 0.5 * rho * A * speed * speed * Cd * 2.355
			var magnus_scale = clamp(speed / 45.0, 0.0, 1.0)  # fade out as speed drops
			var F_m = omega.cross(linear_velocity) * S * magnus_scale * 0.76
			F += F_d
			F += F_m
			T += -8.0 * PI * mu * pow(radius, 3) * omega
			#print("Drag-to-weight ratio:", F_d.length() / (mass * 9.81))
			#print("Speed:", speed, "| Drag:", F_d.length(), "| Magnus:", F_m.length())
			#print("Cd:", Cd, "| Drag:", F.length(), "| Magnus:", F_m.length())
			var max_apex = global_position.y
			print("Apex height:", max_apex * 3.28084, "ft")
			print("Carry:", (global_position - launch_position).length() * 1.09361, "yd")



		linear_velocity += F / mass * state.step
		angular_velocity += T / I * state.step
	else:
		# ✅ Apply rollout damping / spin decay
		linear_velocity *= 0.90
		omega *= 0.85

		# ✅ Clamp to rest
		if linear_velocity.length() < 0.05:
			linear_velocity = Vector3.ZERO
			angular_velocity = Vector3.ZERO
			omega = Vector3.ZERO
			ball_state = State.REST
			print("Ball has come to rest.")
			emit_signal("rest")
			return

	state.linear_velocity = linear_velocity
	state.angular_velocity = angular_velocity
	omega = angular_velocity
	var dist = (global_position - launch_position).length() * 1.09361
	
