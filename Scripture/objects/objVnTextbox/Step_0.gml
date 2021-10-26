/// @description 
if(mouse_check_button_pressed(mb_left) || gamepad_button_check_pressed(0,gp_face1)) {
	for(var _i = 0; _i < array_length(boxes); _i++) {
		if(boxes[_i].textbox != undefined) 
			boxes[_i].textbox.gotoPageNext();
	}
}

if(keyboard_check_pressed(vk_left)){
	boxes[Boxes.main].textbox.gotoPagePrev(true);

}