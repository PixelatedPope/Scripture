function scripture_build_example_styles() {
	//Images
	scripture_register_sprite("squiggle",sprSquiggle24x24TopLeft, {
		//color: c_white,
		kerning: 0,
		alpha: 1,
		angle: 0,
		xScale: 2
		//yScale: 1
	});
	//Events
	scripture_register_event("show message", function(){ show_message("Yup") });
	
	//Styles
	scripture_register_style("colors", {
		onDraw: function(_x, _y, _style, _steps, _pos) {
			if(_steps == 0)
				_style.color = make_color_hsv(irandom(255),165,255);
		}
	});

	scripture_register_style("slow down", {
		speedMod: .05
	});

	scripture_register_style("tight", {
		font: fntBold,
		kerning: -5,	
	});

	scripture_register_style("flyin", {
		font: fntBold,
		color: c_yellow,
		onDraw: function(_x, _y, _style, _steps, _pos) {
			with(_style) {
				startX = -20;
				startY = -100;
				
				var _percent = clamp(_steps / room_speed, 0, 1);
				alpha = _percent * 2;
				xScale = _percent;
				yScale = _percent;
				xOff = twerp(TwerpType.out_cubic, startX, 0, _percent);
				yOff = twerp(TwerpType.out_bounce, startY, 0, _percent);
			}
		}
	});

	scripture_register_style("shutter", {
		onDraw: function(_x, _y, _char, _steps, _pos) {
			var _percent = clamp(_steps / room_speed,0,1);
			_char.xScale = twerp(TwerpType.out_expo,0,1,_percent);
		}
	});

	scripture_register_style("fireworks", {
		onDraw: function(_x, _y, _char, _steps, _pos) {
			if(_steps != 0 || (_char.type == SCRIPTURE_TYPE_CHAR && _char.char == " ")) return;
		
			effect_create_above(ef_firework,_x + _char.centerY + random_range(-5,5), _y + _char.centerY + random_range(-5,5), 0,make_color_hsv(irandom(255),255,255))
		
		}
	});

	scripture_register_style("bleep", {
		onDraw: function(_x, _y, _char, _steps, _pos) {
			if(_steps != 10 || (_char.type == SCRIPTURE_TYPE_CHAR && _char.char == " ")) return;
			audio_play_sound_unique(sndBeep, 10, false, false, .25)	
		}
	})

	scripture_register_style("bold", {
		font: fntBold
	});

	scripture_register_style("small", {
		font: fntDefault
	});

}