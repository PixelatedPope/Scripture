/// @description


draw_set_color(c_gray)
var _maxWidth = textbox.maxPageWidth / 2;
var _maxHeight = textbox.maxPageHeight / 2;
draw_rectangle(x - _maxWidth, y - _maxHeight, x + _maxWidth, y + _maxHeight, true);


draw_set_color(c_red)
var _pageWidth = textbox.getCurrentPageSize().width/ 2;
var _pageHeight = textbox.getCurrentPageSize().height / 2;
draw_rectangle(x - _pageWidth, y - _pageHeight, x + _pageWidth, y + _pageHeight, true);


textbox.draw(x, y);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fntDefault);
draw_set_color(c_gray);
draw_text(x - _maxWidth, y + _maxHeight + 10, 
					string(textbox.getCurrentPage()+1) + " / " + string(textbox.pageCount));

if(textbox.nextPageReady) {
	draw_sprite_ext(sprArrow,0, x + _maxWidth, y + _maxHeight + sin_oscillate(0,10,1) ,1,1,270,c_gray,1);
}

if(textbox.isPaused) {
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	draw_set_font(fntBold);
	draw_set_color(c_grey);
	draw_text_transformed(room_width/2, room_height/2 - 100, "PAUSED", .75, .75, 0);
}
