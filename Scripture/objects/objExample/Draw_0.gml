/// @description

var _pos = {x: 10, y: 50}
var _width = 200;
var _height = 600;
var _spacing = 50;

var _test = testOptions(_pos.x,_pos.y, _width, _height);
var _x = _test.x;
var _y = _test.y;
draw_set_color(c_gray)

draw_line(0,_pos.y + _height/2, room_width, _pos.y + _height/2);

repeat(1) {
	draw_rectangle(_pos.x, _pos.y, _pos.x + _width, _pos.y+_height, true);
	_pos.x += _width + _spacing;
}

draw_scripture(_x, _y, testString, options);

draw_set_halign(fa_right)
draw_set_valign(fa_bottom);
draw_text(room_width-5, room_height-5, string(fps_real) + "\n" + string(fps));