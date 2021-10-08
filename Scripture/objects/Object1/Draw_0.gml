/// @description

var _pos = {x: 10, y: 50}
var _width = 200;
var _height = 400;
var _spacing = 50;

var _test = testOptions(_pos.x,_pos.y, _width, _height);
var _x = _test.x;
var _y = _test.y;
options2.maxWidth = _width;

draw_set_color(c_gray)

draw_line(0,_pos.y + _height/2, room_width, _pos.y + _height/2);

draw_rectangle(_pos.x, _pos.y, _pos.x + _width, _pos.y+_height, true);
_pos.x += _width + _spacing;
draw_rectangle(_pos.x, _pos.y, _pos.x + _width, _pos.y+_height, true);

draw_set_color(c_white);
draw_scripture(_x, _y, 
	//"Single Line",
	//"Page 1 \n test\n Page 2 \n test\n Page 3 \n test\n Page 4",
  "Lorem ipsum dolor sit amet,\n consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", 
  options);


//draw_set_halign(options.hAlign)
//draw_set_valign(options.vAlign);

_x += _width + _spacing;
draw_scripture(_x, _y, 
	"Single Line",
	//"Page 1 \n test\n Page 2 \n test\n Page 3 \n test\n Page 4",
  //"Lorem ipsum dolor sit amet,\n consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", 
  options2);

//draw_text_ext(_x,_y,
//  "\nLorem ipsum dolor sit amet,\n consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
//  -1,options.maxWidth);


draw_set_halign(fa_right)
draw_set_valign(fa_bottom);
draw_text(room_width-5, room_height-5, string(fps_real) + "\n" + string(fps));