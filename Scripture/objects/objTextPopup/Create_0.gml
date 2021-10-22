/// @description 
textbox = undefined;
visible = false;
setText = function(_text, _color) {
	var _string = flash.open + flyIn.open + outline.open + fadeOut.open + "<#"+_color+">" + string(_text);
	textbox = scripture_build_textbox(_string, 0,0,fa_center, fa_bottom,.5);
	visible = true;
}

life = room_speed * 3;

flyIn = scripture_register_style("DamageFlyIn", {
	font: fntBold,
	speedMod: .5,
	onDrawBegin: function(_x, _y, _style, _base, _steps, _pos) {
		var _length = room_speed*.25;
		var _prog = _steps / _length;
		_style.yOff = twerp(TwerpType.out_back, 100, 0, _prog);
		_style.alpha = lerp(0, 1, _prog);
	}
	
});

fadeOut = scripture_register_style("DamagefadeOut", {
	onDrawBegin: function(_x, _y, _style, _base, _steps, _pos) {
		var _length = room_speed / 2;
		var _prog = (_steps - 30) / _length;
		_style.xScale = twerp(TwerpType.in_quad,1,.5,_prog);
		_style.yScale = _style.xScale;
		_style.alpha = lerp(1, 0, _prog);
	}
});

outline = scripture_register_style("DamageOutline", {
	onDrawBegin: function(_x, _y, _style, _base, _steps, _pos) {
		draw_set_color(merge_color(_style.color,c_black,.75));
		var _scaleMod = _base.xScale * _style.xScale;
		var _thick = 2 * _base.xScale;
		for(var _i=0; _i<360; _i+= 22.5) {
			var _xPos = _x + _style.xOff + _scaleMod * lengthdir_x(_thick, _i);
			var _yPos = _y + _style.yOff + _scaleMod * lengthdir_y(_thick, _i);
				
			draw_text_transformed(_xPos, _yPos,_base.char,
														_scaleMod, _scaleMod,0);
		}
		return _steps < 30;
			
	}
});

flash = scripture_register_style("DamageFlash", {
	onDrawBegin: function(_x, _y, _style, _base, _steps, _pos) {
		_style.color = blink(.1) ? merge_color(_base.color,c_white,.75) : _base.color;
	}
});