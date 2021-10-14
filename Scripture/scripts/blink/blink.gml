/// @description blink(blink length)
function blink(_length) {
	return round(sin_oscillate(0,1,_length))
}
