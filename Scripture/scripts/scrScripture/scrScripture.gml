//*************************************************************************
// Hi!  Welcome to Scripture!  Make sure you know what you are doing before
// making any changes in this file. The consequences could be dire!
//
// - Pixelated Pope
//*************************************************************************

global.__scripCache = {};
global.__scripText = {};
global.__scripOptions = {};
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

//You can change these here or use the available function.
global.__scripOpenTag = "<"
global.__scripCloseTag = ">"
global.__scripEndTag = "/"

global.__scripColor = "#"
global.__scripImage = "!"
global.__scripFont = "*"
global.__scripKerning = "_"
global.__scripScale = "$"
global.__scripOffStart = "{"
global.__scripOffEnd = "}"
global.__scripAngle = "~"
global.__scripAlpha = "^"
global.__scripAlign = "?"

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
	onDraw = _style[$ "onDraw"] == undefined ? function(){} : _style.onDraw;
}

global.__scripStyles.defaultStyle = new __scriptureStyle();
global.__scripStyles.defaultStyle.key = __SCRIPTURE_DEFULT_STYLE_KEY;

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
	style = _active;
	steps = 0;
	baseXScale = style.xScale;
	baseYScale = style.yScale;
	baseAlpha = style.alpha;
	style.xScale = 1;
	style.yScale = 1;
	style.alpha = 1;
	width = sprite_get_width(sprite) * baseXScale + style.kerning;
	height = sprite_get_height(sprite) * baseYScale;
	centerX = width/2;
	centerY = height/2;
	
	draw = function(_x, _y, _index) {
		for(var _i = 0; _i < array_length(style.onDraw); _i++) {
			if(style.onDraw[_i](_x, _y, style, self, steps, _index)) break;
		}
		steps++;
		
		draw_sprite_ext(sprite, image, 
										_x + style.xOff + centerX, 
										_y + style.yOff + centerY, 
										baseXScale * style.xScale, 
										baseYScale * style.yScale, 
										style.angle, 
										style.color, 
										baseAlpha * style.alpha);
		image += speed;
		return width;
	}
}

function __scriptureEvent(_func, _delay = 0) constructor {
	type = SCRIPTURE_TYPE_EVENT;
	event = _func;
	isSpace = false;
	style = {speedMod:1};
	ran = false;
	delay = _delay;
	draw = function(_x, _y, _index){
		if(ran) return 0;
		ran = true;
		event();
		if(delay > 0) 
			global.__scripDelay = delay;
		return 0;
	}
}

function __scriptureChar(_char, _style = new __scriptureStyle()) constructor {
	type = SCRIPTURE_TYPE_CHAR
	char = _char;
	isSpace = _char == " ";
	style = _style; 
	steps = 0;
	draw_set_font(style.font);
	baseXScale = _style.xScale;
	baseYScale = _style.yScale;
	width = string_width(char) * baseXScale + style.kerning;
	height = string_height(char) * baseYScale;
	centerX = width / 2;
	centerY = height / 2;
	baseXOff = _style.xOff;
	baseYOff = _style.yOff;
	_style.xOff = 0;
	_style.yOff = 0;
	_style.xScale = 1;
	_style.yScale = 1;
	
	draw = function(_x, _y, _index, _line) {
		
		//if(isSpace) return width;
		var _drawX = floor(_x + centerX) + baseXOff;
		var _drawY = floor(_y + centerY) + baseYOff;
		
		switch(style.textAlign) {
			case fa_top: break;
			case fa_middle: _drawY += floor(_line.height/2 - centerY); break;
			case fa_bottom: _drawY += floor(_line.height - centerY * 2); break;
		}
		
		draw_set_font(style.font);
		draw_set_color(style.color);
		draw_set_alpha(style.alpha);
		
		for(var _i = 0; _i < array_length(style.onDraw); _i++) {
			if(style.onDraw[_i](_drawX, _drawY, style, self, steps, _index)) break;	
		}
		steps += !global.__scripOptions.isPaused;
		_drawX += style.xOff;
		_drawY += style.yOff;
		
		draw_set_font(style.font);
		draw_set_color(style.color);
		draw_set_alpha(style.alpha);
		draw_text_transformed(_drawX, _drawY, char, baseXScale * style.xScale, baseYScale * style.yScale, style.angle);
		return width;
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
				if(!global.__scripOptions.isPaused)
					typePos += global.__scripOptions.typeSpeed * characters[_c-1].style.speedMod;
					_eventCount += characters[_c].type = SCRIPTURE_TYPE_EVENT;
				return false;
			}
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
			_char.steps = 0;
			switch(_char.type) {
				case SCRIPTURE_TYPE_EVENT:
					_char.ran = false;
				break;
				case SCRIPTURE_TYPE_IMG:
					_char.image = 0;
				break;
			}
		}
	}
	
	endAnimations = function() {
		for(var _c = 0; _c < getLength(); _c++) {
			var _char = characters[_c];
			if(_char.type == SCRIPTURE_TYPE_EVENT) continue; //Skip events when completing drawing.
			if(_char.steps == 0)
				_char.draw(-100000,-10000, 0, self);
			_char.steps = 100000;	
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
		var _options = global.__scripOptions;
		var _result = {didWrap: false, leftovers: []};
		if(_options.maxWidth <= 0 || width <= _options.maxWidth) return _result
		
		var _lastSpace = _options.forceLineBreaks ? 0 : lastSpace;
		if(lastSpace == undefined && _options.forceLineBreaks == false) return _result
		var _length = _options.forceLineBreaks ? 0 : getLength() - lastSpace;
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
			_drawY += _curLine.height + global.__scripOptions.lineSpacing;
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
			height += lines[_i].calcHeight() + (_i > 0 ? global.__scripOptions.lineSpacing : 0);
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
			show_debug_message("Attempted to use a protected Scripture Tag.  Sorry.")
			return true;	
		}
	}
	return false;
}

function __scriptureStringTrimWhiteSpace(_string) {
	while(string_char_at(_string,1) == " ")
		_string = string_delete(_string, 1, 1);
		
	while(string_char_at(_string, string_length(_string)) == " ")
		_string = string_delete(_string, string_length(_string), 1)
		
	return _string;
}

function __scriptureHexToColor(_hex) {
	///CONVERSION CODE BASED ON SCRIPTS FROM GMLscripts.com
	///GMLscripts.com/license
	///XOT is a GameMaker Community Legend.  Don't disrespect.
	
	var _dec = 0;
 
  var _dig = "0123456789ABCDEF";
  var _len = string_length(_hex);
  for (var _pos = 1; _pos <= _len; _pos++) {
      _dec = _dec << 4 | (string_pos(string_char_at(_hex, _pos), _dig) - 1);
  }
 
  var _col = (_dec & 16711680) >> 16 | (_dec & 65280) | (_dec & 255) << 16;
  return _col;
}

function __scriptureIsInlineSignifier(_tagContent) {
	var _char = string_char_at(_tagContent,1);
	if(_char == global.__scripImage ||
		 _char == global.__scripFont ||
		 _char == global.__scripKerning ||
		 _char == global.__scripScale ||
		 _char == global.__scripOffStart ||
		 _char == global.__scripOffEnd ||
		 _char == global.__scripAngle ||
		 _char == global.__scripAlpha ||
		 _char == global.__scripAlign ||
		 _char == global.__scripColor) return true;
	return false
}

function __scriptureCheckForInlineStyle(_tagContent, _curLine) {
	_tagContent = __scriptureStringTrimWhiteSpace(_tagContent);
	if(!__scriptureIsInlineSignifier(_tagContent)) return false;
	var _symbol = string_char_at(_tagContent,1);
	_tagContent = string_delete(_tagContent,1,1);
	_tagContent = __scriptureStringTrimWhiteSpace(_tagContent);
	switch(_symbol) {
		case global.__scripColor:
			var _color = __scriptureHexToColor(_tagContent)
			__scripturePushArrayToStyleStack(new __scriptureStyle({color: _color}));
			return true;
		break;
		case global.__scripImage:
			var _sprite = asset_get_index(_tagContent);
			_curLine.addElement(new __scriptureImg({sprite: _sprite}))
			return true;
		case global.__scripFont:
		case global.__scripKerning:
		case global.__scripScale:
		case global.__scripOffStart:
		case global.__scripOffEnd:
		case global.__scripAngle:
		case global.__scripAlpha:
		case global.__scripAlign:
	}
	
	return false; //this should never happen...
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
		
		if(string_char_at(_string,1) == global.__scripOpenTag || string_length(_string) == 0) {
			show_message("Unclosed Tag Found/n Check your shit, yo.");	
			game_end();
		}
	}
	_string = string_delete(_string,1,1);
	
	var _style = global.__scripStyles[$ _tagContent];
	if(_style == undefined) {
		if(__scriptureCheckForInlineStyle(_tagContent, _curLine)) {
			
		} else {
			try {
				var _amount = abs(real(_tagContent));
				if(_amount > 0) 
					_curLine.addElement(new __scriptureEvent(function(){},_amount))
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
		case SCRIPTURE_TYPE_EVENT: _curLine.addElement(new __scriptureEvent(_style.event)); break;
	}
	

	return _string;
}

function __scriptureRebuildActiveStyle() {
	var _style = {onDraw: []};
	for(var _i = 0; _i < array_length(global.__scripStyleStack); _i++) {
		var _stackStyle = global.__scripStyleStack[_i];
		var _props = variable_struct_get_names(_stackStyle)
    for(var _j = 0; _j < array_length(_props); _j++) {
      var _prop = _props[_j];
      if(_prop == "key") continue;
			if(_prop == "onDraw") {
				array_push(_style.onDraw,_stackStyle.onDraw);
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
		if(_forceNewPage || (global.__scripOptions.maxHeight > 0 && _curPage.height >= global.__scripOptions.maxHeight)) {
			_curPage = global.__scripText.addPage();
		} 
		
		_curLine = _curPage.addLine();
		_curLine.addElements(_wrapResult.leftovers);
	}
	
	return {curLine: _curLine, curPage: _curPage};
}

function __scriptureParseText(_string) {
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
			case "\b": 
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
	var _options = global.__scripOptions,
			_text = global.__scripText;
	switch(_options.vAlign) {
		case fa_top:    return _y;
		case fa_middle: return _y - floor(_text.getCurPageHeight() / 2 - _options.lineSpacing / 2)
		case fa_bottom: return _y - floor(_text.getCurPageHeight()) + _options.lineSpacing; 
	}	
}

function __scriptureApplyHAlign(_x, _line) {
	switch(global.__scripOptions.hAlign) {
		case fa_left: return _x;
		case fa_center: return floor(_x - _line.width / 2); break;
		case fa_right: return _x - _line.width; break;
	}	
}

function __scriptureGetCachedText(_string, _options) {
	global.__scripString = _string;
	global.__scripOptions = _options;
	var _parsedText = global.__scripCache[$ _options.key];
	if(_parsedText == undefined) {
		_parsedText = __scriptureParseText(_string)
		global.__scripCache[$ _options.key] = _parsedText;
	}
	
	global.__scripText = _parsedText;
}

function __scriptureIsTyping(_options = global.__scripOptions) {
	return _options.typeSpeed > 0;	
}

#endregion

function draw_scripture(_x, _y, _string, _options) {
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	__scriptureGetCachedText(_string, _options)
	
	var _currentPage = global.__scripText.getCurrentPage();
	_currentPage.draw(_x, _y);
	draw_set_alpha(1);
	
	var _cur = global.__scripText;
	return {
		width: _cur.getCurPageWidth(),
		height: _cur.getCurPageHeight(),
		currentPage: _cur.curPage,
		pageCount: _cur.getPageCount(),
		nextPageReady: _currentPage.isComplete
	}
}


function scripture_next_page(_options, _shortcutAnimations = true) {
	var _text = global.__scripCache[$ _options.key];
  if(_text == undefined) return;
	var _curPage = _text.getCurrentPage();
	
	if(_curPage.isComplete) return _text.incPage();

	_curPage.finishPage(_shortcutAnimations)   
  return true;
}

function scripture_prev_page(_options, _reset = true) {
	var _text = global.__scripCache[$ _options.key];
  if(_text == undefined || _page < 0) return;
	
	_text.decPage(_reset);
}

function scripture_jump_to_page(_options, _page, _reset = true) {
	var _text = global.__scripCache[$ _options.key];
  if(_text == undefined) return;
	if(_page < 0 || _page >= _text.getPageCount()) return;
	_text.setCurrentPage(_page,_reset);
}
	
function scripture_register_style(_key, _style) {
	if(__scriptureStyleNameIsProtected(_key)) return;
	_style.key = _key;
	_style.type = SCRIPTURE_TYPE_STYLE;
	global.__scripStyles[$ _key] = _style;
	return {
		open: global.__scripOpenTag+_key+global.__scripCloseTag,
		close: global.__scripOpenTag+global.__scripEndTag+_key+global.__scripCloseTag
	}		
}

function wait(_steps) {
	return global.__scripOpenTag+string(_steps)+global.__scripCloseTag;
}

function scripture_register_sprite(_key, _sprite, _style) {
	if(__scriptureStyleNameIsProtected(_key)) return;
	
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

function scripture_register_event(_key, _func) {
	global.__scripStyles[$ _key] = {
		key: _key,
		type: SCRIPTURE_TYPE_EVENT,
		event: _func
	}
	return global.__scripOpenTag + _key + global.__scripCloseTag;
}

function scripture_set_default_style(_key){
	var _style = global.__scripStyles[$ _key];
	if(_style == undefined) return;
	
	global.__scripStyles.defaultStyle = new __scriptureStyle(_style);
	global.__scripStyles.defaultStyle.key = __SCRIPTURE_DEFULT_STYLE_KEY;
}

function scripture_clear_cache(_key = id) {
	
	if(global.__scripCache[$ _key] == undefined)
		global.__scripCache = {}
	else
		variable_struct_remove(global.__scripCache, _key);
}

function scripture_set_tag_characters(_start = global.__scripOpenTag, 
	_end = global.__scripCloseTag,
	_close = global.__scripEndTag,
	_color = global.__scripColor,
	_sprite = global.__scripImage,
  _font = global.__scripFont,
  _kerning = global.__scripKerning,
	_scale = global.__scripScale,
	_offStart = global.__scripOffStart,
	_offEnd = global.__scripOffEnd,
	_angle = global.__scripAngle,
	_alpha = global.__scripAlpha,
	_align = global.__scripAlign) {

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
		global.__scripOffStart = _offStart;
		global.__scripOffEnd = _offEnd;
		global.__scripAngle = _angle;
		global.__scripAlpha = _alpha;
		global.__scripAlign = _align;
}

function scripture_build_options(_maxWidth = 0 ,_maxHeight = 0, _hAlign = fa_left, _vAlign = fa_top, _typeSpeed = 0, _lineSpacing = 0, _forceLineBreaks = false, _cacheKey = id){
	return {
		key: _cacheKey == undefined ? id : _cacheKey,
		hAlign: _hAlign,
		vAlign: _vAlign,
		typeSpeed: _typeSpeed, 
		maxWidth: _maxWidth,
		lineSpacing: _lineSpacing,
		maxHeight: _maxHeight,
		forceLineBreaks: _forceLineBreaks,
		isPaused: false
	}
}