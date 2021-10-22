/// @description 
event_inherited();
targetRoom = undefined;
timer = 0;
state = State.wait;

outLength = 30;
inLength = 30;
delay = 5;

inEffect = undefined;
outEffect = undefined;

///@func startTransition(room, out effect, in effect, [out length], [in length], [delay])
startTransition = function(_room, _outEffect, _inEffect, _outLength = 30, _inLength = 30, _delay = 5){
	if(state != State.wait) return;
	targetRoom = _room;
	
	outEffect = _outEffect;
	inEffect = _inEffect;
	
	outLength = _outLength;
	inLength = _inLength;
	delay = _delay;
	
	timer = 0;
	state = State.out;
	sysEvents.raiseEvent(Event.transitionStarted);
	
}

//sysEvents.addListener(id, Event.battleStart, function(_options) {
//	var _dir = random(360);
//	startTransition(_options.targetRoom, 
//									transition_camera_zoom(c_white), 
//									transition_swipe(c_white,_dir),60,60,15);
//}, false);
