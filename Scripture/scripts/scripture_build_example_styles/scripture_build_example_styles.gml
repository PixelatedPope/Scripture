function scripture_build_example_styles() {	
	shake = scripture_register_style("Shake", {
		onDrawBegin: function(_x, _y, _style, _base, _steps, _index) {
			_style.yOff = random_range(-2,2);
			_style.xOff = random_range(-2,2);
		}
	});
	
	rainbow = scripture_register_style("Rainbow", {
		onDrawBegin: function(_x, _y, _style, _base, _steps, _index) {
			_style.color = make_color_hsv((_steps * 2 + _index * 10) % 255,165,255);
		}
	});
	
	outline = scripture_register_style("Outline", {
		kerning: 2,
		onDrawBegin: function(_x, _y, _style, _base, _steps, _index) {
			var _col = merge_color(_style.color,c_white,.75)
			draw_set_color(_col);
			var _scaleMod = _base.xScale * _style.xScale;
			var _thick = 5 * _base.xScale;
			for(var _i=0; _i<360; _i+= 22.5) {
				var _xPos = _x + _style.xOff + _scaleMod * lengthdir_x(_thick, _i);
				var _yPos = _y + _style.yOff + _scaleMod * lengthdir_y(_thick, _i);
				if(_base.type == SCRIPTURE_TYPE_CHAR)
					draw_text_transformed(_xPos, _yPos,_base.char,_scaleMod, _scaleMod,0);
				else
					draw_sprite_ext(_base.sprite, _base.image, _xPos, _yPos, _scaleMod, _scaleMod, _style.angle,_col, _style.alpha);
			}
		}
	});

	underline = scripture_register_style("Underline", {
		onDrawBegin: function(_x, _y, _style, _base, _steps, _index) {
			var _left = _x + _style.xOff - _base.centerX-1;
			var _right = _x + _style.xOff + _base.centerX+1;
			var _lineY = _y + _base.height/2 + _style.yOff;
			draw_line_sprite(sprPixel,_left,_lineY,_right,_lineY,5,_style.color,_style.alpha);
		}
	});

	bleep = scripture_register_style("Bleep", {
		onDrawBegin: function(_x, _y, _style, _base, _steps, _index) {
			if(_steps != 1 || _base.isSpace) return;
			audio_play_sound_unique(sndBeep, 10, false, false, .75, 1.25)	
		}
	})
	
	wave = scripture_register_style("Wave",{
		onDrawBegin: function(_x, _y, _style, _base, _steps, _index) {
			_style.yOff = sin_oscillate(-5,5,3,get_timer()*3 + steps_to_microseconds(_index* 5))
		}
	});
	
	wobble = scripture_register_style("Wobble",{
		onDrawBegin: function(_x, _y, _style, _base, _steps, _index) {
			_style.xScale = sin_oscillate(.5,1.5,3,get_timer()*2 - steps_to_microseconds(_index* 5))
			_style.yScale = _style.xScale;
			_style.alpha = _style.xScale;
		}
	});
	
	coin = scripture_register_sprite("Coin", sprCoin, {
		imageSpeed: 1,
		xScale: 1,
		yScale: 1
	});
	
	showMessage = scripture_register_event("ShowMessage", function(_arguments){
		show_message(_arguments[0]);
	}, false);
}

function wait(_steps) {
	return global.__scripOpenTag+string(_steps)+global.__scripCloseTag;
}