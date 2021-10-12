/// @description

if(keyboard_check_pressed(vk_space)) {		
	if(!scripture_next_page(options, true)) {
		game_restart();
		scripture_jump_to_page(options, 0, true);	
	}
}
options.isPaused = keyboard_check(ord("P"));
	
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
		
/*switch(options.hAlign){
		case fa_left: x = xstart; break;
		case fa_right: x = xstart + options.maxWidth; break;
		case fa_center: x = xstart + options.maxWidth / 2; break;
}

switch(options.vAlign){
		case fa_top: y = ystart; break;
		case fa_right: y = ystart + height; break;
		case fa_middle: y = ystart + height/2; break;
}