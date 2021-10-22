/// @description 
switch(currentEmotion) {
	case Emotion.normal:{
	} break;
	case Emotion.smile:{
		emotionOff.angle = twerp(TwerpType.out_back,0,5,emotionTimer/25);
	} break;
	case Emotion.shocked:{
		emotionOff.y = twerp(TwerpType.out_cubic,-20,0,emotionTimer/room_speed);
	} break;
	case Emotion.sad:{
		emotionOff.y = twerp(TwerpType.out_cubic,0,20,emotionTimer/room_speed);
	} break;
	case Emotion.angry:{
		emotionOff.x = sin_oscillate(-3,3,.1)
	} break;
	case Emotion.smug:{
	} break;
	case Emotion.annoyed:{
	} break;
}
emotionTimer++;

switch(state) {
	case State.in: {
		var _length = room_speed * 3;
		x = twerp(TwerpType.out_sine,xstart + startXOff,xstart, stateTimer/_length);
		if(stateTimer == _length) {
			sysEvents.raiseEvent(Event.slideInDone,{target: key})	
		}
	}
}
stateTimer++;