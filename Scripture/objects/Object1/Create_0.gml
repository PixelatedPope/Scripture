show_debug_overlay(true)

options = {
		cacheKey: "Test",
		hAlign: fa_center,
		vAlign: fa_middle,
		
		typeSpeed: 3, //0 for instant
		maxWidth: 0,
		lineSpacing: 10,
		maxLines: 5,
		currentPage: 0
}

options2 = {
		cacheKey: "Test 2",
		hAlign: fa_center,
		vAlign: fa_middle,
		
		typeSpeed: 3, //0 for instant
		maxWidth: 0,
		lineSpacing: 10,
		maxLines: 5,
		currentPage: 0
}

testOptions = function(_x, _y, _width, _height){
	options.maxWidth = _width;
	if(keyboard_check_pressed(vk_space)) {
		if(!scripture_advance_page(options)) {
			//Textbox Is Done
		}
	}
	if(keyboard_check(vk_right))
		options.hAlign = fa_right;
	else if(keyboard_check(vk_left))
		options.hAlign = fa_left;
	else
		options.hAlign = fa_center;
	
	if(keyboard_check(vk_up))
		options.vAlign = fa_top;
	else if(keyboard_check(vk_down))
		options.vAlign = fa_bottom;
	else
		options.vAlign = fa_middle;
		
	switch(options.hAlign){
			case fa_left: break;
			case fa_right: _x += options.maxWidth; break;
			case fa_center: _x += options.maxWidth/2; break;
	}

	switch(options.vAlign){
			case fa_top: break;
			case fa_right: _y += _height; break;
			case fa_middle: _y += _height/2; break;
	}
	
	return {x: _x, y: _y}
}