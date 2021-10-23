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
	case Emotion.scared:{
		var _length = 20;
		emotionOff.y = twerp(TwerpType.out_cubic,0,20,emotionTimer/room_speed);
		emotionOff.x = sin_oscillate(-1,1,.25);
		if(emotionTimer % _length == 0) {
			var _dist = 150;
			var _ang = -1;
			
			var _remainder = (emotionTimer div _length) % 6;
			switch(_remainder) {
				case 0: _ang = 135; break;
				case 1: _ang = 105; break;
				case 2: _ang = 75; break;
				case 3: _ang = 35; break;
			
			}
			if(_ang == -1) break;
			
			var _x = x+lengthdir_x(_dist,_ang);
			var _y = bbox_top+_dist + lengthdir_y(_dist,_ang);
			part_particles_create(global.vnPartSystemLower,_x,_y,global.go,1);	
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