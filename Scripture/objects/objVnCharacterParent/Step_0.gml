/// @description 
switch(currentEmotion) {
	case Emotion.normal:{
	} break;
	case Emotion.smile:{
		emotionOff.angle = twerp(TwerpType.out_back,0,5,emotionTimer/25);
		if(emotionTimer == 25) {
			part_particles_create(global.vnPartSystemLower,x,bbox_top+150,global.note,6);	
		}
	} break;
	case Emotion.shocked:{
		if(emotionTimer == 0) {
			for(var _i=45; _i < 135; _i+=random_range(20,30)) {
				part_type_direction(global.surprise, _i, _i, 0, 0);
				part_particles_create(global.vnPartSystemLower,x,bbox_top + 50,global.surprise,1)
			}
		}
		emotionOff.y = twerp(TwerpType.out_cubic,-20,0,emotionTimer/room_speed);
	} break;
	case Emotion.sad:{
		repeat(choose(0,1)) {
			part_particles_create(global.vnPartSystemLower,random_range(bbox_left+50,bbox_right-50),-100,global.rain,1)
			emotionOff.color = merge_color(c_white,c_navy,clamp(emotionTimer/room_speed,0,.25))
		}	
		emotionOff.y = twerp(TwerpType.out_cubic,0,20,emotionTimer/room_speed);
	} break;
	case Emotion.angry:{
		emotionOff.color = merge_color(c_white,c_orange,clamp(emotionTimer/room_speed,0,.25))
		emotionOff.x = sin_oscillate(-3,3,.1);
		repeat(choose(0,1)) {
			part_particles_create(global.vnPartSystemLower,random_range(bbox_left,bbox_right),y+50,global.fireClockwise,1)
			part_particles_create(global.vnPartSystemLower,random_range(bbox_left,bbox_right),y+50,global.fireCounterClockwise,1)
		}	
	} break;
	case Emotion.smug:{
		var _length = room_speed / 3;
		emotionOff.y = twerp(TwerpType.out_cubic,-5,0,(emotionTimer mod _length)/_length);
		if(emotionTimer % (_length * 2) == 0) {
			part_particles_create(global.vnPartSystemLower,x,bbox_top+150,global.he,1);	
		}
	} break;
	case Emotion.annoyed:{
		emotionOff.x = sin_oscillate(-1,1,.25);
		emotionOff.y = sin_oscillate(-1,1,.1);
		emotionOff.color = merge_color(c_white,c_red,clamp(emotionTimer/room_speed,0,.15))
	} break;
}
emotionTimer++;

switch(state) {
	case State.in: {
		var _length = room_speed * 2;
		x = twerp(TwerpType.out_sine,xstart + startXOff,xstart, stateTimer/_length);
		if(stateTimer == _length) {
			sysEvents.raiseEvent(Event.slideInDone,{target: key})	
		}
	}
}
stateTimer++;