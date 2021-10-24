/// @description 
var _bg = layer_background_get_id("Background")
layer_background_alpha(_bg, sin_oscillate(.25,.75,5))

switch(state) {
	case State.in:
	var _length = room_speed;
	var _bg = layer_background_get_id("Fade")
	layer_background_alpha(_bg, 1 - stateTimer/_length);
	if(stateTimer >= _length) {
		setState(State.wait);
		sysEvents.raiseEvent(Event.transitionDone);
	}
	break;
	
	case State.girlIn: 
		var _length = room_speed * 2;
		objVnGirl.x = twerp(TwerpType.out_back, girlX-offScreen,girlX,stateTimer/_length);
		if(stateTimer >= _length) {
			sysEvents.raiseEvent(Event.slideInDone,{target: VN_GIRL});
			setState(State.wait);
		}
	break;
	
	case State.boyIn:
		var _length = room_speed * 2;
		objVnBoy.x = twerp(TwerpType.out_back, boyX+offScreen,boyX,stateTimer/_length);
		if(stateTimer >= _length) {
			sysEvents.raiseEvent(Event.slideInDone,{target: VN_GIRL});
			setState(State.wait);
		}
	break;
}

stateTimer++;