function scripture_build_example_styles() {
	//Events
	showMessage = scripture_register_event("show message", function(){ show_message("Yup") });
	
	//Images
	squiggle =  scripture_register_sprite("squiggle",sprSquiggle24x24TopLeft, {
		kerning: 0,
		alpha: 1,
		angle: 0,
		xScale: 2
	});
	
	
	welcomeTo = scripture_register_style("welcome to", {
		speedMod: .3,
		font: fntBold,
		yOff: -10,
	});
	
	//Styles
scripture = scripture_register_style("scripture", {
	font: fntScripture,
	kerning: 20,
	speedMod: .04,
	color: make_color_rgb(255,234,163),
	onDraw: function(_x, _y, _style, _element, _steps, _pos) {
		var _length = room_speed;
		_style.alpha = 0;
		if(_steps < _length) {
			var _prog = _steps / _length;
			var _scale = twerp(TwerpType.out_cubic, 1, 1.5, _prog);
			var _alpha = lerp(1, 0, _prog);
			var _offDir = lerp(180,0,_pos / 8);
			var _maxOff =  lengthdir_x(twerp(TwerpType.out_cubic,0,50,_prog), _offDir);
			gpu_set_blendmode(bm_add);
			var _count = 20;
			for(var _i = 1; _i < _count; _i++) {
				var _xOff = lerp(0,_maxOff, _i/_count);
				draw_set_alpha(_alpha * (_i/_count))
				var _tempScale = twerp(TwerpType.out_quad,1, _scale, _i/_count);
				draw_text_transformed(_x + _xOff, _y, _element.char, _tempScale, _tempScale,0);
			}
			gpu_set_blendmode(bm_normal);
		}
		_style.alpha = lerp(0,1,(_steps-_length/2)/30);
			
	}
});
	
	flyIn = scripture_register_style("flyIn", {
		font: fntBold,
		speedMod: .5,
		xScale: .5,
		yScale: .5,
		onDraw: function(_x, _y, _style, _element, _steps, _pos) {
			var _length = room_speed;
			var _prog = _steps / _length;
			_style.yOff = twerp(TwerpType.out_back, 30, 0, _prog);
			_style.alpha = lerp(0, 1, _prog);
		}
	});
	
	
	colors = scripture_register_style("colors", {
		onDraw: function(_x, _y, _style, _element, _steps, _pos) {
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
	
	underline = scripture_register_style("underline", {
		onDraw: function(_x, _y, _style, _element, _steps, _pos) {
			draw_set_color(_style.color);
			draw_set_alpha(_style.alpha);
			var _lineY = _y+_element.height/2 + _style.yOff-18;
			draw_line(_x+_style.xOff-_element.width/2, _lineY, _x+_style.xOff+_element.width/2,_lineY);
			_lineY+=1;
			draw_line(_x+_style.xOff-_element.width/2, _lineY, _x+_style.xOff+_element.width/2,_lineY);
		}
	});

scripture_register_style("flyin", {
	font: fntBold,
	color: c_yellow,
	onDraw: function(_x, _y, _style, _element, _steps, _pos) {
		with(_style) {
	
			var _percent = clamp(_steps / room_speed, 0, 1);
			alpha = _percent * 2;
			xScale = _percent;
			yScale = _percent;
			xOff = twerp(TwerpType.out_cubic, -20, 0, _percent);
			yOff = twerp(TwerpType.out_bounce, -100, 0, _percent);
		}
	}
});

	scripture_register_style("shutter", {
		onDraw: function(_x, _y, _style, _element, _steps, _pos) {
			var _percent = clamp(_steps / room_speed,0,1);
			_style.xScale = twerp(TwerpType.out_expo,0,1,_percent);
		}
	});

scripture_register_style("fireworks", {
	onDraw: function(_x, _y, _style, _element, _steps, _pos) {
		if(_steps != 0 || (_element.type == SCRIPTURE_TYPE_CHAR && _element.char == " ")) return;
		
		effect_create_above(ef_firework,_x + _element.centerY + random_range(-5,5), _y + _element.centerY + random_range(-5,5), 0,make_color_hsv(irandom(255),255,255))
		
	}
});

scripture_register_style("bleep", {
	onDraw: function(_x, _y, _style, _element, _steps, _pos) {
		if(_steps != 10 || (_element.type == SCRIPTURE_TYPE_CHAR && _element.char == " ")) return;
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