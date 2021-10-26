/// @func sin_oscillate(min,max,duration,[position in microseconds])
function sin_oscillate(_min, _max, _duration, _pos = get_timer()) {
  return((_max-_min)/2 * dsin(360 * 0.000001 * _pos /_duration) + (_max+_min)/2);
}

/// @func cos_oscillate(min,max,duration,[position in microseconds])
function cos_oscillate(_min, _max, _duration, _pos = get_timer()) {
  return((_max-_min)/2 * dcos(360 * 0.000001 * _pos / _duration) + (_max+_min)/2);
}

///@func steps_to_microseconds(steps)
function steps_to_microseconds(_steps) {
	return 1000000 * (_steps/room_speed)
}