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

repeat(3) {
	draw_rectangle(_pos.x, _pos.y, _pos.x + _width, _pos.y+_height, true);
	_pos.x += _width + _spacing;
}

draw_set_color(c_white);
draw_scripture(_x, _y, 
	//"Single Line",
	"Page 1 \n test \n Page 2 \n test \n Page 3 \n test \n Page 4",
  options);

_x += _width + _spacing;
draw_scripture(_x, _y, 
	"Single Line",
  options2);
	
_x += _width + _spacing;
draw_scripture(_x, _y, 
  "Lorem ipsum dolor sit amet,\n consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", 
  options3);




draw_set_halign(fa_right)
draw_set_valign(fa_bottom);
draw_text(room_width-5, room_height-5, string(fps_real) + "\n" + string(fps));