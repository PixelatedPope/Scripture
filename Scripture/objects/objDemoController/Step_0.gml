/// @description 
if(!mouse_check_button_pressed(mb_left)) return;

if(random(1) < .25)
	instance_create_depth(mouse_x, mouse_y, depth-1, objTextPopup).setText("MISS","C423A1");
else
	instance_create_depth(mouse_x, mouse_y, depth-1, objTextPopup).setText(irandom(1000), "F20000");