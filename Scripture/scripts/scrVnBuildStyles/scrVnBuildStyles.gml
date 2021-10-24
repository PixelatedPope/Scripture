function scrVnBuildStyles() {
	regular = scripture_register_style("VnDefault", {
		font: fntVnZen,
		color: c_white,
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

	sndGirl = scripture_register_style("GirlSnd", {
		onDraw: function(_x, _y, _style, _base, _steps, _pos){
			if(_steps == 0) {
				audio_play_sound_unique(sndBeep,0,false,false,.1);	
			}
		}
	});


	scripture_set_default_style("VnDefault");
}