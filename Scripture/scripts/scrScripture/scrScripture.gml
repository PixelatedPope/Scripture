//*************************************************************************
// Hi!  Welcome to Scripture!  Make sure you know what you are doing before
// making any changes in this file. The consequences could be dire!
//
// - Pixelated Pope
//*************************************************************************

global.__scripText = {};
global.__scripTextbox = {};
global.__scripString = "";
global.__scripStyles = {};
global.__scripProtectedKeys = ["default", __SCRIPTURE_DEFULT_STYLE_KEY];
global.__scripStyleStack = [];
global.__scripActiveStyle = {};
global.__scripDelay = 0;

#macro __SCRIPTURE_DEFULT_STYLE_KEY "defaultStyle"
#macro SCRIPTURE_TYPE_STYLE 0
#macro SCRIPTURE_TYPE_IMG 1
#macro SCRIPTURE_TYPE_EVENT 2
#macro SCRIPTURE_TYPE_CHAR 3
#macro SCRIPTURE_TYPE_LINE 4
#macro SCRIPTURE_TYPE_PAGE 5
#macro SCRIPTURE_TYPE_TEXT 6
#macro SCRIPTURE_SKIP_VAL 10000

//You can change these here or use the available function.
global.__scripOpenTag = "<"
global.__scripCloseTag = ">"
global.__scripEndTag = "/"

global.__scripColor = "#"
global.__scripImage = "I"
global.__scripFont = "F"
global.__scripKerning = "K"
global.__scripScale = "S"
global.__scripOff = "O"
global.__scripAngle = "a"
global.__scripAlpha = "A"
global.__scripAlign = "L"
global.__scripSpeed = "s"

#region Scripture Constructors
function __scriptureStyle(_style = {}) constructor {
	type = SCRIPTURE_TYPE_STYLE
	//Return a duplicate of the given style with new key
	color = _style[$ "color"] == undefined ? c_white : _style.color;
	sprite = _style[$ "sprite"] == undefined ? undefined: _style.sprite;
	font = _style[$ "font"] == undefined ? -1 : _style.font;
	speedMod = _style[$ "speedMod"] == undefined ? 1 : _style.speedMod;
	kerning = _style[$ "kerning"] == undefined ? 0 : _style.kerning;
	xScale = _style[$ "xScale"] == undefined ? 1 : _style.xScale;
	yScale = _style[$ "yScale"] == undefined ? 1 : _style.yScale;
	xOff = _style[$ "xOff"] == undefined ? 0 : _style.xOff;
	yOff = _style[$ "yOff"] == undefined ? 0 : _style.yOff;
	angle = _style[$ "angle"] == undefined ? 0 : _style.angle;
	alpha = _style[$ "alpha"] == undefined ? 1 : _style.alpha;
	textAlign = _style[$ "textAlign"] == undefined ? fa_middle : _style.textAlign;
	onDrawBegin = _style[$ "onDrawBegin"] == undefined ? function(){} : _style.onDrawBegin;
	onDrawEnd = _style[$ "onDrawEnd"] == undefined ? function(){} : _style.onDrawEnd;
}

global.__scripStyles.defaultStyle = new __scriptureStyle();
global.__scripStyles.defaultStyle.key = __SCRIPTURE_DEFULT_STYLE_KEY;

function __scriptureBuildElement(_style) {
	style = _style;
	xScale = _style.xScale;
	yScale = _style.yScale;
	xOff = _style.xOff;
	yOff = _style.yOff;
	alpha = _style.alpha;
	_style.xScale = 1;
	_style.yScale = 1;
	_style.xOff = 0;
	_style.yOff = 0;
	_style.alpha = 1;
	onDrawBeginSteps = [];
	onDrawEndSteps = [];
	wasSkipped = false;
	resetSteps = function(){
		wasSkipped = false;
		onDrawBeginSteps = [];
			onDrawEndSteps = [];
	}
	skip = function(_line){
		wasSkipped = true;
		onDrawBeginSteps = [];
		onDrawEndSteps = [];
		draw(-100000,-100000, 0, _line);
	}
	executeOnDrawBegin = function(_x, _y,  _index) {
		for(var _i = 0; _i < array_length(style.onDrawBegin); _i++) {
			if(array_length(onDrawBeginSteps) < _i+1) onDrawBeginSteps[_i] = wasSkipped ? SCRIPTURE_SKIP_VAL : 0; 
			var _breakChain = style.onDrawBegin[_i](_x, _y, style, self, onDrawBeginSteps[_i], _index)
			onDrawBeginSteps[_i] += !global.__scripTextbox.isPaused;
			if(_breakChain)	break;
		}
	}
	
	executeOnDrawEnd = function(_x, _y,  _index) {
		for(var _i = 0; _i < array_length(style.onDrawEnd); _i++) {
			if(array_length(onDrawEndSteps) < _i+1) onDrawEndSteps[_i] = wasSkipped ? SCRIPTURE_SKIP_VAL : 0; 
			var _breakChain = style.onDrawEnd[_i](_x, _y, style, self, onDrawEndSteps[_i], _index)
			onDrawEndSteps[_i] += !global.__scripTextbox.isPaused;
			if(_breakChain)	break;
		}
	}
}

function __scriptureChar(_char, _style = new __scriptureStyle()) constructor {
	type = SCRIPTURE_TYPE_CHAR
	char = _char;
	isSpace = _char == " ";
	__scriptureBuildElement(_style);
	draw_set_font(style.font);
	width = string_width(char) * xScale + style.kerning;
	height = string_height(char) * yScale;
	centerX = width / 2;
	centerY = height / 2;
	color = style.color;
	
	draw = function(_x, _y, _index, _line) {
		var _drawX = floor(_x + centerX) + xOff;
		var _drawY = floor(_y + centerY) + yOff;
		
		switch(style.textAlign) {
			case fa_top: break;
			case fa_middle: _drawY += floor(_line.height/2 - centerY); break;
			case fa_bottom: _drawY += floor(_line.height - centerY * 2); break;
		}
		
		draw_set_font(style.font);
		draw_set_color(style.color);
		draw_set_alpha(alpha * style.alpha);
		
		executeOnDrawBegin(_drawX, _drawY, _index);
		
		_drawX += style.xOff;
		_drawY += style.yOff;
		
		draw_set_font(style.font);
		draw_set_color(style.color);
		draw_set_alpha(alpha * style.alpha);
		draw_text_transformed(_drawX, _drawY, char, xScale * style.xScale, yScale * style.yScale, style.angle);
		
		executeOnDrawEnd(_drawX, _drawY, _index);

		return width;
	}
}

function __scriptureImg(_style) constructor {
	type = SCRIPTURE_TYPE_IMG;
	var _active = new __scriptureStyle(global.__scripActiveStyle)
	var _keys = variable_struct_get_names(_style);
	for(var _i = 0; _i < array_length(_keys); _i++) {
		_active[$ _keys[_i]] = _style[$ _keys[_i]];	
	}
	
	sprite = _active.sprite;
	image = 0;
	isSpace = false;
	speed = sprite_get_speed_type(sprite) == spritespeed_framespergameframe 
																				 ? sprite_get_speed(sprite) 
																				 : sprite_get_speed(sprite) / room_speed;
	__scriptureBuildElement(_active)
	style = _active;
	width = sprite_get_width(sprite) * xScale + style.kerning;
	height = sprite_get_height(sprite) * yScale;
	centerX = width/2;
	centerY = height/2;
	
	draw = function(_drawX, _drawY, _index) {
		executeOnDrawBegin(_drawX, _drawY, _index);

		draw_sprite_ext(sprite, image, 
										_drawX + style.xOff + centerX, _drawY + style.yOff + centerY, 
										xScale * style.xScale, yScale * style.yScale, 
										style.angle, style.color, alpha * style.alpha);
		
		executeOnDrawEnd(_drawX, _drawY, _index);
		
		image += speed * !global.__scripTextbox.isPaused;
		return width;
	}
}

function __scriptureEvent(_func, _delay = 0, _canSkip = true, _arguments = []) constructor {
	type = SCRIPTURE_TYPE_EVENT;
	event = _func;
	arguments = _arguments;
	isSpace = false;
	style = {speedMod:1};
	ran = false;
	wasSkipped = false;
	canSkip = _canSkip;
	delay = _delay;
	skip = function(_line){
		wasSkipped = true;	
		draw();
	}
	draw = function(){
		if(ran) return 0;
		ran = true;
		event(arguments);
		if(delay > 0) 
			global.__scripDelay = delay;
		return 0;
	}
}


function __scriptureLine() constructor {
	type = SCRIPTURE_TYPE_LINE
	width = 0;
	height = 0;
	characters = [];
	isComplete = false;
	lastSpace = undefined;
	getLength = function() { return array_length(characters) };
	typePos = 0;
	delay = __scriptureIsTyping();
	draw = function(_x, _y, _page) {
		var _eventCount = 0;
		for(var _c = 0; _c < getLength(); _c++) {
			if(!isComplete && __scriptureIsTyping() && _c > typePos && _c > 0) {
				if(global.__scripDelay > 0) {
					global.__scripDelay--;
					return false;
				}
				if(!global.__scripTextbox.isPaused)
					typePos += global.__scripTextbox.typeSpeed * characters[_c-1].style.speedMod;
					_eventCount += characters[_c].type == SCRIPTURE_TYPE_EVENT;
				return false;
			}
			_eventCount += characters[_c].type == SCRIPTURE_TYPE_EVENT;
			_x += characters[_c].draw(_x, _y, _c - _eventCount, self);
		}
		if(delay > 0) {
			delay -= getLength() == 0 ? 1 : characters[getLength()-1].style.speedMod;
			return false;	
		}
		isComplete = true;
		return true;
	}
	
	reset = function(){
		isComplete = false;
		typePos = 0;
		delay = __scriptureIsTyping();
		for(var _i = 0; _i < getLength(); _i++) {
			var _char = characters[_i];
			
			switch(_char.type) {
				case SCRIPTURE_TYPE_EVENT:
					_char.ran = false;
				break;
				case SCRIPTURE_TYPE_IMG:
					_char.image = 0;
				default:
					_char.resetSteps();
			}
		}
	}
	
	endAnimations = function() {
		for(var _c = 0; _c < getLength(); _c++) {
			var _char = characters[_c];
			if(_char.type == SCRIPTURE_TYPE_EVENT && _char.canSkip) {
				_char.ran = true;
				continue; 
			}
			_char.skip(self)
		}
	}
	
	trimWhiteSpace = function(){
		while(array_length(characters) != 0 && (characters[0].type == SCRIPTURE_TYPE_CHAR && characters[0].char == " "))
			array_delete(characters[0],0,1);
		
		while(array_length(characters) > 1 && (characters[array_length(characters)-1].type == SCRIPTURE_TYPE_CHAR && characters[array_length(characters)-1].char == " "))
			array_delete(characters,array_length(characters)-1,1);
	}
	
	addElement = function(_newElement) {
		if(_newElement.type != SCRIPTURE_TYPE_EVENT)
			width += _newElement.width;
		array_push(characters, _newElement);
		return _newElement;
	}
	
	addElements = function(_elements) {
		for(var _i = 0; _i < array_length(_elements); _i++) {
			array_push(characters, _elements[_i]);	
		}
		calcWidth();
	}
	
	addHyphen = function(_hyphen){
		array_push(characters,_hyphen);
		width += _hyphen.width;
		lastSpace = getLength();
	}
	
	addSpace = function(){
		if(getLength() == 0) return;
		
		var _space = new __scriptureChar(" ", new __scriptureStyle(global.__scripActiveStyle));
		array_push(characters,_space);
		width += _space.width;
		lastSpace = getLength();
	}
	
	calcWidth = function(){
		trimWhiteSpace();
		width = 0;
		for(var _i = 0; _i < array_length(characters); _i++) {
			var _char = characters[_i];
			if(_char.type == SCRIPTURE_TYPE_EVENT) continue;
			
			width += _char.width;
		}
		return width;
	}
	
	calcHeight = function(){
		trimWhiteSpace();	
		height = 0;
		for(var _i = 0; _i < array_length(characters); _i++) {
			var _char = characters[_i];
			if(_char.type == SCRIPTURE_TYPE_EVENT) continue;

			if(_char.height > height) 
				height = _char.height;
		}
		if(height == 0)
			height = string_height("QWERTYUIOPASDFGHJKLZXCVBNM<>,./;'[]{}:\"?");
		return height;
	}
	
	calcDimensions = function(){
		calcWidth();
		calcHeight();
	}
	
	checkForWrap = function() {
		var _textbox = global.__scripTextbox;
		var _result = {didWrap: false, leftovers: []};
		if(_textbox.maxWidth <= 0 || width <= _textbox.maxWidth) return _result
		
		var _lastSpace = _textbox.forceLineBreaks ? 0 : lastSpace;
		if(lastSpace == undefined && _textbox.forceLineBreaks == false) return _result
		var _length = _textbox.forceLineBreaks ? 0 : getLength() - lastSpace;
		_result.didWrap = true;
		array_copy(_result.leftovers, 0, characters, _lastSpace, _length);
		array_delete(characters, _lastSpace, _length);
		
		return _result
	}
}

function __scripturePage() constructor {
	type = SCRIPTURE_TYPE_PAGE
	width = 0;
	height = 0;
	linePos = 0;
	isComplete = false;
	lines = [];
	draw = function(_x, _y) {
		var	_drawX,
		    _drawY = __scriptureApplyVAlign(_y);
	
		for(var _i = 0; _i < getLineCount(); _i++) {
			if(!isComplete && __scriptureIsTyping() && _i > linePos) return false;
			
			var _curLine = lines[_i];
			_drawX = __scriptureApplyHAlign(_x, _curLine);
			if(!_curLine.draw(_drawX, _drawY)) return false;
			
			if(linePos == _i) 
				linePos++;
			_drawY += _curLine.height + global.__scripTextbox.lineSpacing;
		}
		isComplete = true;
		global.__scripDelay = 0;
		return true;
	}
	
	getLineCount = function() {return array_length(lines);}
	
	finishPage = function(_shortcutAnims) {
		isComplete = true;
		linePos = getLineCount();
		for(var _i = 0; _i < getLineCount(); _i++) {
			lines[_i].isComplete = true;
			lines[_i].typePos = 100000;
			lines[_i].delay = 0;
			if(_shortcutAnims) {
				lines[_i].endAnimations();
			}
		}
	}
	
	reset = function() {
		isComplete = false;
		for(var _i = 0; _i < getLineCount(); _i++) {
			lines[_i].reset();	
		}
	}
	
	calcHeight = function() {
		height = 0;
		for(var _i = 0; _i < getLineCount(); _i++) {
			height += lines[_i].calcHeight() + (_i > 0 ? global.__scripTextbox.lineSpacing : 0);
		}

		return height;
	}
	
	calcWidth = function() {
		width = 0;
		for(var _i = 0; _i < getLineCount(); _i++) {
			var _width = lines[_i].calcWidth();
			if(_width > width)
				width = _width;
		}
		return _width;
	}
	
	addLine = function() {
		var _newLine = new __scriptureLine();
		array_push(lines, _newLine)
		return _newLine;
	}
}

function __scriptureText() constructor {
	type = SCRIPTURE_TYPE_TEXT
	width = 0;
	height = 0;
	pages = [];
	curPage = 0;
	//forceRerender = false;
	getPageCount = function() { return array_length(pages) };
	getCurrentPage = function() { return pages[curPage] };
	calcHeight = function() {	
		height = 0;
		for(var _i = 0; _i < getPageCount(); _i++) {
			var _height = pages[_i].calcHeight();
			if(_height > height)
				height = _height;
		}
		return height;
	}
	
	calcWidth = function() {
		width = 0; 
		for(var _i = 0; _i < getPageCount(); _i++) {
			var _width = pages[_i].calcWidth();
			if(_width > width)
				width = _width;
		}
		return width;
	}
	
	calcDimensions = function() {
		calcHeight();
		calcWidth();
	}
	
	getCurPageHeight = function() {
		return pages[curPage].height;	
	}
	
	getCurPageWidth = function() {
		return pages[curPage].width;	
	}
	
	resetFromPage = function(_page) {
		for(var _i = max(0,_page); _i < getPageCount(); _i++) {
			pages[_i].reset();	
		}
	}
	
	setCurrentPage = function(_page, _reset = false) {
		var _prevPage = curPage;
		curPage = clamp(_page,0,getPageCount()-1);
		if(_reset && _prevPage >= curPage)
			resetFromPage(curPage);
	}
	
	incPage = function() {
		if(curPage+1 >= getPageCount()) return false;
		setCurrentPage(curPage+1)
		return true;
	}
	
	decPage = function(_reset = false) {
		if(curPage-1 < 0) return false;
		setCurrentPage(curPage-1)	
		return true;
	}
	
	addPage = function() {
		var _page = new __scripturePage();
		array_push(pages, _page);
		return _page;
	}
}

#endregion

#region Scripture Interal Functions 

function __scriptureStyleNameIsProtected(_key) {
	for(var _i = 0; _i < array_length(global.__scripProtectedKeys); _i++) {
		if(_key == global.__scripProtectedKeys[_i]) {
			throw("Attempted to use a protected Scripture Tag.  Sorry.")
		}
	}
}

function __scriptureStringTrimWhiteSpace(_string) {
	while(string_char_at(_string,1) == " ")
		_string = string_delete(_string, 1, 1);
		
	while(string_char_at(_string, string_length(_string)) == " ")
		_string = string_delete(_string, string_length(_string), 1)
		
	return _string;
}

function __scriptureIsInlineSignifier(_tagContent) {
	var _char = string_char_at(_tagContent,1);
	if(_char == global.__scripImage ||
		 _char == global.__scripFont ||
		 _char == global.__scripKerning ||
		 _char == global.__scripScale ||
		 _char == global.__scripOff ||
		 _char == global.__scripAngle ||
		 _char == global.__scripAlpha ||
		 _char == global.__scripAlign ||
		 _char == global.__scripSpeed ||
		 _char == global.__scripColor) return true;
	return false
}

function __scriptureXYParse(_tagContent) {
	var _x = "";
	while(string_char_at(_tagContent,1) != ",") {
		_x+=string_char_at(_tagContent,1);
		_tagContent = string_delete(_tagContent,1,1);
	}
	_tagContent = string_delete(_tagContent,1,1);
	_tagContent = __scriptureStringTrimWhiteSpace(_tagContent);
	var _y = "";
	while(_tagContent != "") {
		_y+=string_char_at(_tagContent,1);
		_tagContent = string_delete(_tagContent,1,1);
	}
	
	return {x: real(_x), y: real(_y)};
}

function __scriptureMultiParse(_tagContent) {
	var _space = string_pos(" ", _tagContent);
	if(_space == 0) return [];
	var _arguments = string_delete(_tagContent,1,_space);
	var _array = [];
	while(_arguments != "") {
		var _arg = "";
		_arguments = __scriptureStringTrimWhiteSpace(_arguments);
		while(string_char_at(_arguments,1) != "," && _arguments != ""){
			_arg+=string_char_at(_arguments,1);
			_arguments = string_delete(_arguments,1,1);
		}
		_arguments = string_delete(_arguments,1,1);
		array_push(_array,_arg);
	}
	return _array;
}

function __scriptureCheckForInlineStyle(_tagContent, _curLine) {
	_tagContent = __scriptureStringTrimWhiteSpace(_tagContent);
	if(!__scriptureIsInlineSignifier(_tagContent)) return false;
	var _symbol = string_char_at(_tagContent,1);
	_tagContent = string_delete(_tagContent,1,1);
	_tagContent = __scriptureStringTrimWhiteSpace(_tagContent);
	var _active = global.__scripActiveStyle;
	switch(_symbol) {
		case global.__scripColor:
			var _color = scripture_hex_to_color(_tagContent)
			_active.color = _color;
			return true;
		break;
		case global.__scripImage:
			var _val = asset_get_index(_tagContent);
			_curLine.addElement(new __scriptureImg({sprite: _val}))
			return true;
		case global.__scripFont:
			var _val = asset_get_index(_tagContent);
			_active.font = _val;
			return true;
		case global.__scripKerning: 
			var _val = real(_tagContent);
			_active.kerning = _val;
			return true;
		case global.__scripScale: 
			var _val = __scriptureXYParse(_tagContent);
			_active.xScale = _val.x;
			_active.yScale = _val.y;
			return true;
		case global.__scripOff:
			var _val = __scriptureXYParse(_tagContent);
			_active.xOff = _val.x;
			_active.yOff = _val.y;
			return true;
		case global.__scripAngle:
			var _val = real(_tagContent);
			_active.angle = _val;
			return true;
		case global.__scripAlpha:
			var _val = real(_tagContent);
			_active.alpha = _val;
			return true;
		case global.__scripAlign:
			var _val;
			switch(_tagContent) {
				case "fa_top": _val = fa_top; break;
				case "fa_middle":
				case "fa_center": _val = fa_middle; break;
				case "fa_bottom": _val = fa_bottom; break;
			}
			_active.textAlign = _val;
			return true;
		case global.__scripSpeed:
			var _val = real(_tagContent);
			_active.speedMod = max(.0001, _val);
			return true;
	}
	
	return false; //this should never happen...
}

function __scriptureGetTagKey(_tag) {
	var _space = string_pos(" ", _tag);
	if(_space == 0) return _tag;
	var _key = string_delete(_tag,_space,1000);
	return _key;
}

function __scriptureHandleTag(_string, _curLine) {
	var _tagContent = "";
	var _customStyle = {};
	var _isClosingTag = string_char_at(_string,1) == global.__scripEndTag;
	if(_isClosingTag)
		_string = string_delete(_string,1,1);
		
	while(string_char_at(_string,1) != global.__scripCloseTag) {
		_tagContent += string_char_at(_string,1);
		_string = string_delete(_string,1,1);
		
		if(string_char_at(_string,1) == global.__scripOpenTag || string_length(_string) == 0)
			throw("Unclosed Tag Found/n Check your shit, yo.");	
	}
	_string = string_delete(_string,1,1);
	
	var _key = __scriptureGetTagKey(_tagContent)
	
	var _style = global.__scripStyles[$ _key];
	if(_style == undefined) {
		if(__scriptureCheckForInlineStyle(_tagContent, _curLine)) {
			
		} else {
			try {
				var _amount = abs(real(_tagContent));
				if(_amount > 0) 
					_curLine.addElement(new __scriptureEvent(function(){},_amount, false))
			} catch(_ex){
				show_debug_message(_ex);
				show_debug_message("Tag: "+_tagContent+" not a valid style, doofus.");
			}
		}
		return _string;
	}
	switch(_style.type) {
		case SCRIPTURE_TYPE_STYLE:
			if(_isClosingTag) {
				__scriptureDequeueStyle(_tagContent);
				break;
			}
			__scriptureEnqueueStyle(_tagContent);
		break;
						
		case SCRIPTURE_TYPE_IMG: _curLine.addElement(new __scriptureImg(_style)); break;
		case SCRIPTURE_TYPE_EVENT: 
			var _arguments = __scriptureMultiParse(_tagContent)
			_curLine.addElement(new __scriptureEvent(_style.event, 0, _style.canSkip, _arguments)); 
		break;
	}
	

	return _string;
}

function __scriptureRebuildActiveStyle() {
	var _style = {onDrawBegin: [], onDrawEnd: []};
	for(var _i = 0; _i < array_length(global.__scripStyleStack); _i++) {
		var _stackStyle = global.__scripStyleStack[_i];
		var _props = variable_struct_get_names(_stackStyle)
    for(var _j = 0; _j < array_length(_props); _j++) {
      var _prop = _props[_j];
      if(_prop == "key") continue;
			if(_prop == "onDrawBegin") {
				array_push(_style.onDrawBegin, _stackStyle.onDrawBegin);
			} else if(_prop == "onDrawEnd") {
				array_push(_style.onDrawEnd, _stackStyle.onDrawEnd);
			} else {
				_style[$ _prop] = _stackStyle[$ _prop];
			}
    }
	}
	global.__scripActiveStyle = _style;
}

function __scriptureFindStyleIndex(_key){
  for(var _i = 0; _i < array_length(global.__scripStyleStack); _i++) {
    if(global.__scripStyleStack[_i].key == _key) return _i;
  }
  return -1;
}

function __scriptureDequeueStyle(_key) {
	if(array_length(global.__scripStyleStack) <= 1) return;
	
  var _index = __scriptureFindStyleIndex(_key);
  if(_index == -1) return;
  array_delete(global.__scripStyleStack,_index,1);
	__scriptureRebuildActiveStyle();
}

function __scripturePushArrayToStyleStack(_style) {
	array_push(global.__scripStyleStack,_style);
	__scriptureRebuildActiveStyle();
}

function __scriptureEnqueueStyle(_key) {
  var _style = global.__scripStyles[$ _key];
  if(_style == undefined) return;
		
  var _index = __scriptureFindStyleIndex(_key);
  if(_index != -1) return;
		
  __scripturePushArrayToStyleStack(_style);
}

function __scriptureHandleWrapAndPagination(_curLine, _curPage, _forceNewLine = false, _forceNewPage = false) {
	var _wrapResult = _curLine.checkForWrap();
	if(_forceNewLine || _forceNewPage || _wrapResult.didWrap) {
		_curPage.calcHeight();
		if(_forceNewPage || (global.__scripTextbox.maxHeight > 0 && _curPage.height >= global.__scripTextbox.maxHeight)) {
			_curPage = global.__scripText.addPage();
		} 
		
		_curLine = _curPage.addLine();
		_curLine.addElements(_wrapResult.leftovers);
	}
	
	return {curLine: _curLine, curPage: _curPage};
}

function __scriptureParseText(_string, _textbox) {
	global.__scripTextbox = _textbox;
	global.__scripStyleStack = [];
	__scriptureEnqueueStyle(__SCRIPTURE_DEFULT_STYLE_KEY);
	global.__scripText = new __scriptureText();
	var _curPage = global.__scripText.addPage();
	var _curLine = _curPage.addLine();
	
	while(string_length(_string) > 0) {
		var _char = string_char_at(_string,0);
		_string = string_delete(_string,1,1);
		var _forceNewLine = false;
		var _forceNewPage = false;
		switch(_char) {
			case "\r": 
				_forceNewPage = true; 
			break;			
			case "\n": _forceNewLine = true;break;
			case global.__scripOpenTag: _string = __scriptureHandleTag(_string, _curLine); break;
			case "-":	_curLine.addHyphen(new __scriptureChar(_char, new __scriptureStyle(global.__scripActiveStyle))) break;
			case " ": _curLine.addSpace() break;			
			default: _curLine.addElement(new __scriptureChar(_char, new __scriptureStyle(global.__scripActiveStyle)))
		}
		
		//Handle Wrapping
		var _wrapResult = __scriptureHandleWrapAndPagination(_curLine, _curPage, _forceNewLine, _forceNewPage);
		_curLine = _wrapResult.curLine;
		_curPage = _wrapResult.curPage;
	}
	
	global.__scripText.calcDimensions();
	return global.__scripText;
}

function __scriptureApplyVAlign(_y) {
	var _textbox = global.__scripTextbox,
			_text = global.__scripText;
	switch(_textbox.vAlign) {
		case fa_top:    return _y;
		case fa_middle: return _y - floor(_text.getCurPageHeight() / 2 - _textbox.lineSpacing / 2)
		case fa_bottom: return _y - floor(_text.getCurPageHeight()) + _textbox.lineSpacing; 
	}	
}

function __scriptureApplyHAlign(_x, _line) {
	switch(global.__scripTextbox.hAlign) {
		case fa_left: return _x;
		case fa_center: return floor(_x - _line.width / 2); break;
		case fa_right: return _x - _line.width; break;
	}	
}

function __scriptureIsTyping(_textbox = global.__scripTextbox) {
	return _textbox.typeSpeed > 0;	
}

#endregion

	
function scripture_register_style(_key, _style) {
	if(string_count(" ", _key) >= 1) 
		throw("Style Keys cannot contains spaces");
	__scriptureStyleNameIsProtected(_key)
	
	_style.key = _key;
	_style.type = SCRIPTURE_TYPE_STYLE;
	global.__scripStyles[$ _key] = _style;
	return {
		open: global.__scripOpenTag+_key+global.__scripCloseTag,
		close: global.__scripOpenTag+global.__scripEndTag+_key+global.__scripCloseTag
	}		
}

function scripture_register_sprite(_key, _sprite, _style) {
	if(string_count(" ", _key) >= 1) 
		throw("Sprite Keys cannot contains spaces");
	__scriptureStyleNameIsProtected(_key)
	
	if(!sprite_exists(_sprite)) {
		show_debug_message("That's not a sprite, dude.")
		return;
	}
	_style.key = _key;
	_style.type = SCRIPTURE_TYPE_IMG;
	_style.sprite = _sprite;
	
	global.__scripStyles[$ _key] = _style;
	return global.__scripOpenTag + _key + global.__scripCloseTag;
}

function scripture_register_event(_key, _func, _canSkip = true) {
	if(string_count(" ",_key) >= 1) 
		throw("Event Keys cannot contains spaces");
		
	
	global.__scripStyles[$ _key] = {
		key: _key,
		type: SCRIPTURE_TYPE_EVENT,
		event: _func,
		canSkip: _canSkip
	}
	return {
		key: _key,
		event: function() {
			var _string = global.__scripOpenTag + key +" ";
			for(var _i = 0; _i < argument_count; _i++) {
				_string += argument[_i] + (_i == argument_count -1 ? "" : ",")
			}
			_string +=  global.__scripCloseTag
			return _string;
		}
	}
}

function scripture_set_default_style(_key){
	var _style = global.__scripStyles[$ _key];
	if(_style == undefined) return;
	
	global.__scripStyles.defaultStyle = new __scriptureStyle(_style);
	global.__scripStyles.defaultStyle.key = __SCRIPTURE_DEFULT_STYLE_KEY;
}

function scripture_set_tag_characters(_start = global.__scripOpenTag, 
	_end = global.__scripCloseTag,
	_close = global.__scripEndTag,
	_color = global.__scripColor,
	_sprite = global.__scripImage,
  _font = global.__scripFont,
  _kerning = global.__scripKerning,
	_scale = global.__scripScale,
	_offStart = global.__scripOff,
	_angle = global.__scripAngle,
	_alpha = global.__scripAlpha,
	_align = global.__scripAlign,
	_speedMod = global.__scripSpeed) {

		for(var _i = 0; _i< argument_count; _i++) {
			var _arg = argument[_i];
			if(string_length(_arg) != 1) throw("Tags must be a single character only");
			for(var _j = 0; _j < argument_count; _j++) {
				if(_j == _i) continue;
				if(argument[_j] == _arg) throw("Tags must be unique");
			}
		}
	
		global.__scripOpenTag = _start;
		global.__scripCloseTag = _close;
		global.__scripCloseTag = _end;
		global.__scripColor = _color;
		global.__scripImage = _sprite;
		global.__scripFont = _font;
		global.__scripKerning = _kerning;
		global.__scripScale = _scale;
		global.__scripOff = _offStart;
		global.__scripAngle = _angle;
		global.__scripAlpha = _alpha;
		global.__scripAlign = _align;
		global.__scripSpeed = _speedMod;
}

function __scriptureTextBox(_string, _maxWidth, _maxHeight, _hAlign, _vAlign, _typeSpeed, _lineSpacing, _forceLineBreaks) constructor {
	hAlign = _hAlign;
	vAlign = _vAlign;
	typeSpeed = _typeSpeed;
	maxWidth = _maxWidth;
	lineSpacing = _lineSpacing;
	maxHeight = _maxHeight;
	forceLineBreaks = _forceLineBreaks;
	isPaused = false;
	nextPageReady = false;
	
	var _text = __scriptureParseText(_string, self);
	var _pageDimensions = []
	var _widestPageWidth = 0;
	var _tallestPageHeight = 0;
	for(var _i = 0; _i < _text.getPageCount(); _i++){
		var _width = _text.pages[_i].width;
		var _height = _text.pages[_i].height;
		if(_width > _widestPageWidth)
			_widestPageWidth = _width;
		if(_height > _tallestPageHeight)
			_tallestPageHeight = _height;
		array_push(_pageDimensions, {width: _width, height: _height});
	}
	
	maxPageWidth = _widestPageWidth;
	maxPageHeight = _tallestPageHeight;
	pageDimensions = _pageDimensions;
	pageCount = _text.getPageCount();
	text = _text;
	
	getCurrentPageSize = function() {
		return pageDimensions[text.curPage];
	}
	
	getCurrentPage = function() {
		return text.curPage;	
	}
	
	gotoPageNext = function(_shortcutAnimations = true) {
		var _curPage = text.getCurrentPage();
		if(_curPage.isComplete) return text.incPage();

		_curPage.finishPage(_shortcutAnimations)   
		return true;
	}

	gotoPagePrev = function(_reset = true) {
		text.decPage(_reset);
	}

	gotoPage = function(_page, _reset = true) {
		if(_page < 0 || _page >= pageCount) return;
		text.setCurrentPage(_page,_reset);
	}
	
	setPaused = function(_isPaused) {
		isPaused = _isPaused;	
	}
	
	draw = function(_x, _y) {
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		global.__scripTextbox = self;
		global.__scripText = text;
		var _currentPage = text.getCurrentPage();
		_currentPage.draw(_x, _y);
		draw_set_alpha(1);
	
		nextPageReady = _currentPage.isComplete;
	}
}

function scripture_build_textbox(_string, _maxWidth = 0 ,_maxHeight = 0, _hAlign = fa_left, _vAlign = fa_top, _typeSpeed = 0, _lineSpacing = 0, _forceLineBreaks = false, _cacheKey = id){
	return new __scriptureTextBox(_string, _maxWidth, _maxHeight, _hAlign, _vAlign, _typeSpeed, _lineSpacing, _forceLineBreaks, _cacheKey)
}

function scripture_hex_to_color(_hexString) {
	///CONVERSION CODE BASED ON SCRIPTS FROM GMLscripts.com
	///GMLscripts.com/license
	///XOT is a GameMaker Community Legend.  Don't disrespect.
	_hexString = string_lower(_hexString);
	var _dec = 0;
 
  var _dig = "0123456789abcdef";
  var _len = string_length(_hexString);
  for (var _pos = 1; _pos <= _len; _pos++) {
      _dec = _dec << 4 | (string_pos(string_char_at(_hexString, _pos), _dig) - 1);
  }
 
  var _col = (_dec & 16711680) >> 16 | (_dec & 65280) | (_dec & 255) << 16;
  return _col;
}