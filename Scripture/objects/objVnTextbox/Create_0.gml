/// @description 
depth = VN_TEXTBOX_DEPTH;

Textbox = function(_x, _y, _width, _height, _color = c_black, _marginX = 20, _marginY = 35) constructor {
	color = _color;
	x = _x;
	y = _y;
	textbox = undefined;
	isVisible = true;
	hAlign = fa_left;
	width = _width;
	height = _height;
	marginX = _marginX;
	marginY = _marginY;
	rebuild = function(_text, _matchWidth = true){
		textbox = scripture_build_textbox(_text,0,0,hAlign,fa_middle,1);
		if(_matchWidth) {
			width = textbox.maxWidth + marginX * 2;	
		}
		return self;
	}
	drawTextBox = function() {
		draw_sprite_stretched_ext(sprVnTextboxBg, 0, x, y, width, height, color ,1);
		draw_sprite_stretched(sprVnTextboxFrame, 0, x, y, width, height);
	}
	draw = function(){
		if(!isVisible) return;
		drawTextBox()
		if(textbox == undefined) return;
		textbox.draw(x+marginX,y+marginY);
	}
}

bold = scripture_register_style("VnBold",{
	font: fntVnBold
})

boyName = bold.open+"Onii-san"
boyNameKanji = bold.open+"虎太郎"	
boyNameHiragana = "こたろう"
girlName = bold.open+"Yumi"
testText = boyNameKanji + " " + boyNameHiragana + " This is test text."

var _center = room_width / 2;
var _boxW = 980 / 2
var _boxH = 240;
var _nameW = 300;
var _nameH = 64;
var _nameYOff = -_nameH+4;
var _nameXOff = 64;
boxes = [
	new Textbox(_center - _boxW,										room_height-_boxH,           _boxW*2, _boxH).rebuild(testText, false),
	new Textbox(_center - _boxW - _nameXOff,        room_height-_boxH+_nameYOff, _nameW,  _nameH, VN_GIRL_COLOR).rebuild(girlName),
	new Textbox(_center + _boxW-_nameW + _nameXOff, room_height-_boxH+_nameYOff, _nameW,  _nameH, VN_BOY_COLOR).rebuild(boyNameKanji)
]

sysEvents.addListener(id, Event.boyTalking,function(_options){
	boxes[0].color = VN_BOY_COLOR;
	boxes[1].visible = false;
	boxes[2].visible = true;
})

sysEvents.addListener(id, Event.girlTalking,function(_options){
	boxes[0].color = VN_GIRL_COLOR;
	boxes[1].visible = true;
	boxes[2].visible = false;
})