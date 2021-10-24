/// @description 
draw_sprite_ext(sprite_index, 0,              
	x + emotionOff.x + actionOff.x, 
	y + emotionOff.y + actionOff.y, 
	image_xscale, image_yscale, 
	image_angle + emotionOff.angle + actionOff.angle, 
	emotionOff.color, image_alpha
);
draw_sprite_ext(
	sprite_index, currentEmotion,               
	x + emotionOff.x + actionOff.x, 
	y + emotionOff.y + actionOff.y, 
	image_xscale, image_yscale, 
	image_angle + emotionOff.angle + actionOff.angle, 
	emotionOff.color, image_alpha
);