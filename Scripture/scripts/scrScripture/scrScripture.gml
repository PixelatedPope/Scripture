global.__scriptureCache = {};
global.__scriptureText = {};
global.__scriptureOptions = {};
global.__scriptureString = "";

#region Scripture Constructors
function __scriptureChar(_char, _style={}) constructor{
	char = _char;
	style = _style; 
	steps = 0;
	//TODO: setfont
	width = string_width(char);
	height = string_height(char);
	draw = function(_x, _y){
		draw_text(_x, _y, char);
		return width;
	} //:width
}

function __scriptureLine() constructor {
	width = 0;
	height = 0;
	text = [];
	trimWhiteSpace = function(){
		while(array_length(text) != 0 && text[0].char == " ")
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
	totalHeight = 0;
	text = [];
	typePos = 0;
	pageCompleted = false;
	
	getHeight = function(_start, _count) {
		var _height = 0;
		for(var _i = _start; _i < _start + _count; _i++) {
			if(_i >= array_length(text))
				return _height;
			_height += text[_i].height;
		}
		return _height;
	}
	
	progressType = function(_amount) {
		typePos+=_amount;	
	}
}

#endregion

#region Scripture Interal Functions 

function __scriptureParseText(_string) {
	var _result = new __scriptureText();
	var _curWidth = 0;
	var _curLine = new __scriptureLine();
	_result.text[0] = _curLine;
	var _lastSpace = 0;
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
			case "<": break;//{_text,tag} = __scriptureHandleTag;
			
			case " ":
				var _currentLength = array_length(_curLine.text);
				if(_currentLength == 0) continue;
				
				var _space = new __scriptureChar(_char)
				array_push(_curLine.text,_space);
				_curWidth += _space.width;
				_lastSpace = _currentLength+1;
			break;
			
			default: //Character
				var _newChar = new __scriptureChar(_char);
				_curWidth += _newChar.width;
				array_push(_curLine.text, _newChar);
		}
		
		//Handle Wrapping
		if(_curWidth > global.__scriptureOptions.maxWidth) {
			var _newLine = new __scriptureLine();
			array_push(_result.text,_newLine);
			var _length = array_length(_curLine.text) - _lastSpace;
			array_copy(_newLine.text, 0, _curLine.text, _lastSpace, _length);
			array_delete(_curLine.text, _lastSpace, _length);
			
			_curLine.calcDimensions();
			if(_result.totalWidth < _curLine.width) 
				_result.totalWidth = _curLine.width;
			
			var _lastSpace = 0;
			_curLine = _newLine;
			_curLine.calcDimensions()
			_curWidth = _curLine.width;
		}
	}
	
	_curLine.calcDimensions();
	if(_result.totalWidth < _curLine.width) 
		_result.totalWidth = _curLine.width;
	_result.totalHeight = 0;
	for(var _i = 0; _i < array_length(_result.text); _i++){
		_result.totalHeight += _result.text[_i].height;
	}
	
	return _result;
}

function __scriptureApplyVAlign(_y) {
	var _options = global.__scriptureOptions;
	switch(_options.vAlign) {
		case fa_top:    return _y;
		case fa_bottom: return _y - (_options.maxLines == 0 
																 ? global.__scriptureText.totalHeight 
																 : global.__scriptureText.getHeight(__scriptureGetCurrentLine(), _options.maxLines)); 
		case fa_middle: return _y - (_options.maxLines == 0 
																 ? global.__scriptureText.totalHeight / 2 
																 : global.__scriptureText.getHeight(__scriptureGetCurrentLine(), _options.maxLines)); 
	}	
}

function __scriptureApplyHAlign(_x, _line) {
		switch(global.__scriptureOptions.hAlign) {
			case fa_left: return _x;
			case fa_right: return _x - _line.width; break;
			case fa_center: return _x - _line.width / 2; break;
	}	
}

function __scriptureGetCachedText(_string, _options) {
	global.__scriptureString = _string;
	global.__scriptureOptions = _options;
	var _parsedText = global.__scriptureCache[$ global.__scriptureOptions.cacheKey];
	if(_parsedText == undefined) {
		_parsedText = __scriptureParseText(_string)
		global.__scriptureCache[$ global.__scriptureOptions.cacheKey] = _parsedText;
	}
	
	global.__scriptureText = _parsedText;
}

function __scriptureGetPageCount() {
	return 	floor(array_length(global.__scriptureText.text) / global.__scriptureOptions.maxLines)-1;
}

function __scriptureGetCurrentLine() {
	var _options = global.__scriptureOptions;
	return 	min( _options.currentPage,__scriptureGetPageCount()) * _options.maxLines;
}

function __scriptureIsPageFinished(_cur) {
	var _outOfText = array_length(global.__scriptureText) <= _cur
	var _endOfPage = global.__scriptureOptions.maxLines <= _cur - __scriptureGetCurrentLine()
	return  _outOfText || _endOfPage;
}

function __scriptureIsTyping() {
	return global.__scriptureOptions.typeSpeed > 0;	
}

#endregion

function scripture_advance_page(_options){
	var _text = global.__scriptureCache[$ global.__scriptureOptions.cacheKey];
	if(_text == undefined) return;
	
	_options.currentPage++;
	_options.typePos = 0;
	
}

function draw_scripture(_x, _y, _string, _options){
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	
	__scriptureGetCachedText(_string, _options)
	if(__scriptureIsTyping())
		global.__scriptureText.progressType(_options.typeSpeed);

	var	_drawX,
			_text = global.__scriptureText.text,
			_pos = 0,
		  _drawY = __scriptureApplyVAlign(_y);
	
	
	for(var _l = __scriptureGetCurrentLine(); !__scriptureIsPageFinished(_l); _l++) {
		if(_l == 24)
			__scriptureIsPageFinished(_l);
		_drawX = __scriptureApplyHAlign(_x, _text[_l]);
		var _lineHeight = _text[_l].height;
		for(var _c = 0; _c < array_length(_text[_l].text); _c++) {
			if(__scriptureIsTyping && _pos >= global.__scriptureText.typePos) return;
			
			_char = _text[_l].text[_c];
			_drawX += _char.draw(_drawX,_drawY);
			if(_char.height > _lineHeight) 
				_lineHeight = _char.height;
			_pos++;
		}
		_drawY += _lineHeight + _options.lineSpacing;
	}
	
	return global.__scriptureText;
}