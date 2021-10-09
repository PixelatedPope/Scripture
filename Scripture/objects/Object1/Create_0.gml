show_debug_overlay(true)

scripture_add_style("spin", {
	onDraw: function(_char, _steps, _pos) {
			var _dir = (_steps+_pos) * 5;
			_char.xOff = lengthdir_x(5,	_dir);
			_char.yOff = lengthdir_y(5, _dir);
			
		}
});

scripture_add_style("pink", {
	color: make_color_rgb(255,180,180),
	onDraw: function(_char, _steps, _pos) {
			var _dir = (_steps+_pos) * 5;
			_char.alpha = lengthdir_x(1,	_dir);
			_char.angle = _dir * 1.5;
		}
});

scripture_add_style("bold", {
	font: fntBold
});

testString = "<spin>Lorem ipsum <pink><bold>DOLOR</bold></pink> sit amet</spin>,\n consectetur<pink> adipiscing elit</pink>, sed do eiusmod tempor</bold> incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

defaultStyle = new __scriptureStyle();
options = {
		cacheKey: "Test",
		hAlign: fa_center,
		vAlign: fa_middle,
		
		typeSpeed: 1, //0 for instant
		maxWidth: 0,
		lineSpacing: 0,
		maxLines: 10,
		currentPage: 0
}

options2 = {
		cacheKey: "Test 2",
		hAlign: fa_center,
		vAlign: fa_middle,
		
		typeSpeed: 0, //0 for instant
		maxWidth: 0,
		lineSpacing: 0,
		maxLines: 0,
		currentPage: 0
}

options3 = {
		cacheKey: "Test 3",
		hAlign: fa_center,
		vAlign: fa_middle,
		
		typeSpeed: 0, //0 for instant
		maxWidth: 0,
		lineSpacing: -2,
		maxLines: 4,
		currentPage: 0
}

testOptions = function(_x, _y, _width, _height){
	options.maxWidth = _width;
	if(keyboard_check_pressed(vk_space)) {		
		if(!scripture_advance_page(options))
			game_restart(); //MEMORY LEAK OR SUPER GENIUS TAKING ADVANTAGE OF CACHE?
		
		scripture_advance_page(options2);
		scripture_advance_page(options3);
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
	
	
options2.maxWidth = _width;
options2.vAlign = options.vAlign;
options2.hAlign = options.hAlign;
options3.maxWidth = _width;
options3.vAlign = options.vAlign;
options3.hAlign = options.hAlign;

	return {x: _x, y: _y}
}