/// @description 
//scripture_define_style("yellow",{
//	color: c_yellow,
//});
//scripture_define_style("green",{
//	color: c_green,
//});
//scripture_define_style("mashed", {
//	kerning: 0,
//});

testOptions = function(_x, _y, _width, _height){
	var _options = {
		cacheKey:"test",
		hAlign: fa_center,
		vAlign: fa_middle,
		//typingPos: -1, //-1 for all
		maxWidth: _width,
		lineSpacing: -5,
		//maxLines: -1,
		//currentPage: 0
	}

	if(keyboard_check(vk_right))
		_options.hAlign = fa_right;
	if(keyboard_check(vk_left))
		_options.hAlign = fa_left;
	
	if(keyboard_check(vk_up))
		_options.vAlign = fa_top;
	if(keyboard_check(vk_down))
		_options.vAlign = fa_bottom;

	switch(_options.hAlign){
			case fa_left: break;
			case fa_right: _x+=_options.maxWidth; break;
			case fa_center: _x+=_options.maxWidth/2; break;
	}

	switch(_options.vAlign){
			case fa_top: break;
			case fa_right: _y+=_height; break;
			case fa_middle: _y+=_height/2; break;
	}

	return {x: _x, y: _y, options: _options}
}