typePos = 0;
currentPage = 0;

testOptions = function(_x, _y, _width, _height){
	var _options = {
		cacheKey:"test",
		hAlign: fa_center,
		vAlign: fa_middle,
		typePos: -1,// for all
		maxWidth: _width,
		lineSpacing: 0,
		maxLines: 4,
		currentPage: currentPage
	}

	typePos += .25;

	if(keyboard_check_pressed(vk_space)) 
		currentPage++;
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