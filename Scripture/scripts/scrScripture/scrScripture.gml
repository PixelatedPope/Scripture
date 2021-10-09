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
global.__scripProtectedKeys = ["default",__SCRIPTURE_DEFULT_STYLE_KEY,"img"];
global.__scripStyleStack = [];
global.__scripActiveStyle = {};

#macro __SCRIPTURE_DEFULT_STYLE_KEY "defaultStyle"

#region Scripture Constructors
function __scriptureStyle(_style = undefined) constructor {
	
	if(_style == undefined) {
			color = c_white;
			font = -1;
			onDraw = function(){};
			return;
	}
	//Return a duplicate of the given style with new key
	color = _style.color;
	font = _style.font;
	onDraw = _style.onDraw;
}

function __scriptureImg(_spr, _style = new __scriptureStyle()) constructor {
	sprite = _spr;
	image = 0;
	speed = sprite_get_speed_type(_spr) == spritespeed_framespergameframe ? sprite_get_speed(sprite) : sprite_get_speed(sprite) / room_speed;
	style = _style;
	steps = 0;
	
	width = sprite_get_width(sprite);
	height = sprite_get_height(sprite);
	centerX = width/2;
	centerY = height/2;
	originX = sprite_get_xoffset(sprite);
	originY = sprite_get_yoffset(sprite);
	alpha = 1;
	xScale = 1;
	yScale = 1;
	xOff = 0;
	yOff = 0;
	angle = 0;
	
	draw = function(_x, _y, _index, _lineHeight) {
		for(var _i = 0; _i < array_length(style.onDraw); _i++) {
			style.onDraw[_i](self,steps, _index);	
		}
		steps++;
		
		draw_sprite_ext(sprite, image, 
										_x + centerX + xOff, 
										_y + centerY + yOff, 
										xScale, yScale, angle, style.color, alpha);
		image += speed;
		return width;
	} //:width
}

function __scriptureChar(_char, _style = new __scriptureStyle()) constructor {
	char = _char;
	style = _style; 
	steps = 0;
	draw_set_font(style.font);
	width = string_width(char);
	height = string_height(char);
	centerX = width/2;
	centerY = height/2;
	alpha = 1;
	xScale = 1;
	yScale = 1;
	xOff = 0;
	yOff = 0;
	angle = 0;
	
	draw = function(_x, _y, _index, _lineHeight){
		for(var _i = 0; _i < array_length(style.onDraw); _i++) {
			style.onDraw[_i](self,steps, _index);	
		}
		
		steps++;
		if(global.__scripOptions.vAlign == fa_middle) {
			var _height = height;
			var _break = true;	
		}
		draw_set_font(style.font);
		draw_set_color(style.color);
		draw_set_alpha(alpha);
		draw_text_transformed(_x + centerX + xOff, 
													_y + centerY + yOff + _lineHeight - height, 
													char, xScale, yScale, angle);
		return width;
	} //:width
}

function __scriptureLine() constructor {
	width = 0;
	height = 0;
	text = [];
	trimWhiteSpace = function(){
		while(array_length(text) != 0 && (variable_struct_exists(text[0],"char") && text[0].char == " "))
			array_delete(text[0],0,1);
		
		while(array_length(text) > 1 && text[array_length(text)-1].char == " ")
			array_delete(text,array_length(text)-1,1);
			
	}
	
	calcDimensions = function(){
		trimWhiteSpace();
		width = 0;
		for(var _i = 0; _i < array_length(text); _i++) {
			var _char = text[_i];
			width += _char.width;
			if(_char.height > height) height = _char.height;
		}
		if(height == 0)
			height = string_height("QWERTYUIOPASDFGHJKLZXCVBNM<>,./;'[]{}:\"?");
	}
	
}

function __scriptureText() constructor {
	totalWidth = 0;
	text = [];
	typePos = 0;
	getLength = function() { return array_length(text) }
	//getTotalCharacters = function() {
	//	var _count = 0;
	//	for(var _i = 0; _i < getLength(); _i++) {
	//		_count += array_length(text[_i].text);
	//	}
	//	return _count;
	//}
	
	//getCharactersOnPage = function(_options) {
	//	if(_options.maxLines <= 0) return getTotalCharacters();
		
	//	var _curPage = _options.currentPage;
	//	var _maxLines = _options.maxLines;
	//	var _cur = __scriptureGetCurrentLine(id, _options);
	//	for(var _l = _cur; 
	//}
	
	getHeight = function() {
		var _start = __scriptureGetCurrentLine(),
				_count = global.__scripOptions.maxLines,
				_height = 0;
		for(var _i = _start; _i < _start + _count; _i++) {
			if(_i >= array_length(text))
				return _height;
			_height += text[_i].height + global.__scripOptions.lineSpacing;
		}
		return _height;
	}
	
	getTotalHeight = function() {	
		var _height = 0;
		for(var _i = 0; _i < array_length(text); _i++){
			_height += text[_i].height + global.__scripOptions.lineSpacing;
		}
		
		return _height;
	}
	
	progressType = function(_amount) {
		typePos+=_amount;	
	}
}

#endregion

#region Scripture Interal Functions 

function __scripture_style_name_is_protected(_key) {
	for(var _i = 0; _i < array_length(global.__scripProtectedKeys); _i++) {
		if(_key == global.__scripProtectedKeys[_i]) return true;	
	}
	return false;
}

function __scriptureHandleTag(_string) {
	var _tagContent = "";
	var _isClosingTag = string_char_at(_string,1) == "/";
	var _isImageTag = false;
	if(_isClosingTag)
		_string = string_delete(_string,1,1);
		
	while(string_char_at(_string,1) != ">") {
		_tagContent += string_char_at(_string,1);
		_string = string_delete(_string,1,1);
		
		if(string_char_at(_string,1) == " " && _tagContent == "img"){
			_tagContent = "";	
			_isImageTag = true;
			_string = string_delete(_string,1,1);
		}
		
		if(string_char_at(_string,1) == "<" || string_length(_string) == 0) {
			show_message("Unclosed Tag Found/n Check your shit, yo.");	
			game_end();
		}
	}
	_string = string_delete(_string,1,1);

	return {tag: _tagContent, updatedString: _string, isClosingTag: _isClosingTag, isImageTag: _isImageTag}
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

function __scriptureEnqueueStyle(_key) {
  var _style = global.__scripStyles[$ _key];
  if(_style == undefined) return;
		
  var _index = __scriptureFindStyleIndex(_key);
  if(_index != -1) return;
		
  array_push(global.__scripStyleStack,_style);
	__scriptureRebuildActiveStyle();
}

function __scriptureParseText(_string) {
	global.__scripStyleStack = [];
	__scriptureEnqueueStyle(__SCRIPTURE_DEFULT_STYLE_KEY);
	var _result = new __scriptureText();
	var _curWidth = 0;
	var _curLine = new __scriptureLine();
	_result.text[0] = _curLine;
	var _lastSpace = undefined;
	while(string_length(_string) > 0) {
		var _char = string_char_at(_string,0);
		_string = string_delete(_string,1,1);
		switch(_char) {
			case "\n": 
				var _newLine = new __scriptureLine();
				array_push(_result.text,_newLine);
				_curLine.calcDimensions()
				_curWidth = 0;
				_curLine = _newLine;
				continue;
			break;
			case "<": 
				var _tagResult = __scriptureHandleTag(_string);
				_string = _tagResult.updatedString;
				if(_tagResult.isImageTag) {
					var _spr = asset_get_index(_tagResult.tag);
					if(_spr == -1 || !sprite_exists(_spr)) continue;
					var _newImg = new __scriptureImg(_spr, new __scriptureStyle(global.__scripActiveStyle));
					_curWidth += _newImg.width;
					array_push(_curLine.text, _newImg);
				} else {
					//Style
					if(global.__scripStyles[$ _tagResult.tag] == undefined) continue;
						
					if(_tagResult.isClosingTag) {
						__scriptureDequeueStyle(_tagResult.tag);
					} else {
						__scriptureEnqueueStyle(_tagResult.tag);
					}
				}
			break;
			
			case "-":				
				var _hyphen = new __scriptureChar(_char)
				array_push(_curLine.text,_hyphen);
				_curWidth += _hyphen.width;
				_lastSpace = array_length(_curLine.text);
			break;
			
			case " ":
				var _currentLength = array_length(_curLine.text);
				if(_currentLength == 0) continue;
				
				var _space = new __scriptureChar(_char)
				array_push(_curLine.text,_space);
				_curWidth += _space.width;
				_lastSpace = _currentLength+1;
			break;
			
			default: //Character
				var _newChar = new __scriptureChar(_char, new __scriptureStyle(global.__scripActiveStyle));
				_curWidth += _newChar.width;
				array_push(_curLine.text, _newChar);
		}
		
		//Handle Wrapping
		if(_lastSpace != undefined && _curWidth > global.__scripOptions.maxWidth) {
			var _newLine = new __scriptureLine();
			array_push(_result.text,_newLine);
			var _length = array_length(_curLine.text) - _lastSpace;
			array_copy(_newLine.text, 0, _curLine.text, _lastSpace, _length);
			array_delete(_curLine.text, _lastSpace, _length);
			
			_curLine.calcDimensions();
			if(_result.totalWidth < _curLine.width) 
				_result.totalWidth = _curLine.width;
			
			_lastSpace = undefined;
			_curLine = _newLine;
			_curLine.calcDimensions()
			_curWidth = _curLine.width;
		}
	}
	
	_curLine.calcDimensions();
	if(_result.totalWidth < _curLine.width) 
		_result.totalWidth = _curLine.width;
	
	return _result;
}

function __scriptureApplyVAlign(_y) {
	var _options = global.__scripOptions,
			_text = global.__scripText;
	switch(_options.vAlign) {
		case fa_top:    return _y;
		
		case fa_middle: return _y - (_options.maxLines <= 0 
																 ? floor(_text.getTotalHeight() / 2 - _options.lineSpacing / 2)
																 : floor(_text.getHeight() / 2  - _options.lineSpacing / 2)); 
																 
		case fa_bottom: return _y - (_options.maxLines <= 0 
																 ? floor(_text.getTotalHeight())
																 : floor(_text.getHeight()) + _options.lineSpacing); 
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
	var _parsedText = global.__scripCache[$ _options.cacheKey];
	if(_parsedText == undefined) {
		_parsedText = __scriptureParseText(_string)
		global.__scripCache[$ _options.cacheKey] = _parsedText;
	}
	
	global.__scripText = _parsedText;
}

function __scriptureGetPageCount(_text = global.__scripText, _options = global.__scripOptions) {
	return 	floor(_text.getLength() / _options.maxLines);
}

function __scriptureGetCurrentLine(_text = global.__scripText, _options = global.__scripOptions) {
	return 	min( _options.currentPage, __scriptureGetPageCount(_text, _options)) * _options.maxLines;
}

function __scriptureIsPageFinished(_cur) {
	//Be very sure when you clean up this logic, idiot.
	var _length = global.__scripText.getLength();	
	if(_length <= _cur) return true;
	
	var _isPaginated = global.__scripOptions.maxLines > 0;
	var _curLineNum = _cur - __scriptureGetCurrentLine();
	var _linePerPage = global.__scripOptions.maxLines;
		
	return _isPaginated ? _curLineNum >= _linePerPage : _length <= _cur;
}

function __scriptureIsTyping(_options = global.__scripOptions) {
	return _options.typeSpeed > 0;	
}

#endregion

function draw_scripture(_x, _y, _string, _options) {
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	__scriptureGetCachedText(_string, _options)
	
	if(__scriptureIsTyping())
		global.__scripText.progressType(_options.typeSpeed);
		
	global.__scripText.complete = false;
	var	_drawX,
			_text = global.__scripText.text,
			_pos = 0,
		  _drawY = __scriptureApplyVAlign(_y);
	
	for(var _l = __scriptureGetCurrentLine(); !__scriptureIsPageFinished(_l); _l++) {
		_drawX = __scriptureApplyHAlign(_x, _text[_l]);
		var _lineHeight = _text[_l].height;
		for(var _c = 0; _c < array_length(_text[_l].text); _c++) {
			if(__scriptureIsTyping() && _pos >= global.__scripText.typePos) return;
			
			_char = _text[_l].text[_c];
			_drawX += _char.draw(_drawX,_drawY,_pos,_lineHeight);
			_pos++;
		}
		_drawY += _lineHeight + _options.lineSpacing;
	}
	
	global.__scripText.complete = true;
	draw_set_alpha(1);
}


function scripture_advance_page(_options) {
	var _text = global.__scripCache[$ _options.cacheKey];
	if(_text == undefined) return;

	//finish typing this page
	if(__scriptureIsTyping(_options) && !_text.complete) {
		_text.typePos = infinity;
		return true;
	} else if(_options.maxLines > 0 && _options.currentPage < __scriptureGetPageCount(_text,_options )){
		_options.currentPage++;
		_text.typePos = 0;
		_text.complete = false;
		return true;
	}
	return false;
}
	
function scripture_add_style(_key, _style) {
	if(__scripture_style_name_is_protected(_key) || global.__scripStyles[$ _key] != undefined) {
		show_debug_message("Style keys must be unique")
		return;
	}
	_style.key = _key;
	global.__scripStyles[$ _key] = _style;
}

function scripture_set_default_style(_style){
	global.__scripStyles.defaultStyle = _style;
	global.__scripStyles.defaultStyle.key = "defaultStyle";
}
scripture_set_default_style(new __scriptureStyle());

function scripture_clear_cache(_key = undefined) {
	if(_key == undefined)
		global.__scripCache = {}
	else
		variable_struct_remove(global.__scripCache, _key);
}