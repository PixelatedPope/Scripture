/// @description 
depth = VN_TEXTBOX_DEPTH;

Textbox = function(_x, _y, _width, _height, _color = c_black, _marginX = 20, _marginY = 10) constructor {
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
		textbox = scripture_build_textbox(_text,980 - marginX * 2, height - 80, hAlign, fa_top, 5,-5);
		if(_matchWidth) {
			width = textbox.maxWidth + marginX * 2;	
		}
		return self;
	}
	drawTextBox = function() {
		switch(hAlign) {
			case fa_left:
				draw_sprite_stretched_ext(sprVnTextboxBg, 0, x, y, width, height, color ,1);
				draw_sprite_stretched(sprVnTextboxFrame, 0, x, y, width, height);
			break;
			case fa_center:
				draw_sprite_stretched_ext(sprVnTextboxBg, 0, x-width/2, y, width, height, color ,1);
				draw_sprite_stretched(sprVnTextboxFrame, 0, x-width/2, y, width, height);
			break;
			case fa_right:
				draw_sprite_stretched_ext(sprVnTextboxBg, 0, x-width, y, width, height, color ,1);
				draw_sprite_stretched(sprVnTextboxFrame, 0, x-width, y, width, height);
			break;
		}
	}
	draw = function(){
		if(!isVisible) return;
		drawTextBox()
		if(textbox == undefined) return;
		switch(hAlign) {
			case fa_left: 
				textbox.draw(x+marginX,y+marginY); break;
			case fa_center: textbox.draw(x+width/2,y+marginY); break;
			case fa_right: textbox.draw(x-marginX,y+marginY); break;
		}
		
	}
}

#region Styles
regular = scripture_register_style("VnDefault", {
	font: fntVnZen,
	color: c_white,
});
bold = scripture_register_style("VnBold",{
	font: fntVnBold
})
rotateFade = scripture_register_style("RotateFade", {
	
	onDraw: function(_x, _y, _style, _base, _steps, _pos) {
		var _length = 30;
		_style.angle = twerp(TwerpType.out_back,45, 0, _steps / _length);
	}
});

sndGirl = scripture_register_style("GirlSnd", {
	onDraw: function(_x, _y, _style, _base, _steps, _pos){
		if(_steps == 0) {
			audio_play_sound_unique(sndBeep,0,false,false,.1);	
		}
	}
});
evChangeBoysName = scripture_register_event("ChangeName",function(_arguments) {
	sysEvents.raiseEvent(Event.changeBoysName,{name: _arguments[0]});
},false)

scripture_set_default_style("VnDefault");

#endregion

boyName = bold.open+"Onii-san"
boyNameKanji = bold.open+rotateFade.open+"虎<30>太<30>郎"	
boyNameHiragana = bold.open+rotateFade.open+"こたろう"
girlName = bold.open+"Yumi"
testText = "This is test text." + "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed"+evChangeBoysName.event(1)+" do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

var _center = room_width / 2;
var _boxW = 980 / 2
var _boxH = 240;
var _nameW = 300;
var _nameH = 64;
var _nameYOff = -_nameH+4;
var _nameXOff = 0;
boxes = [
	new Textbox(_center - _boxW, room_height-_boxH,           _boxW*2, _boxH).rebuild(testText, false),
	new Textbox(_center - _boxW, room_height-_boxH+_nameYOff, _nameW,  _nameH, VN_GIRL_COLOR, 20, 5),
	new Textbox(_center + _boxW, room_height-_boxH+_nameYOff, _nameW,  _nameH, VN_BOY_COLOR, 20, 5)
]
boxes[1].hAlign = fa_left
boxes[1].rebuild(bold.open+girlName);
boxes[2].hAlign = fa_right
boxes[2].rebuild(bold.open+boyName);

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

sysEvents.addListener(id, Event.changeBoysName,function(_options){
	switch(_options.name) {
		case "1": boxes[2].rebuild(boyNameKanji); break;
		case "2": boxes[2].rebuild(boyNameHiragana); break;
		case "3": boxes[2].rebuild(boyNameEnglish); break;
	}
	
})