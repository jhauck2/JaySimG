# Copyright (c) 2023-2025 Cory Petkovsek and Contributors
# Copyright (c) 2021 J. Cuellar

class_name DateTimeUtil


const TOTAL_HOURS: int = 24


static func compute_leap_year(year: int) -> bool:
	return (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);


static func hour_to_total_hours(hour: int) -> float:
	return float(hour)


static func hour_minutes_to_total_hours(hour: int, minutes: int) -> float:
	return float(hour) + float(minutes) / 60.0


static func hours_to_total_hours(hour:int, minutes: int, seconds: int) -> float:
	return float(hour) + float(minutes) / 60.0 + float(seconds) / 3600.0


static func full_time_to_total_hours(hour: int, minutes: int, seconds: int, milliseconds: int) -> float: 
	return float(hour) + float(minutes) / 60.0 + float(seconds) / 3600.0 + \
		float(milliseconds) / 3600000.0
