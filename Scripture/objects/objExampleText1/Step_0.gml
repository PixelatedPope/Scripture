/// @description

if(keyboard_check_pressed(vk_space)) {		
 	if(!scripture_next_page(textbox, true)) {
		scripture_jump_to_page(textbox, 0, true);	
	}
}
textbox.isPaused = keyboard_check(ord("P"));
	
if(keyboard_check(vk_right))
	textbox.hAlign = fa_right;
else if(keyboard_check(vk_left))
	textbox.hAlign = fa_left;
else
	textbox.hAlign = fa_center;
	
if(keyboard_check(vk_up))
	textbox.vAlign = fa_top;
else if(keyboard_check(vk_down))
	textbox.vAlign = fa_bottom;
else
	textbox.vAlign = fa_middle;
		
/*switch(textbox.hAlign){
		case fa_left: x = xstart; break;
		case fa_right: x = xstart + textbox.maxWidth; break;
		case fa_center: x = xstart + textbox.maxWidth / 2; break;
}

switch(textbox.vAlign){
		case fa_top: y = ystart; break;
		case fa_right: y = ystart + height; break;
		case fa_middle: y = ystart + height/2; break;
}