function scrVnBuildStyles() {
	regular = scripture_register_style("VnDefault", {
		font: fntVnZen,
		color: c_white,
		pageAdvanceDelay: room_speed * 5,
	});
	bold = scripture_register_style("VnBold",{
		font: fntVnBold
	})
	rotateFade = scripture_register_style("RotateFade", {
	
		onDrawBegin: function(_x, _y, _style, _base, _steps, _pos) {
			var _length = 30;
			_style.angle = twerp(TwerpType.out_back,180, 0, _steps / _length);
			_style.alpha = lerp(0,1,_steps/_length);
		}
	});
	shout = scripture_register_style("Shout",{
		font: fntBold,
		onDrawBegin: function(_x, _y, _style, _base, _steps, _index) {
			_style.yOff = random_range(-2,2);
			_style.xOff = random_range(-2,2);
		}
	});
	sndGirl = scripture_register_style("SndGirl", {
		onDrawBegin: function(_x, _y, _style, _base, _steps, _pos){
			if(_steps == 0 && !_base.isSpace) {
				audio_play_sound_unique(sndBeep,0,false,false,.9,1.1);	
			}
		}
	});
	sndBoy = scripture_register_style("SndBoy", {
		onDrawBegin: function(_x, _y, _style, _base, _steps, _pos){
			if(_steps == 0 && !_base.isSpace) {
				audio_play_sound_unique(sndBeep,0,false,false,.7,.8);	
			}
		}
	});

	colorful = scripture_register_style("Colorful",{
		onDrawBegin: function(_x, _y, _style, _base, _steps, _index) {
			_style.color = make_color_hsv((_steps * 2 + _index * 10) % 255,165,255);
			_style.yOff = sin_oscillate(-5,5,3,get_timer()*3 + steps_to_microseconds(_index* 5))
		}
	});
	
	rant = scripture_register_style("Rant",{
		pageAdvanceDelay: 10,
		speedMod: 10,
	});
}