/// @func sin_oscillate(min,max,duration,?position)
function sin_oscillate(_min, _max, _duration, _pos) {
  _pos = _pos == undefined ? get_timer() / 1000000 : _pos;
  return((_max-_min)/2 * sin(_pos*2*pi/_duration) + (_max+_min)/2);
}

