/// @description
//draw_set_color(c_gray)
//draw_rectangle(xstart, ystart, xstart + objDemoController.width, ystart + objDemoController.height, true);

var _result = draw_scripture(x, y, objDemoController.testString, options);
if(options.isPaused) {
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	draw_set_font(fntBold);
	draw_set_color(c_grey);
	draw_text_transformed(room_width/2, room_height/2 - 100, "PAUSED", .75, .75, 0);
}
