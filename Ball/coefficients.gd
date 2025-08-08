extends Object
class_name Coefficients

static func get_Cd(Re: float) -> float:
	if Re < 50000.0:
		return 0.5
	if Re > 200000.0:
		return 0.2
		
	return 1.1948 - 0.0000209661*Re + 1.42472e-10*Re*Re - 3.14383e-16*Re*Re*Re

static func get_Cl(Re: float, S: float) -> float:
	# Low and high S
	if S < 0.05:
		return 0.1
	if S > .35:
		if Re > 12.5e4:
			return .13
		else:
			return -1.34786 + 0.0000369549*Re - 1.99478e-10*Re*Re
	
	# Low and high Reynolds number
	if Re < 50000:
		return 0.1
	if Re > 75000:
		return .203 - 0.000000431*Re
		
	# Calculations
	var Re_values: Array[int] = [50000, 60000, 65000, 70000, 75000]
	var Re_low_index := 0
	var Re_high_index := 0
	# Get bounding values for Reynolds number
	for val in Re_values:
		if Re > val:
			Re_low_index = Re_values.find(val)
		if Re < val:
			Re_high_index = Re_values.find(val)
			break
	
	var ClCallables : Array[Callable] = [Re50kToCl, Re60kToCl, Re65kToCl, Re70kToCl, Re75kToCl]
	
	# Get lower and upper bounds on Cl based on Re bounds and S
	var Cl_low = ClCallables[Re_low_index].call(S)
	var Cl_high = ClCallables[Re_high_index].call(S)
	var weight : float = (Re - Re_values[Re_low_index])/(Re_values[Re_high_index] - Re_values[Re_low_index])
	
	# Interpolate final Cl value from uper and lower Cl
	return lerpf(Cl_low, Cl_high, weight)

static func Re50kToCl(S: float) -> float:
	return 0.0472121 + 2.84795*S - 23.4342*S*S + 45.4849*S*S*S
	
static func Re60kToCl(S: float) -> float:
	return 0.320524 - 4.7032*S + 14.0613*S*S

static func Re65kToCl(S: float) -> float:
	return 0.266667 - 4*S + 13.3333*S*S
	
static func Re70kToCl(S: float) -> float:
	return 0.0496189 + 0.00211396*S + 2.34201*S*S
	
static func Re75kToCl(S: float) -> float:
	return 1.1*S + 0.01
