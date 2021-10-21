/// @description


if(keyboard_check_pressed(vk_space)) {		
 	if(!textbox.gotoPageNext(true)) {
		textbox.gotoPage(0, true);	
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