/// @description 
if(mouse_check_button_pressed(mb_left)) {
	for(var _i = 0; _i < array_length(boxes); _i++) {
		if(boxes[_i].textbox != undefined) 
			boxes[_i].textbox.gotoPageNext();
	}
}