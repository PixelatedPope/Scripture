show_debug_overlay(true)

//scripture_set_default_style({})

scripture_add_style("spin", {
	onDraw: function(_x, _y, _char, _steps, _pos) {
			var _dir = (_steps+_pos) * 5;
			_char.xOff = lengthdir_x(5,	_dir);
			_char.yOff = lengthdir_y(5, _dir);
			_char.angle = _dir;
			//_char.alpha = lengthdir_x(1,	_dir);
			
		}
});

scripture_register_sprite("squiggle",sprSquiggle24x24TopLeft);


scripture_add_style("color", {
	font: fntBold,
	onDraw: function(_x, _y, _char, _steps, _pos) {
		if(_steps == 0)
			_char.style.color = make_color_hsv(irandom(255),165,255);
	}
});

scripture_add_style("flyin", {
	onDraw: function(_x, _y, _char, _steps, _pos) {
		
		if(_steps == 0) {
			_char.startX = -20;
			_char.startY = -100;
		}
		
		var _percent = clamp(_steps / room_speed,0,1);
		_char.alpha = _percent * 2;
		_char.xScale = _percent;
		_char.yScale = _percent;
		_char.xOff = twerp(TwerpType.out_cubic,_char.startX,0,_percent);
		_char.yOff = twerp(TwerpType.out_bounce,_char.startY,0,_percent);
	}
});

scripture_add_style("fireworks", {
	onDraw: function(_x, _y, _char, _steps, _pos) {
		if(_steps != 0 || (_char.type == SCRIPTURE_TYPE_CHAR && _char.char == " ")) return;
		
		effect_create_above(ef_firework,_x + _char.centerY + random_range(-5,5), _y + _char.centerY + random_range(-5,5), 0,make_color_hsv(irandom(255),255,255))
		
	}
});

scripture_add_style("bleep", {
		onDraw: function(_x, _y, _char, _steps, _pos) {
			if(_steps != 10 || (_char.type == SCRIPTURE_TYPE_CHAR && _char.char == " ")) return;
			audio_play_sound_unique(sndBeep, 10, false, false, .25)	
		}
})

scripture_add_style("bold", {
	font: fntBold
});

scripture_add_style("small", {
	font: fntDefault
});

testString = "<color><flyin><bleep>Lorem ipsum DOLOR <squiggle> sit amet,\n consectetur<pink> adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

defaultStyle = new __scriptureStyle();
options = {
		cacheKey: "Test",
		hAlign: fa_center,
		vAlign: fa_middle,
		
		typeSpeed: .25, //0 for instant
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