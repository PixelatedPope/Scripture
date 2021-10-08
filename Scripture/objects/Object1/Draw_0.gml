/// @description

var _width = 200;
var _height = 400;
var _spacing = 50;

var _test = testOptions(10,30, _width, _height);
var _x = _test.x;
var _y = _test.y;



draw_rectangle(10, 30, 10+options.maxWidth, 30+_height, true);
draw_scripture(_x, _y, 
  "\nLorem ipsum dolor sit amet,\n consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", 
  options);


draw_set_halign(options.hAlign)
draw_set_valign(options.vAlign);

_x+= options.maxWidth + _spacing;
draw_text_ext(_x,_y,
  "\nLorem ipsum dolor sit amet,\n consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  -1,options.maxWidth);


draw_set_halign(fa_right)
draw_set_valign(fa_bottom);
draw_text(room_width-5, room_height-5, string(fps_real) + "\n" + string(fps));