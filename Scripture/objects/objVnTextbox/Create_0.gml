/// @description 
depth = VN_TEXTBOX_DEPTH;

///@func Textbox(x, y, width, height, [color], [margin x], [margin y], [typeSpeed])
Textbox = function(_x, _y, _width, _height, _color = c_black, _marginX = 20, _marginY = 10) constructor {
	color = _color;
	x = _x;
	y = _y;
	textbox = undefined;
	visible = false;
	hAlign = fa_left;
	width = _width;
	height = _height;
	marginX = _marginX;
	marginY = _marginY;
	defaultTypeSpeed = .25;
	
	///@func rebuild(text, matchWidth, typeSpeed);
	rebuild = function(_text,_matchWidth,  _typeSpeed = defaultTypeSpeed){
		textbox = scripture_build_textbox(_text,980 - marginX * 2, height - 80, hAlign, fa_top, _typeSpeed, -5);
		if(_matchWidth)
			width = textbox.maxWidth + marginX * 2;
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
		if(!visible) return;
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

text = scrVnBuildScript();
girlNames = ["??????",girlName]
girlNameCurrent = 0;
boyNames =  [boyNameOniisan,boyNameKanji, boyNameHiragana, boyNameRomaji];
boyNameCurrent = 0;

var _center = room_width / 2;
var _boxW = 980 / 2
var _boxH = 240;
var _nameW = 300;
var _nameH = 64;
var _nameYOff = -_nameH+4;
boxes = [
	new Textbox(_center - _boxW, room_height-_boxH,           _boxW*2, _boxH),
	new Textbox(_center - _boxW, room_height-_boxH+_nameYOff, _nameW,  _nameH, VN_GIRL_COLOR, 20, 5),
	new Textbox(_center + _boxW, room_height-_boxH+_nameYOff, _nameW,  _nameH, VN_BOY_COLOR, 20, 5)
]
boxes[Boxes.girl].hAlign = fa_left;
boxes[Boxes.boy].hAlign = fa_right;
boxes[Boxes.boy].rebuild(boyNames[boyNameCurrent],true, 1);
boxes[Boxes.girl].rebuild(girlNames[girlNameCurrent],true, 1);
sysEvents.addListener(id, Event.changeSpeaker,function(_options){
	var _speaker = _options.target;
	boxes[Boxes.main].color = _speaker == VN_BOY ? VN_BOY_COLOR : VN_GIRL_COLOR;
	boxes[Boxes.girl].visible = _speaker != VN_BOY
	boxes[Boxes.boy].visible = _speaker == VN_BOY
})

sysEvents.addListener(id, Event.changeName,function(_options){
	if(_options.target == VN_BOY) {
		boyNameCurrent=_options.index;
		boxes[Boxes.boy].rebuild(boyNames[boyNameCurrent],true);
	} else {
		girlNameCurrent=_options.index;
		boxes[Boxes.girl].rebuild(girlNames[girlNameCurrent],true, 1);
	}
})

sysEvents.addListener(id, Event.transitionDone, function(_options) {
	boxes[Boxes.main].rebuild(text, false);
	boxes[Boxes.main].visible = true;
	sysEvents.raiseEvent(Event.changeSpeaker,{target: VN_GIRL});
}, true);

