/// @description 
for(var _i = 0; _i < array_length(boxes); _i++) {
	boxes[_i].draw();
}
var _main = boxes[Boxes.main]
if(_main.textbox == undefined || !_main.textbox.getNextPageIsReady()) exit;


var _x = _main.x + _main.width + 10
var _y = _main.y + _main.height - objDemoToolbar.sprite_height - 5;
draw_sprite(sprMouseClick,round(sin_oscillate(0,1,.8)), _x, _y);
var _delay = _main.textbox.getPageAdvanceDelay()
if(_delay != -1) {
	_y -= sprite_get_height(sprMouseClick) - 5;
	_x += sprite_get_width(sprMouseClick) / 2;
	draw_set_text(fa_center, fa_bottom, c_white, fntOpenSans);
	draw_text(_x, _y, string(ceil(_delay / room_speed)))
}