///@func transition_swipe([color],[direction], [twerpType])
function transition_swipe(_color = c_black, _dir = random(360), _twerpType = TwerpType.out_cubic) {
	return {
		color: _color,
		dir: _dir % 360,
		twerpType: _twerpType,
		step: function(_pos) {},
		draw: function(_pos) {},		
		drawGui: function(_pos) {
			var _x, _y;
			_pos = twerp(twerpType,0,1,_pos);
			if(is_between(dir,0,90,true)){ _x = GUI_W; _y = 0;}
			else if(is_between(dir,90,180,true)){ _x = 0; _y = 0;}
			else if(is_between(dir,180,270,true)){ _x = 0; _y = GUI_H;}
			else if(is_between(dir,270,360,true)){ _x = GUI_W; _y = GUI_H;}

			draw_sprite_ext(sprSquare2x2Centered,0,
			                _x, _y,
			                _pos * GUI_W * 2,
			                GUI_W * 2,
			                dir,
			                color,1);
		}
	}
}