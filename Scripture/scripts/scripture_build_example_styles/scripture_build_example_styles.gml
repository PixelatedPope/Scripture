function scripture_build_example_styles() {
	//Events
	showMessage = scripture_register_event("show message", function(){ show_message("Yup") }, true);
	
	coin = scripture_register_sprite("coin",sprCoin, {
		xScale: 1,
		yScale: 1
	});
	
	arrow = scripture_register_sprite("arrow",sprArrow, {
		xScale: 1,
		yScale: 1
	});
	
	welcomeTo = scripture_register_style("welcome to", {
		speedMod: .3,
		kerning: 3,
		color: $354838,
		font: fntBold,
		yOff: 0,
	});
	
	//Styles
	scripture = scripture_register_style("scripture", {
		font: fntScripture,
		kerning: 20,
		speedMod: .1,
		color: make_color_rgb(255,234,163),
		onDraw: function(_x, _y, _style, _base, _steps, _pos) {
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
					draw_text_transformed(_x + _xOff, _y, _base.char, _tempScale, _tempScale,0);
				}
				gpu_set_blendmode(bm_normal);
			}
			_style.alpha = lerp(0,1,(_steps-_length/2)/30);
			
		}
	});
	
	flyIn = scripture_register_style("flyIn", {
		font: fntOpenSans,
		speedMod: .5,
		onDraw: function(_x, _y, _style, _base, _steps, _pos) {
			var _length = room_speed*1.5;
			var _prog = _steps / _length;
			_style.yOff = twerp(TwerpType.out_back, 100, 0, _prog);
			_style.alpha = lerp(0, 1, _prog);
			return _steps < _length;
		}
	});
	
	excite = scripture_register_style("excite", {
		onDraw: function(_x, _y, _style, _base, _steps, _pos) {
			_style.yOff = random_range(-2,2);
			_style.xOff = random_range(-2,2);
		}
	});
	
	rainbow = scripture_register_style("rainbow", {
		onDraw: function(_x, _y, _style, _base, _steps, _pos) {
			_style.color = make_color_hsv((_steps * 2 + _pos * 10) % 255,165,255);
		}
	});
	
	outline = scripture_register_style("outline", {
		xScale: 1.,
		yScale: 1.,
		onDraw: function(_x, _y, _style, _base, _steps, _pos) {
			draw_set_color(merge_color(_style.color,c_white,.75));
			var _scaleMod = _base.baseXScale * _style.xScale;
			var _thick = 5 * _base.baseXScale;
			for(var _i=0; _i<360; _i+= 22.5) {
				var _xPos = _x + _style.xOff + _scaleMod * lengthdir_x(_thick, _i);
				var _yPos = _y + _style.yOff + _scaleMod * lengthdir_y(_thick, _i);
				
				draw_text_transformed(_xPos, _yPos,_base.char,
															_scaleMod, _scaleMod,0);
			}
		}
	});

	underline = scripture_register_style("underline", {
		kerning: 10,
		onDraw: function(_x, _y, _style, _base, _steps, _pos) {
			draw_set_color(_style.color);
			draw_set_alpha(_style.alpha);
			var _lineY = _y+_base.height/2 + _style.yOff;
			draw_line(_x+_style.xOff-_base.width/2, _lineY, _x+_style.xOff+_base.width/2+1,_lineY);
			_lineY+=1;
			draw_line(_x+_style.xOff-_base.width/2, _lineY, _x+_style.xOff+_base.width/2+1,_lineY);
		}
	});

	bleep = scripture_register_style("bleep", {
		onDraw: function(_x, _y, _style, _base, _steps, _pos) {
			if(_steps != 1 || _base.isSpace) return;
			audio_play_sound_unique(sndBeep, 10, false, false, .25)	
		}
	})

	bold = scripture_register_style("bold", {
		font: fntBold
	});

	small = scripture_register_style("small", {
		font: fntDefault
	});

}

function wait(_steps) {
	return global.__scripOpenTag+string(_steps)+global.__scripCloseTag;
}